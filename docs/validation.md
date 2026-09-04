# Data Quality & Hygiene Policies

## Validation & Data Quality
Data quality is enforced across a dual-layered framework. Applying data hygiene policies in the Silver layer prevents bad or malformed records from corrupting downstream dimensional models. Complementing this, business rule checks in the Gold layer enforce dimensional model integrity, verify key relationships, and ensure analytical metrics remain mathematically sound following transformation.

---

## Data Hygiene (Silver Layer)
- Convert raw text into correct physical formats (e.g., numeric strings to `Integer`).
- Strip leading/trailing whitespace, remove invalid characters, and enforce consistent casing (`INITCAP`).
- Confirm numbers make business sense by filtering out invalid values like *zero or negative quantities*.
- Enforce strict non-null checks on essential primary and foreign keys (`product_id`, `order_id`).

## Business Rule Checks (Gold Layer)
- Run `LEFT JOIN` checks between *fact* and *dimension* tables to identify unmapped foreign keys.
- Ensure primary keys in dimension tables are strictly unique (`COUNT(DISTINCT key) == COUNT(key)`).
- Compare *total products ordered* and *row counts* between Silver and Gold tables to prove zero data was accidentally lost during modeling.

---

## Data Quality Audit Queries

### Referential Integrity
Checks if any transaction in `fact_table` fails to map to a dimension table. Returns individual rows with boolean flags indicating which foreign key failed.

```sql
SELECT 
  f.order_id,
  f.product_id,
  f.aisle_id,
  (o.order_id IS NULL) AS is_missing_order,
  (p.product_id IS NULL) AS is_missing_product,
  (a.aisle_id IS NULL) AS is_missing_aisle
FROM instacart.instacart_mart.fact_table AS f
LEFT JOIN instacart.instacart_mart.dim_order AS o 
  ON f.order_id = o.order_id
LEFT JOIN instacart.instacart_mart.dim_product AS p 
  ON f.product_id = p.product_id
LEFT JOIN instacart.instacart_mart.dim_aisle AS a 
  ON f.aisle_id = a.aisle_id
WHERE o.order_id IS NULL
   OR p.product_id IS NULL
   OR a.aisle_id IS NULL;
```
## Data Quality Audit Findings

### Bronze / Raw Layer
* **Missing Aisle and Department:** Retained records with missing aisle/department IDs because active products utilize these values.
* **Product ID 6816:** Contains `NULL` `aisle_id` and `department_id`; retained because it appears in historical purchase orders.
* **Audit Summary:** Zero duplicate rows detected.

### Silver / Clean Layer
* **Aisles & Departments:** Confirmed zero `NULL` values and zero duplicate records.
* **Order Products (`train` / `prior`):** Validated composite primary keys (`order_id`, `product_id`); multiple rows per `order_id` are expected as each row represents an individual product line item in an order.
* **Orders:** Validated one-to-many relationship where a single `user_id` can associate with multiple orders.
* **Null Handling:** `days_since_prior_order` contains expected `NULL` values for a user's initial order, and `0` for subsequent orders placed on the same day.
* **Products:** Retained `product_id = 6816` with `NULL` `aisle_id` and `department_id`.
* **Audit Summary:** Zero duplicate rows detected.

### Gold / Mart Layer
* **Dimensions:** Confirmed zero duplicate primary keys and zero `NULL` primary keys across all dimension tables.
* **Facts:** Confirmed zero duplicate primary keys and zero `NULL` primary keys/foreign keys in the fact table.
* **Audit Summary:**
  * Zero duplicate rows detected.
  * **Zero Orphan Records:** Handled `NULL` `aisle_id` and `department_id` foreign keys by setting them to surrogate key `-1`. These map directly to `'Unassigned'` placeholder rows in `dim_aisle` and `dim_product`
