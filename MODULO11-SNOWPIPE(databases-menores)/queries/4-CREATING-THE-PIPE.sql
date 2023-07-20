-- CREATE TABLE FIRST 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
        ID INT,
        first_name STRING,
        last_name STRING,
        email STRING,
        location STRING,
        department STRING
    );
-- Create File format Object 
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file_format_new TYPE = CSV field_delimiter = ',',
    skip_header = 1 null_if =('NULL', 'null') empty_field_as_null = TRUE;




-- CREATE STAGE
CREATE OR REPLACE STAGE MANAGE_DB.stages.csv_folder
    URL = 's3://snowflake-test-masterclass-bucket/CSV/snowpipe'
    STORAGE_INTEGRATION= S3_EXAMPLE_INTEGRATION
    FILE_FORMAT=(
        FORMAT_NAME=MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
    );



-- LIST FILES IN BUCKET FOLDER/stage 

LIST @MANAGE_DB.stages.csv_folder;



-- CREATE SCHEMA TO STORE SNOWPIPE PIPES 

CREATE OR REPLACE SCHEMA MANAGE_DB.pipes;




-- Create ACTUAL PIPE OBJECT 

CREATE OR REPLACE PIPE MANAGE_DB.pipes.employee_pipe
    AUTO_INGEST = TRUE -- sempre deve ser definido como TRUE
   -- podemos executar apenas esta parte, do copy into, para verificar se coisas estao funcionando (para que o pipe nao execute 1 copy que nao funciona)
    AS 
    COPY INTO OUR_FIRST_DB.PUBLIC.employees
    FROM @MANAGE_DB.stages.csv_folder;





-- VC SEMPRE DEVE TESTAR O COMANDO DE COPY,

-- ANTES DE EMBUTI-LO NO PIPE.





-- --> COM ISSO, A PIPE ESTARÁ SETTADA...
-- ENTRETANTO, ELA AINDA __ NAO FUNCIONARÁ.
-- PARA QUE FUNCIONE, PRECISAMOS SETTAR 
-- S3 NOTIFICATIONS... TAMBÉM PRECISAMOS 
-- SETTAR PERMISSIONS PARA QUE O SNOWFLAKE 
-- CONSIGA __RECEBER ESSAS NOTIFICATIONS...

-- SÓ ENTAO ELE CONSEGUIRÁ COMECAR O COPYING,
-- A PARTIR DO INSERT DE ARQUIVOS NO BUCKET.






-- CHECKS FOR EXISTENCE OF PIPE.
DESC PIPE MANAGE_DB.pipes.employee_pipe;





-- PARA COMECARMOS ESSE SETUP,


-- RODAMOS 


-- DESCRIBE,

-- PARA TER INFORMATION 

-- SOBRE O PIPE...





-- OS FIELDS SAO:



-- NAME -> NOME DO PIPE 

-- DATABASE_NAME -> NOME DA DATABASE 

-- SCHEMA_NAME - NOME DO SCHEMA 


-- OWNER -> ACCOUNTADMIN, ETC 


-- NOTIFICATION_CHANNEL -->  ESSE É O __ VALUE _ _MAIS IMPORTANTE.








-- COPIAMOS O VALUE DE NOTIFICATION_CHANNEL,


-- PQ É ISSO QUE USAREMOS NO NOSSO "EVENT",

-- PARA QUE O EVENT __ CONSIGA _ 

-- ENVIAR ESSA NOTIFICATION 

-- A ESSE CANAL (é o target)...




-- VEREMOS COMO SETTAR ISSO, o send de notifications,
--  LÁ NO S3 DA AWS,

-- NA PRÓXIMA AULA.
