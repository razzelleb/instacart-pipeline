-- Raw Products Table
-- Ingest products CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.products AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/products.csv',
    format => 'csv',
    header => true,
    schema => 'product_id INT, product_name STRING, aisle_id INT, department_id INT'
)