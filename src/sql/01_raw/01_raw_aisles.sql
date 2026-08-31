-- Raw Aisles Table
-- Ingest aisles CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.aisles AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/aisles.csv',
    format => 'csv',
    header => true,
    schema => 'aisle_id INT, aisle STRING'
)