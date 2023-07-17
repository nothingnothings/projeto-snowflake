-- O PROCESSO, RESUMIDO:


-- 1) CREATE STAGE --> FEITA A CONEXAO COM O LOCAL ONDE ESTÁ O ARQUIVO(s)


-- 2) LOAD RAW DATA --> TODA A DATA É CARREGADA 
--                         EM 1 TABLE SEPARADA, 
--                         TABLE COM APENAS 1 COLUMN...
--                         ESSA COLUMN 
--                         É DE 
--                         1 DATA TYPE ESPECIAL... 
--                         DATA TYPE --> O NOME É ""VARIANT""...

-- 3) ANALYZE E PARSE DATA (
--     COM A AJUDA DAS FUNCTIONS SNOWFLAKE...
-- )


-- 4) FLATTEN E LOAD DATA -->  USAMOS MAIS FUNCTIONS SNOWFLAKE,
-- PARA RESOLVER A HIERARQUIA ENTRE OS ARQUIVOS...
-- COMECAMOS COM O CREATE STAGE.










-- COMECAMOS COM O CREATE STAGE.





------- FIRST STEP - LOAD RAW JSON 


-- CREATE STAGE
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    url='s3://bucketsnowflake-jsondemo';

-- CREATE FILE FORMAT
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE=JSON; //precisamos, pois o default, csv, nao adiantará

-- CREATE TABLE 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file VARIANT //DATA TYPE EXTREMAMENTE ESPECIAL (é misto)
)



-- ESSA TABLE __ TERÁ APENAS _ 1 ÚNICA COLUMN,
-- E SEU DATA TYPE 
-- SERÁ DO TIPO __ """"VARIANT""""....



-- -> essa column terá 1 nome de ""raw_file"", nesse exemplo...




-------- SECOND STEP - COPY RAW JSON DATA INTO SINGLE COLUMN, IN JSON_RAW table...


-- COPY RAW JSON DATA
COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    FILE_FORMAT=(
        FORMAT_NAME=MANAGE_DB.FILE_FORMATS.JSONFORMAT
    )
    files=('HR_data.json');

-- CHECK VARIANT DATA TYPE COLUMN's appearance. 
SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;