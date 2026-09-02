CREATE OR REPLACE TABLE instacart.instacart_clean.products AS
SELECT DISTINCT
    CAST(product_id AS INT) AS product_id,
    TRIM(INITCAP(REGEXP_REPLACE(REGEXP_REPLACE(CAST(product_name AS STRING), r'[®™>"\\]', ''), '\\s+', ' '))) AS product_name,
    CAST(aisle_id AS INT) AS aisle_id,
    CAST(department_id AS INT) AS department_id
FROM instacart.instacart_raw.products
WHERE product_id IS NOT NULL;