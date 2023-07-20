-- CREATE TABLE FIRST 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
        ID INT,
        first_name STRING,
        last_name STRING,
        email STRING,
        location STRING,
        department STRING
    );
-- Create File format Object 
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file_format_new TYPE = CSV field_delimiter = ',',
    skip_header = 1 null_if =('NULL', 'null') empty_field_as_null = TRUE;




-- CREATE STAGE
CREATE OR REPLACE STAGE MANAGE_DB.stages.csv_folder
    URL = 's3://snowflakes3bucket123/csv/snowpipe'
    STORAGE_INTEGRATION= S3_EXAMPLE_INTEGRATION
    FILE_FORMAT=(
        FORMAT_NAME=MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
    );