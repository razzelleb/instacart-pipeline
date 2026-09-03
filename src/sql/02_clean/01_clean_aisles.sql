CREATE OR REPLACE TABLE instacart.instacart_clean.aisles AS
SELECT
    CAST(aisle_id AS INT) AS aisle_id,
    INITCAP(TRIM(aisle)) AS aisle
FROM instacart.instacart_raw.aisles
WHERE aisle_id IS NOT NULL
  AND aisle IS NOT NULL
  AND TRIM(aisle) <> '';