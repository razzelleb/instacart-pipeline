-- Initial setup
USE CATALOG instacart;

-- Create data layer schemas
-- Raw layer: preserves source data into taw tables
CREATE SCHEMA IF NOT EXISTS instacart_raw;

-- Clean layer: cleaned and standardized data
CREATE SCHEMA IF NOT EXISTS instacart_clean;

-- Mart layer: business-ready dimensional/fact models
CREATE SCHEMA IF NOT EXISTS instacart_mart;

-- Visualization layer: datasets prepared for reporting and analysis
CREATE SCHEMA IF NOT EXISTS instacart_visualization;

-- Verify schemas
SHOW SCHEMAS;