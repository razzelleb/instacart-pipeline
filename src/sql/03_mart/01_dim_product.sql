-- Dim Product Table
-- Join clean products and departments into the mart dimension table

CREATE OR REPLACE TABLE instacart.instacart_mart.dim_product AS
SELECT 
    p.product_id,
    p.product_name,
    p.department_id,
    d.department
FROM instacart.instacart_clean.products p
LEFT JOIN instacart.instacart_clean.departments d
    ON p.department_id = d.department_id;

-- Add fallback placeholder row for unknown products
INSERT INTO instacart.instacart_mart.dim_product (product_id, product_name, department_id, department)
SELECT -1, 'Unassigned', -1, 'Unassigned'
WHERE NOT EXISTS (
    SELECT 1 FROM instacart.instacart_mart.dim_product WHERE product_id = -1
);

/*Merge Into Alternate Code - not yet checked
MERGE INTO instacart.instacart_mart.dim_product AS target
USING (
    SELECT 
        p.product_id,
        p.product_name,
        p.department_id,
        d.department
    FROM instacart.instacart_clean.products p
    LEFT JOIN instacart.instacart_clean.departments d
        ON p.department_id = d.department_id
) AS source
ON target.product_id = source.product_id
WHEN MATCHED THEN
    UPDATE SET 
        target.product_name = source.product_name,
        target.department_id = source.department_id,
        target.department = source.department
WHEN NOT MATCHED THEN
    INSERT (product_id, product_name, department_id, department)
    VALUES (source.product_id, source.product_name, source.department_id, source.department); */