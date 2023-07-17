

-- 1. Create a table called employees with the
--  following columns and data types:

-- customer_id int,

-- first_name varchar(50),

-- last_name varchar(50),

-- email varchar(50),

-- age int,

-- department varchar(50)







CREATE OR REPLACE TABLE EXERCISE_DB.PUBLIC.EMPLOYEES(
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(50),
    AGE INT,
    DEPARTMENT VARCHAR(50)
);



-- 2. Create a stage object pointing to's3://snowflake-assignments-mc/copyoptions/example2'


CREATE OR REPLACE SCHEMA EXERCISE_DB.STAGES;
CREATE OR REPLACE SCHEMA EXERCISE_DB.FILE_FORMATS;

CREATE OR REPLACE STAGE EXERCISE_DB.STAGES.aws_generic_stage
    url='s3://snowflake-assignments-mc/copyoptions/example2';





-- 3. Create a file format object with the specification

-- TYPE = CSV

-- FIELD_DELIMITER=','

-- SKIP_HEADER=1;


CREATE OR REPLACE FILE FORMAT EXERCISE_DB.FILE_FORMATS.generic_file_format
    TYPE=CSV
    FIELD_DELIMITER=','
    SKIP_HEADER=1;




-- 4. Use the copy option to only validate if there are errors and if yes what errors.


    COPY INTO EXERCISE_DB.PUBLIC.EMPLOYEES FROM 
    @EXERCISE_DB.STAGES.aws_generic_stage
    FILE_FORMAT=(
        FORMAT_NAME=EXERCISE_DB.FILE_FORMATS.generic_file_format
    )
    VALIDATION_MODE=RETURN_ERRORS;





-- 5. One value in the first_name column has more than 50 characters. 
-- We assume the table column properties could not be changed.

-- What option could you use to load that record
--  anyways and just truncate the value after 50 characters?
-- Load the data in the table using that option.




    COPY INTO EXERCISE_DB.PUBLIC.EMPLOYEES FROM 
    @EXERCISE_DB.STAGES.aws_generic_stage
    FILE_FORMAT=(
        FORMAT_NAME=EXERCISE_DB.FILE_FORMATS.generic_file_format
    )
    TRUNCATECOLUMNS=TRUE;
