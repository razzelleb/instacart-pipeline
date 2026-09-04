CREATE OR REPLACE TABLE instacart.instacart_mart.dim_aisle AS
SELECT 
    aisle_id,
    aisle
FROM instacart.instacart_clean.aisles;

-- Add fallback placeholder row for unknown aisles
INSERT INTO instacart.instacart_mart.dim_aisle (aisle_id, aisle)
SELECT -1, 'Unassigned'
WHERE NOT EXISTS (
    SELECT 1 FROM instacart.instacart_mart.dim_aisle WHERE aisle_id = -1
);