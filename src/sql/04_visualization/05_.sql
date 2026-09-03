CREATE OR REPLACE TABLE instacart.instacart_visualization.kpi_summary AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(reordered) * 100.0 / COUNT(*),
        2
    ) AS reorder_rate,
    COUNT(*) AS total_products_purchased
FROM instacart.instacart_clean.mart_order_products;
