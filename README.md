# instacart-pipeline

## Project Overview
End-to-end data engineering pipeline and dimensional model for the Instacart dataset implemented for Databricks using a medallion architecture (Bronze → Silver → Gold). The pipeline ingests raw Instacart export files, applies cleaning and validation rules, and builds a star schema optimized for analytics and BI reporting.

The project transforms metrics into actionable business intelligence to guide operational and merchandising strategy:
* **Demand Forecasting & Resource Allocation:** Maps hourly order surges (peak **10 AM–3 PM**, weekend-heavy) to optimize delivery fulfillment capacity and server workloads.
* **Inventory Management:** Identifies core, high-reorder daily staples (e.g., **Milk**, **Fresh Fruits**, **Eggs**).
* **Customer Retention & Assortment Strategy:** Isolates niche, high-loyalty products (e.g., *Raw Veggie Wraps*, *Chocolate Love Bar*) with near-100% reorder rates to drive targeted product placement.

This repository contains the SQL used for each stage (ingest, clean, model, and analytics) and documentation describing the architecture, data model, and validation rules. See `docs/` for more details.


## Key Findings
* **Peak Ordering Hours:** Order volume surges during midday hours between **10 AM and 3 PM**. Early morning hours (1 AM to 5 AM) show the lowest activity.
* **Top Reordered Aisles:** Daily staples dominate repeat purchase rates. The **milk** aisle leads all categories (\~78% reorder rate), followed closely by **water/seltzer/sparkling water**, **fresh fruits**, **eggs**, and **soy/lactose-free** products (\~70%–73%).
* **Product Reorder Dynamics:** Specific items achieve high reorder rates (near 90%+), including **Raw Veggie Wraps**, **Serenity Ultimate Extrema Overnight Pads**, and **Chocolate Love Bar**. Comparing total orders to reorder rates demonstrates that these products maintain near-100% customer retention despite moderate overall order counts (ranging between 100 and 200 total orders).
* **Top Products & Category Distribution:** **Beverages** (*Green Tea With Ginseng And Honey*) leads overall order frequency among top products. **Dairy & Eggs** items represent the vast majority of the top-ranked individual products by order count, including varieties of milk, butter, cheese slices, and cottage cheese.

## Project Architecture and Structure
This pipeline follows the Medallion Architecture:

- Bronze (raw): file-level ingestion of the original Instacart CSV files.
- Silver (clean): deduplication, type casting, and normalization.
- Gold (mart): dimensional modeling using star schema and aggregated tables for analytics.

See [`docs/architecture.md`](docs/architecture.md) for an in-depth explanation of the architecture.
```text
├── docs/
│   ├── architecture.md       # Pipeline architecture and end-to-end data flow
│   ├── data-model.md         # Star schema, table relationships, and column definitions
│   ├── decisions.md          # Key architectural and design decisions (ADRs)
│   └── validation.md         # Data quality rules and validation checks
│
└── src/
    └── sql/
        ├── 00_setup/         # Database setup 
        ├── 01_raw/           # Bronze layer: Raw data ingestion (1 file per table)
        ├── 02_clean/         # Silver layer: Data cleaning and transformations
        ├── 03_mart/          # Gold layer: Dimensional modeling (dim_* and fact_*)
        ├── 04_visualization/ # Analytics layer: Aggregated queries for dashboards
        └── 05_validation/    # Validation: Contains data quality checks for each layer
```


## Data Model
The pipeline uses a star schema focusing on the product, order and aisle dimensions. \
See [`docs/data-model.md`](docs/data-model.md) for  column-level descriptions and the exact star diagram.
- **Dimensions (dim_*)**
  - dim_product - product and departmenr attributes 
  - dim_order - order attributes and purchasing time and dates
  - dim_aisle - aisle attributes
- **Fact table**
  - fact_order_products - grain: one row per product order.\
   This is the primary fact used by the visualization queries.


## How to Run
### Prerequisites
- Databricks workspace or any Spark SQL-capable environment.
- Access to Chinook source files or a source database.
- Git and an environment where you can run SQL or place SQL files into Databricks notebooks / jobs.

### Steps
1. **Clone the repo:** \
   git clone https://github.com/razzelleb/instacart-pipeline

2. **Prepare environment:**
   - Connect the GitHub Repository to your Databricks
   - In Databricks: Workspace > Create > Git Folder > Enter repo URL > Create

3. **Create the Instacart Catalog**
   - Open Databricks Catalog
   - Click Create > Create a catalog
   - Name the catalog, instacart

4. **Execute SQL files in order:**
   - src/sql/00_setup/00_setup.sql 
      - automatically sets up the schemas
   - src/sql/01_raw/*.sql
      - ingests source files into Bronze tables 
   - src/sql/02_clean/*.sql
      - applies cleaning, type casting, deduplication, and validation rules
   - src/sql/03_mart/*.sql
      - builds dimensional tables (dim_*) and the fact table (fact_order_products)
   - src/sql/04_visualization/*.sql
      - creates tables for visualization
   - src/sql/05_validation/*.sql
      - conducts validation checks for each layer

## Validation
To ensure data integrity across all pipeline layers, the project executes data quality checks covering row-level deduplication, structural integrity, and business logic. \
For full query logic, refer to [docs/validation.md](docs/validation.md).

### 1. Data Hygiene (Silver Layer)
* **Primary & Foreign Key Non-Null:** Strictly enforces non-null checks on essential join keys (`product_id`, `order_id`).
* **Domain & Type Enforcement:** Casts physical data types (e.g., numeric strings to `Integer`), normalizes text (`INITCAP`, whitespace removal), and filters out non-positive quantities.

### 2. Business Rule Checks (Gold Layer)
* **Dimension Uniqueness:** Ensures primary keys in dimension tables maintain 100% uniqueness (`COUNT(DISTINCT) == COUNT(*)`).
* **Referential Integrity:** Runs `LEFT JOIN` checks between `fact_table` and dimensions (`dim_order`, `dim_product`, `dim_aisle`) to flag unmapped foreign keys.
* **Cross-Layer Metric Reconciliation:** Compares row counts and total product volume between `instacart_clean` (Silver) and `instacart_mart` (Gold) to guarantee zero data loss during dimensional modeling.


## Decisions
To ensure data integrity throughout the Bronze → Silver → Gold pipeline, clear transformations were applied during the cleaning phase. A full breakdown of the decisions can be found in [`docs/decisions.md`](docs/decisions.md). \
For full implementation details, refer to [docs/decision.md](docs/decisions.md).

### Decisions Summary 

### 1. Silver Layer (Field-Level Data Cleaning)
* **Text & Schema Normalization:** Standardized casing (e.g., `INITCAP` on `eval_set`), trimmed trailing spaces, cleaned non-standard symbols in `product_name`, and rounded `days_since_prior_order` to whole numbers.
* **Integrity & Domain Enforcement:** Filtered out non-positive `add_to_cart_order` values and dropped rows missing critical primary keys (`product_id`). Domain flags like `reordered` were strictly constrained to binary flags (`0`/`1`).
* **Preserving NULL:** Kept `NULL`s in `days_since_prior_order` as valid indicators of a user's first-ever order. 

### 2. Gold Layer (Dimensional Modeling)
* **Unified Fact Model:** Combined `order_products_prior` and `order_products_train` using `UNION ALL` to build a single composite grain table without row truncation.
* **Non-Loss Joins:** Applied `LEFT JOIN`s against dimension tables (`products`) to preserve full order activity counts.

### 3. Visualization & Analytics Layer
* **Temporal Grouping (`order_dow`):** Segmented day-of-week identifiers into *Weekend* (0, 6) and *Weekday* (1–5) cohorts to analyze shopping behavior trends.




