-- 1. Create a table called employees with the following columns and data types:
CREATE TABLE OUR_FIRST_DB.PUBLIC.EMPLOYEES (
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(50),
    AGE INT,
    DEPARTMENT VARCHAR(50)
);


CREATE OR REPLACE SCHEMA OUR_FIRST_DB.FILE_FORMATS;




-- 2. Create a stage object pointing to 's3://snowflake-assignments-mc/copyoptions/example1'

CREATE STAGE OUR_FIRST_DB.PUBLIC.another_s3_stage
    url='s3://snowflake-assignments-mc/copyoptions/example1';





-- 3. Create a file format object 
CREATE OR REPLACE FILE FORMAT OUR_FIRST_DB.FILE_FORMATS.another_file_format
    TYPE=CSV
    FIELD_DELIMITER=',',
    SKIP_HEADER=1;





-- 4 USE THE COPY OPTION TO ONLY VALIDATE IF THERE ARE ERRORS, AND, IF YES, WHAT ERRORS


COPY INTO OUR_FIRST_DB.PUBLIC.EMPLOYEES
    FROM @another_s3_stage
    FILE_FORMAT=(FORMAT_NAME=OUR_FIRST_DB.FILE_FORMATS.another_file_format)
    VALIDATION_MODE = RETURN_ERRORS;


-- 5. Load the data anyways regardless of the error using the ON_ERROR option. How many rows have been loaded?




COPY INTO OUR_FIRST_DB.PUBLIC.EMPLOYEES
    FROM @another_s3_stage
    FILE_FORMAT=(FORMAT_NAME=OUR_FIRST_DB.FILE_FORMATS.another_file_format)
    ON_ERROR=CONTINUE;
