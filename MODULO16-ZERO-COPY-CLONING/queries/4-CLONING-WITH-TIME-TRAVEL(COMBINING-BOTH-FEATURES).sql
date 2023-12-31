
-- OK.... AGORA VEREMOS COMO PODEMOS COMBINAR


-- AS FEATURES 

-- DE TIME TRAVEL E CLONING,

-- O QUE PODE SER ESPECIALMENTE ÚTIL 


-- QUANDO QUEREMOS DESENVOLVER COISAS A MAIS...

-- (
--     PODEMOS CRIAR 1 CLONE EM 1 CERTO MOMENTO 

--     NO TEMPO, PARA 1 GIVEN TABLE/DATABASE...
-- )








-- CÓDIGO:



-- Cloning using time travel 





-- Setting up the table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.time_travel (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);



-- Setup file format 
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    TYPE = CSV
    FIELD_DELIMITER=',',
    SKIP_HEADER=1;




-- set up STAGE 
CREATE OR REPLACE STAGE MANAGE_DB.stages.time_travel_stage
    URL='s3://data-snowflake-fundamentals/time-travel/'
    FILE_FORMAT=(
        FORMAT_NAME=MANAGE_DB.FILE_FORMATS.csv_file
    );


 -- COPY FILES
COPY INTO OUR_FIRST_DB.public.time_travel
FROM @MANAGE_DB.stages.time_travel_stage
FILES=('customers.csv');






-- CERTO....





-- AÍ TEMOS NOSSA TABLE, COM TODA A CUSTOMER DATA...








--> AGORA ASSUMAMOS QUE QUEREMOS UPDATAR NOSSA DATA,


-- POR ISSO ESCREVEMOS ASSIM:








UPDATE OUR_FIRST_DB.public.time_travel
SET FIRST_NAME='Josh';








-- -> OK... AGORA QUEREMOS USAR 

-- A FEATURE DE TIME TRAVEL,



-- JUNTO COM O COMANDO DE "CLONE",


-- PARA _ CRIARMOS 

-- 1 CLONE/COPIA 
-- DA __ TABLE _ ANTES 

-- DE ELA TER SIDO AFETADA 


-- POR ESSE 

-- COMANDO DE UPDATE....




-- PARA ISSO, RODAMOS ASSIM:






-- Combining the CLONE FEATURE WITH THE TIME TRAVEL FEATURE.
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.TIME_TRAVEL_COPY
CLONE OUR_FIRST_DB.PUBLIC.TIME_TRAVEL BEFORE (statement => '01adc778-0604-ad1c-0077-a68700038b26');





SELECT * FROM OUR_FIRST_DB.PUBLIC.TIME_TRAVEL_COPY;
SELECT * FROM OUR_FIRST_DB.PUBLIC.TIME_TRAVEL;



--> COM ISSO, COM O PRIMEIRO COMANDO,

-- É POSSÍVEL CRIAR 1 

-- CÓPIA/CLONE DA TABLE 

-- ANTES DO UPDATE 

-- INDEVIDO...





-- other methods of time travel (not as useful):
SELECT * FROM OUR_FIRST_DB.public.time_travel AT (OFFSET => -60*1); -- goes BACK 1 MINUTE INTO THE PAST.



-- O MESMO COMANDO DE TIME TRAVEL, MAS AGORA USANDO A FEATURE DE CLONE:
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.TIME_TRAVEL_CLONE
CLONE OUR_FIRST_DB.PUBLIC.TIME_TRAVEL AT (OFFSET => 60*1);





UPDATE OUR_FIRST_DB.PUBLIC.TIME_TRAVEL_COPY
SET Job = 'Studying';





-- time travel method 2, using QUERY ID (como visto acima)...

SELECT * FROM OUR_FIRST_DB.public.time_travel_copy BEFORE (
    statement => '...'
);





-- to create a clone using time travel using query id, as shown above:
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_copy_of_copy
CLONE OUR_FIRST_DB.public.time_travel_copy BEFORE (statement => '...');