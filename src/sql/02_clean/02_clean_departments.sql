CREATE OR REPLACE TABLE instacart.instacart_clean.departments AS
SELECT
    CAST(department_id AS INT) AS department_id,
    CASE
        WHEN LOWER(TRIM(department)) = 'missing' THEN 'Unknown'
        ELSE INITCAP(TRIM(department))
    END AS department
FROM instacart.instacart_raw.departments
WHERE department_id IS NOT NULL
  AND department IS NOT NULL
  AND TRIM(department) <> '';