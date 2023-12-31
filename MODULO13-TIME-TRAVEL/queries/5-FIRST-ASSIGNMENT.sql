-- 1. Create a database & Schema


CREATE DATABASE TIMETRAVEL_EXERCISE;


CREATE SCHEMA TIMETRAVEL_EXERCISE.COMPANY_X;





-- 2. Create a customers table


CREATE TABLE CUSTOMERS AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER      
LIMIT 500; 




-- 3. Drop the schema (assuming it happened by accident)


DROP SCHEMA TIMETRAVEL_EXERCISE.COMPANY_X;



-- 4. Verify table doesn't exist anymore


SELECT * FROM TIMETRAVEL_EXERCISE.COMPANY_X.CUSTOMERS; ///does not exist (is missing)



-- 5. Undrop Schema


UNDROP SCHEMA TIMETRAVEL_EXERCISE.COMPANY_X;



SELECT * FROM TIMETRAVEL_EXERCISE.COMPANY_X.customers;