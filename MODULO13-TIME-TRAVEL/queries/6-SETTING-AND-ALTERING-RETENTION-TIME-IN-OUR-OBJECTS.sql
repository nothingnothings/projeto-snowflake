-- PARA VER O RETENTION TIME PERIOD (quanto tempo podemos VOLTAR NO TEMPO, em nossos objects) DE NOSSOS OBJECTS SNOWFLAKE, 
-- PODEMOS USAR O COMANDO "SHOW xxxx"....

-- exemplo --> show tables:




-- show properties like retention_time...
SHOW TABLES LIKE '%CUSTOMERS%';

USE DATABASE OUR_FIRST_DB;
SHOW TABLES; -- column - "retention_time"


ALTER TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS
SET DATA_RETENTION_TIME_IN_DAYS=1; -- 1 é o DEFAULT.






-- QUER DIZER QUE EM TODAS NOSSAS TABLES,

-- POR DEFAULT,
-- PODEMOS RETROCEDER 

-- ATÉ 1 DIA....

-- QUAISQUER CHANGES QUE ACONTECEREM NAS 


-- ÚLTIMAS 24 HORAS PODEM SER REVERTIDAS...


--> MAS COMO PODEMOS __ ALTERAR ESSE VALUE?







-- HÁ 2 MANEIRAS...




-- 1a MANEIRA) SE UMA TABLE JÁ EXISTE...




-- nesse caso, DEFINIMOS A PROPRIEDADE 
-- DATA_RETENTION_TIME_IN_DAYS como sendo 1 diferente value.....



ALTER TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS
SET DATA_RETENTION_TIME_IN_DAYS=2; -- 1 é o DEFAULT.




-- 2a MANEIRA) PODEMOS CRIAR 1 TABLE JÁ COM ESSA SETTING DEFINIDA:
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.retention_example (
ID INT,
FIRST_NAME STRING,
LAST_NAME STRING,
EMAIL STRING,
GENDER STRING, 
JOB STRING,
PHONE STRING)
DATA_RETENTION_TIME_IN_DAYS=3;



-- we see our retention time....
SHOW TABLES LIKE '%EX%';




-- OK.... 


-- MAS SE ALTERARMOS ESSA PROPRIEDADE 


-- A um 


-- VALUE DE 0,

-- ISSO 



-- VAI BASICAMENTE DESABILITAR 
-- ESSA FEATURE DE TIME TRAVEL,

-- NAO PODEREMOS USAR __ AT ALL_.....





-- EX:


ALTER TABLE OUR_FIRST_DB.PUBLIC.retention_example
SET DATA_RETENTION_TIME_IN_DAYS=0;







-- ALTER TABLE OUR_FIRST_DB.PUBLIC.retention_example
-- SET DATA_RETENTION_TIME_IN_DAYS=0; -- disabled time travel feature





-- DROP TABLE OUR_FIRST_DB.PUBLIC.retention_example;
-- UNDROP TABLE OUR_FIRST_DB.PUBLIC.RETENTION_EXAMPLE; -- this wont be possible (because we set data_retention_time_in-days to 0)









--> OK... PODEMOS ALTERAR ESSA PROPERTY, SIM...


-- MAS QUAL É A VANTAGEM DE DEIXÁ-LA COMO 1?







-- pq nao deixaríamos como 90?






-- A RAZAO PARA ISSO É QUE 

-- ___eXISTE 1 CUSTO __ INDIRETO ENVOLVIDO...