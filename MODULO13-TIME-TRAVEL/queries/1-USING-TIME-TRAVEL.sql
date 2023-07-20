-- Setting up example table 

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


--create file format
CREATE OR REPLACE FILE FORMAT OUR_FIRST_DB.file_formats.time_travel_format
    TYPE=CSV
    FIELD_DELIMITER=","
    SKIP_HEADER=1;


-- create stage
CREATE OR REPLACE STAGE OUR_FIRST_DB.stages.time_travel_stage
    url='s3://data-snowflake-fundamentals/time-travel',
    file_format=(
    FORMAT_NAME=OUR_FIRST_DB.file_formats.time_travel_format
    );

-- List files in stage 
LIST @OUR_FIRST_DB.stages.time_travel_stage;



-- copy data from stage into table 
COPY INTO OUR_FIRST_DB.public.test
FROM @OUR_FIRST_DB.stages.time_travel_stage;


SELECT * FROM OUR_FIRST_DB.PUBLIC.TEST;




-- accidental update (classic fuck-up) -- forgot WHERE CLAUSE (to update only a certain data point)
UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'Joyen';



-- NOW, WE NEED TIME TRAVEL.










-- PARA USAR TIME-TRAVEL,




-- PODEMOS _ TRAVEL 

-- BACK 



-- A CERTA QUANTIDADE DE 

-- MINUTOS OU SEGUNDOS...






-- PARA CONSEGUIRMOS 
-- "TRAVEL BACK",




-- PRECISAMOS DA 

-- KEYWORD DE 

-- """"AT"""" (denomina TEMPO)....







-- EXEMPLO:



-- Using time travel: First method - 2 minutes back. -- OFFSET pede o número de segundos
SELECT * FROM OUR_FIRST_DB.public.test AT (OFFSET => -60 * 0.5);





-- OK, MAS EU RECEBI 1 ERROR... --> faltou o "-" (para dizer que queremos voltar PARA TRÁS)






-- DEPENDENDO DA EDITION QUE ESTAMOS USANDO,

-- PODEMOS FAZER TRAVEL 
-- BACK 

-- DIFERENTES 
-- QUANTIAS DE TEMPO (O LIMITE É 90 DIAS)...






-- E ISSO REALMENTE FUNCIONA....



-- COLOQUEI 1 VALUE DE 


-- ""-2000*0.5""",

-- E ISSO ME MOSTROU A TABLE 

-- ANTES DE ELA SER ALTERADA 


-- POR CONTA DAQUELE UPDATE....
















-- --> PODEMOS RECRIAR A TABLE, COM A DATA/RESULT 

-- SET QUE EXISTIA ANTES,



-- PARA 

-- CONSERTARMOS NOSSO ERRO.....


-- SIM, ISSO FUNCIONA...





-- Podemos rodar isto:



-- CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test 
-- AS
-- SELECT * FROM OUR_FIRST_DB.public.test AT (OFFSET => -120*0.5);


-- SELECT * FROM OUR_FIRST_DB.public.test;










-- OK... 






-- MAS EXISTEM DIFERENTES METHODS DE TIME-TRAVEL....







-- ESSE É O PRIMEIRO, COM USO DE ""AT"",

-- junto de ""OFFSET => <number_of_seconds_to_travel_back>""















-- SEGUNDO METHOD:




-- Using time travel: Second method - BEFORE (timestamp => <timestamp>)

SELECT * FROM OUR_FIRST_DB.public.test BEFORE (timestamp => '2023-07-20 22:05:20'::timestamp);

SELECT * FROM OUR_FIRST_DB.public.test BEFORE (timestamp => current_timestamp - INTERVAL '2 HOURS');

SELECT * FROM OUR_FIRST_DB.public.test BEFORE (timestamp => current_timestamp - INTERVAL '0.6 HOURS');







-- test do segundo method:


-- Setting up example table 

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


-- copy data from stage into table 
COPY INTO OUR_FIRST_DB.public.test
FROM @OUR_FIRST_DB.stages.time_travel_stage;


SELECT * FROM OUR_FIRST_DB.PUBLIC.TEST;


-- setting up UTC time for convenience 
ALTER SESSION SET TIMEZONE = 'UTC';
SELECT CURRENT_TIMESTAMP;


UPDATE OUR_FIRST_DB.PUBLIC.test 
SET Job = 'Data Scientist';



SELECT * FROM OUR_FIRST_DB.PUBLIC.TEST;


SELECT * FROM OUR_FIRST_DB.public.test BEFORE (timestamp => '2023-07-20 17:34:10.113 +0000'::timestamp);














-- FINALMENTE, TEMOS O TERCEIRO METHOD,

-- QUE O PROFESSOR CONSIDERA AINDA MAIS SIMPLES 


-- E MT MT MT ÚTIL..













--> O TERCEIRO METHOD USA O QUERY ID,

-- E É O MAIS SAFE/GARANTIDO DOS 3...












-- Using time travel - METHOD 3 -- BEFORE QUERY ID...





-- prepare table:
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);


-- copy data from stage into table 
COPY INTO OUR_FIRST_DB.public.test
FROM @OUR_FIRST_DB.stages.time_travel_stage;




SELECT * FROM OUR_FIRST_DB.PUBLIC.test;




-- ALTERING TABLE (BY MISTAKE)
UPDATE OUR_FIRST_DB.PUBLIC.TEST 
SET EMAIL = null;


SELECT * FROM OUR_FIRST_DB.PUBLIC.test;




-- TIME TRAVEL - METHOD 3 - BEFORE JUNTO DE "statement", e aí colamos a QUERY ID....
SELECT * FROM OUR_FIRST_DB.PUBLIC.test BEFORE (statement =>  '01adc1e8-0604-acac-0077-a6870002f2ca');






-- PODEMOS CHECAR O QUERY ID NA QUERY HISTORY...
