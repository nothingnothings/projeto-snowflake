

-- AGORA ESTUDAREMOS OUTRO FILE FORMAT QUE 

-- PODEMOS USAR E PROCESSAR NO SNOWFLAKE,

-- O 

-- FILE FORMAT 




-- DE 


-- """"PARQUET"""...








-- TYPE """"PARQUET"""""-->  é um DATA FORMAT 



-- DO ECOSSISTEMA __APACHE_ HADOOP...










-- CRIAMOS O FILE FORMAT E O STAGE ""PARQUET"" DESTA FORMA:


CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.parquet_format
    type='parquet';

CREATE OR REPLACE SCHEMA MANAGE_DB.STAGES;

CREATE OR REPLACE STAGE MANAGE_DB.STAGES.parquet_stage
    url='s3://snowflakeparquetdemo'
    FILE_FORMAT=MANAGE_DB.FILE_FORMATS.parquet_format;


LIST @MANAGE_DB.STAGES.parquet_stage;










--> A VANTAGEM DESSE DATA FORMAT É QUE 



-- __ ELE POSSUI _ UM DATA __ COMPRESSING MT EFICIENTE...





-- > O PROFESSOR DIZ QUE PODE SER BEM ÚTIL 


-- SER __ CAPAZ_ DE QUERIAR_ DATA 


-- DIRETAMENTE DESSE STAGE... --->  PQ SE PUDERMOS VISUALIZAR 


-- ESSA DATA DIRETAMENTE,

-- PODEMOS CRIAR NOSSAS TABLES A PARTIR DISSO...




-- PARA ISSO, RODAMOS:



SELECT * FROM @MANAGE_DB.STAGES.parquet_stage;







-- O FORMATO DE CADA ROW É ESTE:


{   "__index_level_0__": 7,
   "cat_id": "HOBBIES", 
     "d": 489,  
      "date": 1338422400000000, 
        "dept_id": "HOBBIES_1",
           "id": "HOBBIES_1_008_CA_1_evaluation",  
            "item_id": "HOBBIES_1_008", 
              "state_id": "CA",   
              "store_id": "CA_1",  
               "value": 12 }






--> O PROFESSOR REITERA QUE O FILE_FORMAT DEFAULT É 

-- DE TYPE

-- CSV....







---> MAS SE ESTAMOS TRABALHANDO COM OUTROS DATA TYPES,

-- COMO PARQUET DATA,

-- ISSO É 
-- ABSOLUTAMENTE NECESSÁRIO...









--> POR FIM, O PROFESSOR NOS FALA DE OUTRA SINTAXE, ALTERNATIVA,



-- QUE PODEMOS COLOCAR 


-- NOS NOSSOS SELECT STATEMENTS,


-- SE _ NAO __ ESPECIFICAMOS O FILE_FORMAT ANTERIORMENTE...





--> PARA ISSO, A ESCRITA FICA ASSIM:




SELECT * FROM @MANAGE_DB.STAGES.parquet_stage
    (file_format => 'MANAGE_DB.FILE_FORMATS.parquet_format');









--> AGORA QUE CRIAMOS ESSE STAGE OBJECT 

-- E QUERIAMOS A DATA,



-- PODEMOS __ CRIAR __ NOSSA 


-- TABLE, para encaixar esses dados....











--> AS COLUMNS QUE USAREMOS SAO ESTAS:


--> COMO TEMOS APENAS 1 ÚNICA COLUMN, ESCREVEMOS ASSIM:





 // Syntax for Querying unstructured data

SELECT 
$1:__index_level_0__,
$1:cat_id,
$1:date,
$1:"__index_level_0__",
$1:"cat_id",
$1:"d",
$1:"date",
$1:"dept_id",
$1:"id",
$1:"item_id",
$1:"state_id",
$1:"store_id",
$1:"value"
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;







-- É POR ISSO QUE USAMOS ""$1"",

-- PARA PEGARMOS ESSA SINGLE COLUMN DISPONÍVEL...

-- depois usamos ":", para nos referirmos às keys dentro de cada data...



-- OBS: SE EXISTIREM ESPACOS ENTRE OS NOMES DAS COLUMNS, 
-- VOCE PRECISA USAR "" e underscores, para nao quebrar seu código











-- VERSAO MAIS ORGANIZADA DESSA QUERY:








VERSAO MAIS ORGANIZADA DESSA QUERY:




SELECT 
$1:__index_level_0__ as index,
$1:cat_id as cat_id_1,
$1:date as date,
$1:"__index_level_0__" as index2,
$1:"cat_id" as cat_id_2,
$1:"d" as d,
$1:"date" as date,
$1:"dept_id" as dept_id,
$1:"id" as id,
$1:"item_id" as item_id,
$1:"state_id" as state_id,
$1:"store_id" as store_id,
$1:"value" as value
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;








-- MAS AQUI JÁ ENCONTRAMOS ALGUNS PROBLEMAS...










-- 1o problema) --> O COLUMN_NAME --> MAS JÁ RESOLVI ISSO, BASTA USAR 
-- ALIASES PARA CADA COLUMN...





-- 2o problema) --> A DATA DAS COLUMNS/KEYS ESTÁ SENDO EXTRAÍDA COMO ""VARIANT DATA""


-- (
--     ou seja, ficamos com 

--     "HOBBIES" em vez de HOBBIES...
-- )







-- PARA CONSERTAR O SEGUNDO PROBLEMA, PRECISAMOS USAR A SINTAXE DE TRANSFORMACAO, COM ::STRING no value, tipo assim:




SELECT 
$1:__index_level_0__::STRING as index,
$1:cat_id::STRING as cat_id_1,
$1:date::STRING as date,
$1:"__index_level_0__"::STRING as index2,
$1:"cat_id"::STRING as cat_id_2,
$1:"d"::STRING as d,
$1:"date"::STRING as date,
$1:"dept_id"::STRING as dept_id,
$1:"id"::STRING as id,
$1:"item_id"::STRING as item_id,
$1:"state_id"::STRING as state_id,
$1:"store_id"::STRING as store_id,
$1:"value"::INT as value
FROM @MANAGE_DB.STAGES.PARQUET_STAGE;












-- MAS AINDA PRECISAMOS CONVERTER AS DATES, QUE ESTAO EM FORMATOS ERRADOS...

-- PARA ISSO, ESCREVEMOS:







--  DATE CONVERSION:




SELECT 1; -- ficamos apenas com o value, 1....



SELECT DATE(60*60*24); --  DATE() --> CONVERTE NÚMEROS GRANDES EM DIAS... -- FICAMOS COM 1970-01-02


SELECT DATE(0); ---- DATE() --> FICAMOS COM 1970-01-01 (é a origem, o marco inicial de contagem de dates)





-- -> ISSO ILUSTRA BEM QUE _  A DATE, ARMAZENADA COMO INTEGER NUMBER,

-- É APENAS __ UMA REPRESENTACAO EM SEGUNDOS 

-- DESDE AQUELA DATA LÁ (1970-01-01)...







EX:







SELECT 1; -- ficamos apenas com o value, 1....



SELECT DATE(60*60*24); --  DATE() --> CONVERTE NÚMEROS GRANDES EM DIAS... -- FICAMOS COM 1970-01-02


SELECT DATE(0); ---- DATE() --> FICAMOS COM 1970-01-01 (é a origem, o marco inicial de contagem de dates)


SELECT DATE(365*60*60*24); --> 365 DIAS DEPOIS DO MARCO 0 (ou seja, 1 ano depois, 1971-01-01).






--> AGORA PODEMOS FAZER A MESMA COISA COM A COLUMN DE ""DATE"" (que está como INT),


-- nessa data extraída do arquivo parquet...









-- RODAMOS ASSIM:



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




