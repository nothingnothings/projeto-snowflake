-- OK,
-- ATÉ AÍ TUDO BEM,
-- MAS ISSO ASSUME QUE TUDO DEU CERTO COM NOSSA PIPE...--> MAS E SE ACONTECER ALGO DE ERRADO 
-- COM O COMANDO DE COPY ? O QUE FAZEMOS,
-- ENTAO ?->VEREMOS COMO PODEMOS HANDLAR ERRORS,
-- E QUE COISAS PODEMOS FAZER...


--O PROFESSOR ESCREVE ESTE CÓDIGO,
-- PARA FORCAR 1 ERRO:


-- Handling Errors 


-- Create file format object (with wrong file format - field delimiter is wrong, in the file its ",", and not ';' )


CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.CSV_FILE_FORMAT
    type = csv
    field_delimiter=';',
    skip_header=1
    null_if=('NULL', 'null')
    empty_field_as_null = TRUE;





TRUNCATE TABLE OUR_FIRST_DB.public.employees;

-- testing error, with simple copy command -- error (number of columns doesnt match)
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.stages.csv_folder;






-- se tentamos uploadar employee_Data_3.csv, que tem "," COMO DELIMITADORES, RECEBEREMOS 1 ERRO DE SEPARACAO DE COLUNAS
-- PARA CHECARMOS O STATUS DE SEND, NO CONTEXTO DE NOSSOS SNOWPIES, RODAMOS ISTO:
-- TEMOS 1 COMANDO ESPECIAL,
-- QUE É 
ALTER PIPE MANAGE_DB.pipes.employee_pipe REFRESH;


-- -> MAS ISSO MOSTRA QUE NOSSA FILE FOI 

-- ""SENT"" --> quer dizer que 

-- o snowflake/snowpipe 

-- JÁ FOI NOTIFICADO, a esse momento.









--> mas a primeira coisa que 
-- DEVEMOS FAZER,
-- SE ALGUMAS ROWS 
-- NAO APARECEREM 
-- NA NOSSA TABLE,
-- MESMO 
-- COM NOSSO
-- PIPE ESTANDO SETTADO,
-- É 
-- RODAR
-- ESTE COMANDO:


-- Validate pipe - checks if pipe is actually working 
SELECT SYSTEM$PIPE_STATUS('employee_pipe');



-- RESULT OF THAT:


-- {
--     "executionState":"RUNNING",
-- "pendingFileCount":0,
-- "lastIngestedTimestamp":"2023-07-20T15:00:11.051Z",
-- "lastIngestedFilePath":"/employee_data_2.csv",
-- "notificationChannelName":"arn:aws:sqs:us-east-1:475055360349:sf-snowpipe-AIDAW5G4BRFO5Q3ZE3DWI-0N6R2utYyOFCy5TOernvnw",
-- "numOutstandingMessagesOnChannel":1,
-- "lastReceivedMessageTimestamp":"2023-07-20T14:57:58.74Z",
-- "lastForwardedMessageTimestamp":"2023-07-20T14:57:59.171Z",
-- "lastPulledFromChannelTimestamp":"2023-07-20T15:04:38.728Z",
-- "lastForwardedFilePath":"snowflake-test-masterclass-bucket/CSV/snowpipe/employee_data_3.csv"}




-- COMO TEMOS "RUNNING",

-- SIGNIFICA QUE ESSE PIPE AINDA ESTÁ RODANDO...


-- pendingFileCount 0 SIGNIFCA QUE TODAS 

-- AS FILES JA FORAM PROCESSADAS...

-- INFELIZMENTE, AQUI NAO CONSEGUIMOS LER NENHUM ERRO,
-- MAS ESSAS INFOS JÁ SAO BOAS (dizem que o actual pipe em si está funcionando)






-- -> SE QUISERMOS RECEBER 1 ERROR 
-- MESSAGE DESSA PIPE,

-- PRECISAMOS USAR 1 SELECT COMMAND 

-- TOTALMENTE DIFERENTE....



-- Snowpipe error message 
 SELECT * fROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'MANAGE_DB.pipes.employee_pipe',
    START_TIME => DATEADD(HOUR, -2, CURRENT_TIMESTAMP())
 ));




--  EM UMA DAS COLUMNS,
--  TEMOS:







--  Remote file 'https://snowflake-test-
--  masterclass-bucket.s3.us-east-1.amazonaws.
--  com/CSV/snowpipe//employee_data_3.csv' 
--  was not found. There are several 
--  potential causes. The file might not exist.
--   The required credentials may be
--    missing or invalid. If you are
--     running a copy command, please make 
--     sure files are not deleted when they
--      are being loaded or files are not being
--       loaded into two different tables
--        concurrently with auto purge option.




-- FALA DE REMOTE FILE.... REMOTE FILE NAO FOI ENCONTRADA...






-- VÁRIAS CAUSAS EM POTENCIAL, ETC...







-- --> É UMA STANDARD MESSAGE,


-- QUE É 

-- A MESSAGE MAIS COMUM QUE RECEBEMOS, SE ALGO 


-- DÁ ERRADO NO NOSSO SNOWPIPE...




--> NAO NOS AJUDA COM QUASE NADA...

SELECT * FROM OUR_FIRST_DB.PUBLIC.employees;










-- NA VERDADE, O COMANDO MAIS ÚTIL QUE PODEMOS 

-- UTILIZAR 

-- É 


-- O 

-- DE 


-- ""COPY HISTORY"",




-- COPIAR A HISTORY DA TABLE EM QUE QUERÍAMOS COPIAR 

-- A DATA DO S3 BUCKET...


-- TIPO ASSIM:


-- COPY history from table to see error message (better error messages):

SELECT * FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    table_name => 'OUR_FIRST_DB.PUBLIC.employees',
    START_TIME => DATEADD(HOUR, -2, CURRENT_TIMESTAMP())
));





-- E ISSO REALMENTE NOS DÁ INFORMACAO UTIL....





-- TEMOS 1 COLUMN DE 


-- ""first_error_message"",

-- que é realmente útil...



-- ganhamos este error:



-- Number of columns in file (1) 
-- does not match that of the corresponding table 
-- (6), use file format 
-- option error_on_column_count_mismatch=false
--  to ignore this error