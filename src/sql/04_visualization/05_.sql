CREATE OR REPLACE TABLE instacart.instacart_mart.kpi_summary AS
WITH all_purchases AS (
    SELECT
        o.user_id,
        o.order_id,
        o.order_number,
        op.product_id
    FROM instacart.instacart_clean.orders o
    JOIN instacart.instacart_clean.order_products_prior op
        ON o.order_id = op.order_id
    UNION ALL
    SELECT
        o.user_id,
        o.order_id,
        o.order_number,
        op.product_id
    FROM instacart.instacart_clean.orders o
    JOIN instacart.instacart_clean.order_products_train op
        ON o.order_id = op.order_id
),
purchases_with_reorder AS (
    SELECT
        user_id,
        order_id,
        product_id,
        CASE
            WHEN order_number = 1 THEN 0
            WHEN COUNT(*) OVER (
                PARTITION BY user_id, product_id
                ORDER BY order_number
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ) > 0 THEN 1
            ELSE 0
        END AS reordered
    FROM all_purchases
)
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(reordered) * 100.0 / COUNT(*),
        2
    ) AS reorder_rate,
    COUNT(*) AS total_products_purchased
FROM purchases_with_reorder;