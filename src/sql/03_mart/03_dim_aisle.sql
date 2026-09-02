CREATE OR REPLACE TABLE instacart.instacart_mart.dim_aisle AS
SELECT 
    aisle_id,
    aisle
FROM instacart.instacart_clean.aisles;