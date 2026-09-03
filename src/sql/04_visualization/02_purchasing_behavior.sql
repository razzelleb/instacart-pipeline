CREATE OR REPLACE TABLE instacart.instacart_visualization.purchasing_behavior AS
SELECT 
    order_dow,
    order_hour_of_day,
    CASE 
        WHEN order_hour_of_day = 0 THEN '12 AM'
        WHEN order_hour_of_day < 12 THEN CONCAT(order_hour_of_day, ' AM')
        WHEN order_hour_of_day = 12 THEN '12 PM'
        ELSE CONCAT(order_hour_of_day - 12, ' PM')
    END AS hour_label,
    COUNT(*) AS order_count
FROM instacart.instacart_mart.dim_order
GROUP BY order_dow, order_hour_of_day
ORDER BY order_dow, order_hour_of_day;