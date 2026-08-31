-- Raw Departments Table
-- Ingest departments CSV into its raw table

CREATE TABLE IF NOT EXISTS instacart.instacart_raw.departments AS

SELECT 
    * 
FROM read_files(
    '/Volumes/chinook/bronze/ftw-b12-de/shared/week06/instacart_csv/departments.csv',
    format => 'csv',
    header => true,
    schema => 'department_id INT, department STRING'
)