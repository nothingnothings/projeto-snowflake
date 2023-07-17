-- If you have not created the database EXERCISE_DB then
--  you can do so - otherwise use this database for this exercise.



DROP DATABASE EXERCISE_DB;
CREATE DATABASE EXERCISE_DB;
CREATE OR REPLACE SCHEMA EXERCISE_DB.STAGES;
CREATE OR REPLACE SCHEMA EXERCISE_DB.FILE_FORMATS;



-- 1. Create a stage object that is pointing to 's3://snowflake-assignments-mc/unstructureddata/'


CREATE OR REPLACE STAGE EXERCISE_DB.STAGES.aws_stage_copy
    url='s3://snowflake-assignments-mc/unstructureddata/';



-- 2. Create a file format object that is using TYPE = JSON


CREATE OR REPLACE FILE FORMAT EXERCISE_DB.FILE_FORMATS.json_file_format
    TYPE=JSON;


-- 3. Create a table called JSON_RAW with one column

-- Column name: Raw

-- Column type: Variant


CREATE OR REPLACE TABLE EXERCISE_DB.PUBLIC.JSON_RAW (
    raw VARIANT
);



-- 4. Copy the raw data in the JSON_RAW 
-- table using the file format object and stage object


COPY INTO EXERCISE_DB.PUBLIC.JSON_RAW FROM
    @EXERCISE_DB.STAGES.aws_stage_copy
    FILE_FORMAT=(
        FORMAT_NAME=EXERCISE_DB.FILE_FORMATS.json_file_format
    );


-- Perguntas dessa tarefa
-- What is the last name of the person in the first row (id=1)?