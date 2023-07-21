
-- AGORA DEVEMOS ESTUDAR AS PERMANENT TABLES...






-- --> PERMANENT TABLE --> É O DEFAULT VALUE PARA QUALQUER TABLE QUE CRIARMOS,

-- SE NAO ESPECIFICARMOS MAIS NADA....





-- //permanent tables 

USE OUR_FIRST_DB;


CREATE OR REPLACE TABLE customers (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


CREATE OR REPLACE DATABASE PDB;


SHOW DATABASES;



SHOW TABLES;













-- ao rodar show databases,
-- ficamos com todas as databases...









-- há também uma column de 

-- ""is_current",


-- que varia entre N e Y (

--     como estamos com ""OUR_FIRST_DB"" usado,



--     isso ficou como Y....
-- )









-- MAIS IMPORTANTE, TEMOS A COLUMN DE ""options"",



-- QUE NOS DIZ _ SE 1 GIVEN DATABASE/SCHEMA/TABLE __ É TRANSIENT OU NAO..







--> NAO ENXERGAMOS NADA NESSA COLUMN,

-- PQ 

-- __TODAS ESSAS DATABASES SAO PERMANENT DATABASES...









-- --> ALÉM DISSO, É POSSÍVEL VER QUE O RETENTION_TIME 


-- ESTÁ SETTADO COMO 1,




-- QUE É REALMENTE O DEFAULT...








-----> SE QUISERMOS TER INFO MAIS DETALHADA __ SOBRE A STORAGE 

-- GASTA, 

-- PODEMOS USAR ESTA QUERY:







-- view table metrics (takes a bit to appear) - can check is_transient, failsafe_bytes (always 0 in temporary and transient tables) and time_travel_bytes 
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;







-- More details about DROPPED tables, better formatted.
SELECT ID,
       TABLE_NAME,
       TABLE_SCHEMA,
       TABLE_CATALOG,
       ACTIVE_BYTES / (1024 * 1024 * 1024) AS ACTIVE_STORAGE_USED_GB,
       TIME_TRAVEL_BYTES / (1024 * 1024 * 1024) AS TIME_TRAVEL_STORAGE_USED_GB,
       FAILSAFE_BYTES / (1024 * 1024 * 1024) AS FAILSAFE_STORAGE_USED_GB,
       IS_TRANSIENT,
       DELETED,
       TABLE_CREATED,
       TABLE_DROPPED,
       TABLE_ENTERED_FAILSAFE
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_DROPPED IS NOT NULL
ORDER BY FAILSAFE_BYTES DESC;







--> COM ESSA QUERY AÍ,



-- CONSEGUIMOS DATA SOBRE__ AS DROPPED TABLES...








-- todas as tables que SUPOSTAMENTE teriam deixado de existir...







-- NOS NOSSOS RESULTS, É POSSÍVEL VER QUE 




-- __ OS ACTIVE_bYTES DESSAS TABLES REALMENTE ESTAO COMO 0...




-- ENTRETANTO,

-- OS FAILSAFE_BYTES E TIME_TRAVEL_BYTES 




-- NAO __ eSTAO COMO 0,

-- ESTAO COMO ALGO BEM GRANDE...














-- ISSO ACONTECE/ACONTECEU JUSTAMENTE PQ TODAS ESSAS TABLES 


-- NAO SAO TRANSIENT/TEMPORARY....




-- SE VISUALIZARMOS ALGUMAS TABLES QUE SAO TEMPORARY/TRANSIENT,


-- VEREMOS QUE 





-- A QUANTIDADE DE FAILSAFE_BYTES SERÁ SEMPRE 0 (

--     pq isso de failsafe, esse recurso,

--     existe só para AS PERMANENT TABLES...
-- )