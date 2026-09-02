SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(reordered) * 100.0 / COUNT(*),
        2
    ) AS reorder_rate,
    COUNT(*) AS total_products_purchased
FROM (
    SELECT
        order_id,
        product_id,
        reordered
    FROM instacart.instacart_clean.order_products_prior
    UNION ALL
    SELECT
        order_id,
        product_id,
        reordered
    FROM instacart.instacart_clean.order_products_train
) AS all_orders;