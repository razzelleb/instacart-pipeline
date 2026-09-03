CREATE OR REPLACE TABLE instacart.instacart_visualization.top_ordered_products AS 
SELECT
    p.product_name AS product,
    p.department AS department,
    COUNT(f.order_id) AS total_purchase
FROM instacart.instacart_mart.fact_order_products AS f
LEFT JOIN instacart.instacart_mart.dim_product AS p
    ON f.product_id = p.product_id
GROUP BY product, department
ORDER BY total_purchase DESC;