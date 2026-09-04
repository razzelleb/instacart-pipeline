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
WITH labeled AS (
    SELECT
        CASE 
            WHEN order_dow IN (0, 6) THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        CASE 
            WHEN order_dow IN (0, 6) THEN 2
            ELSE 5
        END AS days_in_group,
        order_hour_of_day,
        hour_label,
        order_count
    FROM instacart.instacart_visualization.purchasing_behavior
)
SELECT
    order_hour_of_day,
    ANY_VALUE(hour_label) AS hour_label,
    SUM(CASE WHEN day_type = 'Weekday' THEN order_count END) / MAX(CASE WHEN day_type = 'Weekday' THEN days_in_group END) AS weekday_avg,
    SUM(CASE WHEN day_type = 'Weekend' THEN order_count END) / MAX(CASE WHEN day_type = 'Weekend' THEN days_in_group END) AS weekend_avg
FROM labeled
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;