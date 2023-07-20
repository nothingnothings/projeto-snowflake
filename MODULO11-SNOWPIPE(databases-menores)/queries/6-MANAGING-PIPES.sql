
-- FAREMOS 2 COISAS, NESSA LICAO:



-- 1a COISA --> TER 1 OVERVIEW 

-- DE NOSSAS EXISTING PIPES....




-- 2a COISA --> VER COMO PODEMOS 

-- ""ALTER"" PIPES QUE JÁ EXISTEM...



-- Manage pipes --



--- Describe a sSINGLE pipe (copy definition, notification_channel, etc)
DESC PIPE MANAGE_DB.pipes.employee_pipe;




-- Show list of all pipes
SHOW PIPES;


-- Show all pipes that have 'employee' in their names. -- CASE __INSENSITIVE
SHOW PIPES LIKE '%employee%';


-- Show pipes of only one database
SHOW PIPES IN DATABASE MANAGE_DB;


-- Show pipes of only one SCHEMA
SHOW PIPES IN SCHEMA MANAGE_DB.pipes;

-- Combining expressions
SHOW PIPES LIKE '%employee%' IN DATABASE MANAGE_DB;







-- OK... ISSO SAO COISAS QUE PODEMOS FAZER SE QUISERMOS 



-- DAR 1 OLHADA NAS NOSSAS EXISTING PIPES....


-- AGORA VEREMOS COMO PODEMOS _ ALTERAR 1 EXISTING PIPE...









-- ALTERING EXISTING PIPES (alter stage or file format) -- 




-- PREPARATION TABLE FIRST 
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.employees2 (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    LOCATION STRING,
    DEPARTMENT STRING
);













-- AGORA, QUEREMOS QUE NOSSA 

-- PIPE 


-- FACA COPY 

-- __ PARA __ DENTRO DESSA 

-- TABLE (

--     ou seja,
--     QUEREMOS TROCAR 


--     A COPY DEFINITION DE NOSSO SNOWPIPE,

--     DE "employees" table para 
--     "employees2" table...
-- )


-- DEVEMOS 
-- VER

-- QUE 




-- STEPS DEVEMOS SEGUIR,
 

--  PARA SUBSTITUIR 



-- A CONFIG DA PIPE...



-- A PRIMEIRA COISA QUE DEVEMOS FAZER É 

-- ___PAUSAR __ A EXECUCAO DA PIPE,

-- COM ESTE COMANDO:





-- PAUSE PIPE 
ALTER PIPE MANAGE_DB.pipes.employee_pipe
    SET PIPE_EXECUTION_PAUSED = TRUE;






-- VERIFY THAT PIPE IS REALLY PAUSED:
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe');


-- OK... COM ISSO, CONSTATAMOS QUE 


-- NOSSA PIPE ESTÁ PAUSED:






-- {"executionState":"PAUSED","pendingFileCount":0,"lastIngestedTimestamp":"2023-07-20T15:47:23.923Z","lastIngestedFilePath":"/employee_data_4.csv","notificationChannelName":"arn:aws:sqs:us-east-1:475055360349:sf-snowpipe-AIDAW5G4BRFO5Q3ZE3DWI-0N6R2utYyOFCy5TOernvnw","numOutstandingMessagesOnChannel":1,"lastReceivedMessageTimestamp":"2023-07-20T15:47:23.738Z","lastForwardedMessageTimestamp":"2023-07-20T15:47:24.201Z","lastPulledFromChannelTimestamp":"2023-07-20T16:08:28.729Z","lastForwardedFilePath":"snowflake-test-masterclass-bucket/CSV/snowpipe/employee_data_4.csv"}





--> NA VERDADE,




-- é IMPOSSÍVEL __ ALTERARMOS APENAS O COPY COMMAND 

-- DE NOSSA PIPE...







-- -> É BEM MELHOR SÓ FAZER O RECREATE DESSA 
-- PIPE,


-- COM 

-- CREATE OR REPLACE,
-- TIPO ASSIM:






-- Recreate the pipe, to change the copy statement in its definition (used by the pipe)
CREATE OR REPLACE PIPE MANAGE_DB.pipes.employee_pipe
    AUTO_INGEST=TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.stages.csv_folder;





--> isso feito,




-- DEVEMOS __ DAR REFRESH NA NOSSA PIPE...




--> RODAMOS 

-- REFRESH PIPE
ALTER PIPE MANAGE_DB.pipes.employee_pipe REFRESH;





--> PERCEBEMOS QUE, MESMO COM ESSA PIPE RESETTADA,


-- A METADATA DA PIPE ""ANTIGA"" AINDA FICA DISPONÍVEL
-- NELA... (podemos ver a list de todas received files)







-- MAS AINDA TEMOS 1 PROBLEMA...


-- ESTAMOS COM 1 NEW TABLE,

-- E AINDA QUEREMOS

-- TER 


-- TODA AS FILES DE NOSSO STAGE (s3 bucket)


-- COPIADAS PARA DENTRO 

-- DESSA TABLE 

-- RECÉM CRIADA....





--RELOAD FILES MANUALLY, THAT WERE ALREADY IN THE BUCKET...
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.stages.csv_folder;


--- verify that pipe is running.
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe');