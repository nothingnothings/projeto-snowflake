
-- CLONING 


--check initial data/table
SELECT * FROM OUR_FIRST_DB.PUBLIC.customers;



-- create clone from table (With all its metadata and data)
CREATE TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
CLONE OUR_FIRST_DB.PUBLIC.CUSTOMERS;





-- VALIDATE/check THE DATA - same data as copied/cloned table.
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE;



--update CLONED TABLE (to show how cloned table is completely independent from original table )
UPDATE OUR_FIRST_DB.public.CUSTOMERS_CLONE
SET LAST_NAME = NULL;



SELECT * FROM OUR_FIRST_DB.public.customers_clone;
SELECT * FROM OUR_FIRST_DB.public.customers;









-- OK.. MAS SE TENTARMOS CLONAR 1 

-- TEMPORARY TABLE, 

-- FALHAREMOS...



--> PQ ISSO NAO É possível




-- Create temporary table 
CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE (
    ID INT
);


CREATE TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE_COPY
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE;


-- ERROR:
-- 002119 (0A000):
--  SQL compilation error: 
--  Temp table cannot be cloned 
--  to a permanent table; clone to 
--  a transient table instead.












--> VOCE PODE CLONAR TRANSIENT 

-- TABLES PARA PERMANENT TABLES,


-- MAS NAO 

-- PODE 

-- CLONAR 


-- TEMPORARY TABLES PARA PERMANENT TABLES...


