CREATE OR REPLACE TABLE instacart.instacart_clean.orders AS
SELECT order_id::int AS order_id,
    user_id::int AS user_id,
    INITCAP(TRIM(eval_set)) AS eval_set,
    order_number,
    order_dow::int AS order_dow,
    order_hour_of_day::int AS order_hour_of_day,
    days_since_prior_order
FROM instacart.instacart_raw.orders
WHERE 
    order_id IS NOT NULL;