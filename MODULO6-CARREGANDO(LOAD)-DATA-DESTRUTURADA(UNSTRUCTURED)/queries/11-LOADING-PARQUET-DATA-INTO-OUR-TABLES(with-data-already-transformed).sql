


SELECT 
$1:__index_level_0__::STRING as index,
$1:cat_id::STRING as cat_id_1,
DATE($1:date::INT) as date_1,
$1:"__index_level_0__"::STRING as index2,
$1:"cat_id"::STRING as cat_id_2,
$1:"d"::STRING as d,
DATE($1:"date"::INT) as date_2,
$1:"dept_id"::STRING as dept_id,
$1:"id"::STRING as id,
$1:"item_id"::STRING as item_id,
$1:"state_id"::STRING as state_id,
$1:"store_id"::STRING as store_id,
$1:"value"::INT as value
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;







-- VIMOS QUE PODEMOS QUERIAR 




-- DATA _ _DIRETAMENTE__ DE NOSSO STAGE,


-- E QUE 

-- PODEMOS __ FAZER 

-- ISSO 





-- COM PARQUET DATA....




--> PARA FAZER ISSO COM PARQUET DATA,


-- BASTA USAR O ":",

-- para se referir 


-- aos objects....




-- --> E DESCOBRIMOS, TAMBÉM, QUE PODEMOS __ CONVERTER __ OS 
-- DATA TYPES DE CADA COLUMN, NA NOSSA TABLE. (converter a data que chega da 
-- parquet file/csv file/json file, para que encaixe nas nossas tables










-- MAS QUANDO MANIPULAMOS DATA DE FILES COMO PARQUET FILES,

-- TEMOS 

-- OPCOES ADICIONAIS...

--> TEMOS A POSSIBILIDADE _ DE ADICIONAR __ METADATA_ 
-- À DATA QUE É EXTRAÍDA...











-- KEYWORDS METADATA QUE PODEM SER USADOS:

-- METADATA$FILENAME 

-- METADATA$FILE_ROW_NUMBER








-- EX:






-- outro exemplo:
SELECT 
$1:__index_level_0__::STRING as index,
$1:cat_id::VARCHAR(50) as cat_id_1,
DATE($1:date::INT) as date_1,
$1:"__index_level_0__"::STRING as index2,
$1:"cat_id"::STRING as cat_id_2,
$1:"d"::STRING as d,
DATE($1:"date"::INT) as date_2,
$1:"dept_id"::VARCHAR(50) as dept_id,
$1:"id"::VARCHAR(50) as id,
$1:"item_id"::VARCHAR(50) as item_id,
$1:"state_id"::VARCHAR(50) as state_id,
$1:"store_id"::VARCHAR(50) as store_id,
$1:"value"::INT as value,
METADATA$FILENAME as FILENAME,  --aqui 
METADATA$FILE_ROW_NUMBER as ROWNUMBER, -- aqui
TO_TIMESTAMP_NTZ(current_timestamp) as load_date, --aqui (também é mtadata, mas construída sem keywords)
CONVERT_TIMEZONE('America/Sao_Paulo', CURRENT_TIMESTAMP()) AS load_date_brasil
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;






--> OK... PODEMOS ADICIONAR O TIMESTAMP,
-- PARA QUE SAIBAMOS QUANDO ESSA DATA FOI CARREGADA.... -> ISSO PODE SER BEM ÚTIL...











----------------------










-- EXEMPLO FINAL:









-- outro exemplo:
SELECT 
$1:__index_level_0__::STRING as index,
$1:cat_id::VARCHAR(50) as cat_id_1,
DATE($1:date::INT) as date_1,
$1:"__index_level_0__"::STRING as index2,
$1:"cat_id"::STRING as cat_id_2,
$1:"d"::STRING as d,
DATE($1:"date"::INT) as date_2,
$1:"dept_id"::VARCHAR(50) as dept_id,
$1:"id"::VARCHAR(50) as id,
$1:"item_id"::VARCHAR(50) as item_id,
$1:"state_id"::VARCHAR(50) as state_id,
$1:"store_id"::VARCHAR(50) as store_id,
$1:"value"::INT as value,
METADATA$FILENAME as FILENAME,  --aqui 
METADATA$FILE_ROW_NUMBER as ROWNUMBER, -- aqui
TO_TIMESTAMP_NTZ(current_timestamp) as load_date, --aqui (também é mtadata, mas construída sem keywords)
current_timestamp as load_date_with_timezone,
CONVERT_TIMEZONE('America/Sao_Paulo', CURRENT_TIMESTAMP()) AS load_date_brasil
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;











-- agora que selecionamos essa data e já a queriamos,






-- PODEMOS CRIAR A DESTINATION TABLE,

-- COM ESTE COMANDO:




CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.example_table AS 
    SELECT 
        $1:__index_level_0__::STRING as index,
        $1:cat_id::VARCHAR(50) as cat_id_1,
        DATE($1:date::INT) as date_1,
        $1:"__index_level_0__"::STRING as index2,
        $1:"cat_id"::STRING as cat_id_2,
        $1:"d"::STRING as d,
        DATE($1:"date"::INT) as date_2,
        $1:"dept_id"::VARCHAR(50) as dept_id,
        $1:"id"::VARCHAR(50) as id,
        $1:"item_id"::VARCHAR(50) as item_id,
        $1:"state_id"::VARCHAR(50) as state_id,
        $1:"store_id"::VARCHAR(50) as store_id,
        $1:"value"::INT as value,
        METADATA$FILENAME as FILENAME,  --aqui 
        METADATA$FILE_ROW_NUMBER as ROWNUMBER, -- aqui
        TO_TIMESTAMP_NTZ(current_timestamp) as load_date, --aqui (também é mtadata, mas construída sem keywords)
        current_timestamp as load_date_with_timezone,
        CONVERT_TIMEZONE('America/Sao_Paulo', CURRENT_TIMESTAMP()) AS load_date_brasil
        FROM @MANAGE_DB.STAGES.PARQUET_STAGE;







-- DEPOIS DISSO, INSERIMOS A DATA, COM ESTE COMANDO:




COPY INTO MANAGE_DB.PUBLIC.example_table
    FROM (
        SELECT
            METADATA$FILE_ROW_NUMBER,
            $1:__index_level_0__::INT,
            $1:cat_id::VARCHAR(50),
            DATE($1:date::INT),
            $1:"dept_id"::VARCHAR(50),
            $1:"id"::VARCHAR(50),
            $1:"item_id"::VARCHAR(50),
            $1:"state_id"::VARCHAR(50),
            $1:"store_id"::VARCHAR(50),
            $1:"value"::INT,
            TO_TIMESTAMP_NTZ(current_timestamp)
        FROM @MANAGE_DB.STAGES.PARQUET_STAGE
    );









-- --> AQUI O PROFESSOR NAO CRIOU 1 TABLE SEPARADA,

-- NAO CRIOU 1 TABLE SEPARADA PARA COPIAR A RAW FILE PARA DENTRO... (o que 
-- pode ser uma practice nao tao boa)...






--> A MELHOR PRACTICE POSSÍVEL É:






-- 1) EXTRAIR A DATA DE 1 STAGE 



-- 2) COPIAR A DATA EM 1 TABLE SEPARADA, 

-- EM QUE TODA A DATA FIQUE EM 1 COLUMN...




-- 3) DEPOIS, A PARTIR DESSA TABLE SEPARADA, 
-- CRIAR 1 OUTRA TABLE, NOVA TABLE,


-- COM OS VALUES SEPARADOS ADEQUADAMENTE EM COLUMNS... (fazemos isso com 
-- FLATEN() e TABLE())....



