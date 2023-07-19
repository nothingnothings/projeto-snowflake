

-- Create table first
    CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.movie_titles (

        show_id STRING,
        type STRING,
        title STRING,
        director STRING,
        cast STRING,
        country STRING,
        date_added STRING,
        release_year STRING,
        rating STRING,
        duration STRING,
        listed_in STRING,
        description STRING
    );


-- Create file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_fileformat
    type = CSV 
    field_delimiter=','
    skip_header=1
    null_if=('NULL', 'NULL')
    empty_field_as_null=TRUE







-- NESSE OBJECT ""FILE_FORMAT"",



-- o professor colocou algumas options EXTRAS,


-- como 





-- """"""

-- null_if=('NULL', 'null') --- significa que nosso field será de value null se TIVERMOS 1 STRING DE NOME 'NULL' (uppercase) ou 'null' (lowercase)


-- """"




 



--  e 



-- """"""""
--  empty_field_as_null=TRUE;' -- mesma coisa que o de cima, mas para fields VAZIOS, serao interpretados como null

-- """"""





-- DEPOIS DO CREATE DO FILE_FORMAT OBJECT,


-- CRIAMOS 

-- O STAGE OBJECT,


--  COM ESTE CÓDIGO:






-- Create stage object with integration object and file format object:


    CREATE OR REPLACE STAGE MANAGE_DB.stages.csv_folder
        URL=''
        STORAGE_INTEGRATION=S3_EXAMPLE_INTEGRATION
        FILE_FORMAT=MANAGE_DB.file_formats.csv_fileformat;















-- ok... mas o que devo colocar, nessa url?










--> DEVEMOS COLOCAR A URL DO BUCKET DE QUE QUEREMOS COPIAR...









-- -_> PODEMOS COLOCAR O PATH QUE DEVE SER COPIADO (no caso,

-- o folder de ""csv"", dentro do bucket)..








-- FICA TIPO ASSIM:






-- s3://snowflake-test-masterclass-bucket/CSV/





    CREATE OR REPLACE STAGE MANAGE_DB.stages.csv_folder
        URL='s3://snowflake-test-masterclass-bucket/CSV/'
        STORAGE_INTEGRATION=S3_EXAMPLE_INTEGRATION
        FILE_FORMAT=MANAGE_DB.file_formats.csv_fileformat;








--CERTO...







-- LOGO EMBAIXO,
-- TEMOS A OPTION DE 



-- ""STORAGE_INTEGRATION= "" --> E COLOCAMOS 


-- NOSSO INTEGRATION OBJECT DENTRO 

-- DELE....








-- QUER DIZER QUE:


-- 1) STORAGE INTEGRATION OBJECTS 

-- SAO _ ANEXADOS AOS NOSSOS STAGES 




-- 2) FILE_FORMATS SAO ANEXADOS AOS NOSSOS STAGES....













-- COM ISSO, PODEMOS COPIAR A DATA QUE TEMOS 
-- LÁ DENTRO DO NOSSO S3 BUCKET,


-- PARA 





-- DENTRO 

-- DE NOSSAS DATABASES SNOWFLAKE...








-- O CÓDIGO EXECUTADO É ESTE:


-- use copy command, with stage configured 
-- with file format and storage integration objects....



COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.stages.csv_folder;











    --> RODEI A QUERY, MAS FIQUEI COM UM ___ ERRO___...








-- O ERRO FOI ESTE:




-- """"""
-- Number of columns in file (26)"
-- does not match that of the corresponding table (12), 
-- use file format option error_on_column_count_mismatch=false 
-- to ignore this error

-- """""










--> QUER DIZER QUE OS ROWS DE NOSSA FILE POSSUEM Numero de columns 


-- bem maior do que a table....











--> O PROBLEMA ESTÁ POR CONTA 
-- DA ESCRITA DE 





-- "Joao, maria, luís, renato, julia" --------->  O NOSSO 


-- FILE_FORMAT __ NAO 


-- RECONHECE 

-- "" (double quotes) 


-- COMO UM ""TEXT QUALIFIER"",




-- O QUE QUER DIZER QUE 


-- ELE _ ESTÁ RECONHECENDO 




-- TODAS ESSAS LONGAS STRINGS (strings com vírgula)



-- COMO SE FOSSEM MÚLTIPLOS VALUES, SEPARADOS POR VÍRGULA (

--     pq sao arquivos CSV, comma-separated values...
    
-- )







--> OK.... DEVEMOS AJUSTAR ESSE OBJECT ""FILE_FORMAT"",



-- devemos colocar 1 option de 




-- ""FIELD_OPTIONALL_ENCLOSED_BY= "",


-- E AÍ 

-- COLOCAR ESSE VALUE,


-- de 
-- """...





-- TIPO ASSIM:




-- Create file format - corrected (with FIELD_OPTIONALLY_ENCLOSED_BY="")
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_fileformat
    type = CSV 
    field_delimiter=','
    skip_header=1
    null_if=('NULL', 'NULL')
    empty_field_as_null=TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY='"';





SELECT * FROM OUR_FIRST_DB.PUBLIC.movie_titles;