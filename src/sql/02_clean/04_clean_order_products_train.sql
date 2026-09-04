CREATE OR REPLACE TABLE instacart.instacart_clean.order_products_train AS
SELECT
    CAST(order_id AS INT) AS order_id,
    CAST(product_id AS INT) AS product_id,
    CAST(add_to_cart_order AS INT) AS add_to_cart_order,
    CAST(reordered AS INT) AS reordered
FROM instacart.instacart_raw.order_products_train
WHERE order_id IS NOT NULL
    AND product_id IS NOT NULL
    AND add_to_cart_order > 0
    AND reordered IN (0, 1);