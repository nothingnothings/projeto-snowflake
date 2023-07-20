-- 1. Create exercise table


USE ROLE ACCOUNTADMIN;

CREATE DATABASE DEMO_DB;
USE DATABASE DEMO_DB;



CREATE OR REPLACE TABLE DEMO_DB.public.PART
AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART;


SELECT * FROM PART
ORDER BY P_MFGR DESC;


-- UPDATE THE TABLE 

UPDATE DEMO_DB.PUBLIC.PART
SET P_MFGR='Manufacturer#CompanyX'
WHERE P_MFGR = 'Manufacturer#5';

-- anote o query id da query aqui: 01adc200-0604-ad1c-0077-a687000380b2


SELECT * FROM PART
ORDER BY P_MFGR DESC;


-- 3.1: Travel back using the offset until you get the result of before the update

SELECT * FROM PART AT (offset => -60*1.5)
ORDER BY P_MFGR DESC;



-- 3.2: Travel back using the query id to get the result before the update

SELECT * FROM PART BEFORE (statement => '01adc200-0604-ad1c-0077-a687000380b2')
ORDER BY P_MFGR DESC;


