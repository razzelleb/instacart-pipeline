-- Raw Orders Table
-- Ingest orders CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.orders AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/orders.csv',
    format => 'csv',
    header => true,
    schema => 'order_id INT, user_id INT, eval_set STRING, order_number INT, order_dow INT, order_hour_of_day INT, days_since_prior_order FLOAT'
)