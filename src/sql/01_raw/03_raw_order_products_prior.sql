-- Raw Order Products Prior Table
-- Ingest order products prior CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.order_products_prior AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/order_products__prior.csv',
    format => 'csv',
    header => true,
    schema => 'order_id INT, product_id INT, add_to_cart_order INT, reordered INT'
)