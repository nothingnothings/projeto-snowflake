
-- CREATE TABLE EXERCISE_DB.PUBLIC.CUSTOMERS (
-- ID INT,

-- first_name VARCHAR,

-- last_name VARCHAR,

-- email VARCHAR,

-- age int,

-- city VARCHAR
-- );


CREATE OR REPLACE STAGE EXERCISE_DB.PUBLIC.aws_stage_2
        url='s3://snowflake-assignments-mc/loadingdata/';



LIST @EXERCISE_DB.PUBLIC.aws_stage_2;




COPY INTO EXERCISE_DB.PUBLIC.CUSTOMERS
    FROM @EXERCISE_DB.PUBLIC.aws_stage_2
        file_format=(
        type=csv,
        field_delimiter=';',
        skip_header=1
        );



SELECT * FROM EXERCISE_DB.PUBLIC.CUSTOMERS;