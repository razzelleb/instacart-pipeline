CREATE OR REPLACE TABLE instacart.instacart_visualization.product_reorder_behavior AS
SELECT
    f.product_id AS product_id,
    p.product_name AS product_name,
    COUNT(*) AS total_orders,
    SUM(f.reordered) AS total_reordered,
    CAST(SUM(f.reordered) AS DOUBLE) / COUNT(*) AS reorder_rate
FROM instacart.instacart_mart.fact_order_products AS f
INNER JOIN instacart.instacart_mart.dim_product AS p
ON f.product_id = p.product_id
GROUP BY f.product_id, p.product_name
HAVING COUNT(*) >= 100 
ORDER BY reorder_rate DESC
LIMIT 10;
