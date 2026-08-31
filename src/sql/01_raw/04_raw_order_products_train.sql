-- Raw Order Products Train Table
-- Ingest order products train CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.order_products_train AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/order_products__train.csv',
    format => 'csv',
    header => true,
    schema => 'order_ID INT, product_ID INT, add_to_cart_order INT, reordered INT'
)