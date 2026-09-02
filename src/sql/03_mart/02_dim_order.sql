CREATE OR REPLACE TABLE instacart.instacart_mart.dim_order AS
SELECT 
    order_id,
    user_id,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
FROM instacart.instacart_clean.orders
