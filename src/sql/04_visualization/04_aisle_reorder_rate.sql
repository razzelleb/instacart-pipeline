CREATE OR REPLACE TABLE instacart.instacart_visualization.aisle_reorder_rate AS
SELECT 
    a.aisle_id,
    a.aisle AS aisle_name,
    COUNT(*) AS total_aisle_orders,
    SUM(f.reordered) AS total_aisle_reordered,
    ROUND(100.0 * SUM(f.reordered) / COUNT(*), 2) AS aisle_reorder_rate
FROM instacart.instacart_mart.fact_order_products AS f
INNER JOIN instacart.instacart_mart.dim_aisle AS a
    ON f.aisle_id = a.aisle_id
GROUP BY a.aisle_id, a.aisle
ORDER BY aisle_reorder_rate DESC
LIMIT 5;