CREATE OR REPLACE TABLE instacart.instacart_mart.fact_order_products AS
SELECT
    op.order_id,
    op.product_id,
    COALESCE(p.department_id, -1) AS department_id,
    COALESCE(p.aisle_id, -1) AS aisle_id,
    op.reordered
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
) op
LEFT JOIN instacart.instacart_clean.products p
    ON op.product_id = p.product_id;