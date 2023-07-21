USE DATABASE TDB;

-- Create example PERMANENT table 

CREATE OR REPLACE TABLE TDB.public.customers (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


-- create data and insert into table
INSERT INTO TDB.public.customers
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1
CROSS JOIN (SELECT * FROM OUR_FIRST_DB.public.customers) t2;



SELECT * FROM TDB.public.customers;


--> OK...  PERCEBEMOS QUE EXISTE 
-- DATA NESSA TABLE...






-- Create temporary table (with same name as main/permanent table --> will HIDE that permanent table, during current session)
CREATE OR REPLACE TEMPORARY TABLE TDB.public.customers (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);




-- PARA DEMONSTRAR ISSO,


-- SE RODARMOS 1 SELECT EM CIMA DESSA TABLE 

-- TEMPORÁRIA DE "CUSTOMERS",

-- FICAREMOS COM 0 CUSTOMERS....







-- EX: 




SELECT * FROM TDB.public.customers; -- 0 rows




-- INSERT SOME DATA INTO TEMPORARY TABLE.
INSERT INTO TDB.public.customers
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1;



SELECT * FROM TDB.public.customers; -- 86  rows



-- SE NÓS TROCARMOS DE SESSION/WORKSHEET,
-- VEREMOS QUE ESSA DATA NAO EXISTIRÁ 
-- NA TABLE (pq aí estaremos queriando 
-- a table original, e nao essa, 
-- temporária, que modificamos agora)







-- CERTO....


-- QUER DIZER QUE ESSE É UM BEHAVIOR IMPORTANTE (behavior de 
-- "HIDE"),

-- DESSA TEMPORARY TABLE....








AGORA TEREMOS OUTRO EXEMPLO....




CRIAMOS 1 NOVA TABLE....






COM ESTE COMANDO:




-- CREATE SECOND TEMPORARY TABLE (With a new name)


CREATE OR REPLACE TEMPORARY TABLE TDB.public.temp_table (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


-- insert DATA INTO THE NEW TABLE.

INSERT INTO TDB.public.temp_table
SELECT * FROM OUR_FIRST_DB.public.customers;



SELECT * FROM OUR_FIRST_DB.public.temp_table;





SHOW TABLES;



















--> ALÉM DESSA PROPRIEDADE 


DE "EXISTIR DURANTE A SESSION",




-- A TEMPORARY TABLE É BEM PARECIDA 



-- COM A TRANSIENT TABLE (



--     NENHUM FAILSAFE,

--     MAS TIME TRAVEL MÁXIMO DE 

--     1 DIA... OU 0 DIAS, SE VC QUISER...
-- )








