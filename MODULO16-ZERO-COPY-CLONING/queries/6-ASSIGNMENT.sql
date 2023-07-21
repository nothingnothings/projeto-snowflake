-- 1. Create exercise table




-- Switch to role of accountadmin --
USE ROLE ACCOUNTADMIN;
USE DATABASE DEMO_DB;
USE WAREHOUSE COMPUTE_WH;


-- create table
CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER
AS SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."SUPPLIER";




-- 2. Create a clone of that table called SUPPLIER_CLONE


CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER_CLONE
CLONE DEMO_DB.PUBLIC.SUPPLIER;






-- 3. Update the clone table and copy the query id



UPDATE SUPPLIER_CLONE
SET S_PHONE='###';




-- QUERY ID  === 01adc7db-0604-ad1c-0077-a68700038c66




-- 4. Create another clone
--  from the updated clone using the time travel feature
--   to clone before the update has been executed.




-- 4. Create another clone from the updated clone using the time travel feature to clone before the update has been executed.
CREATE OR REPLACE TABLE DEMO_DB.PUBLIC.SUPPLIER_SECOND_CLONE
CLONE DEMO_DB.PUBLIC.SUPPLIER_CLONE BEFORE (statement => '01adc7db-0604-ad1c-0077-a68700038c66');






SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_CLONE;
SELECT * FROM DEMO_DB.PUBLIC.SUPPLIER_SECOND_CLONE;
