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