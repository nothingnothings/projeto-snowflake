-- __ QUEREMOS: 


-- 1) CRIAR COLUMNS PARA CADA 1 DOS FIELDS DESEJADOS...


-- 2) PASSAR ESSE FORMATO "" JSON "" EM COLUMNS,
-- PARA QUE POSSAMOS TRABALHAR COM ELE,
-- COM FACILIDADE...ISSO PQ _ O JSON DATA,
-- NA SUA FORMA PURA,
-- NAO É ALGO COM QUE PODEMOS TRABALHAR,
-- NO SQL...--> MAS O SNOWFLAKE POSSUI 
-- ALGUMAS OPTIONS MT BOAS,
-- PARA FAZER O PARSE DESSA DATA JSON...









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













-- aqui vemos o TERCEIRO passo.


























-- FIRST STEP - LOAD RAW JSON 


 --  CREATE STAGE
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    url='s3://bucketsnowflake-jsondemo';

--  CREATE FILE FORMAT
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE=JSON; //precisamos, pois o default, csv, nao adiantará

--  CREATE TABLE 
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file VARIANT //DATA TYPE EXTREMAMENTE ESPECIAL (é misto)
)



-- ESSA TABLE __ TERÁ APENAS _ 1 ÚNICA COLUMN,
-- E SEU DATA TYPE 
-- SERÁ DO TIPO __ """"VARIANT""""....



-- -> essa column terá 1 nome de ""raw_file"", nesse exemplo...







--SECOND STEP - COPY RAW JSON DATA INTO SINGLE COLUMN, IN JSON_RAW table...


COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    FILE_FORMAT=(
        FORMAT_NAME=MANAGE_DB.FILE_FORMATS.JSONFORMAT
    )
    files=('HR_data.json');


SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

-- column field format (unstructured data, basically): {   "city": "Bakersfield", 
  -- "first_name": "Portia",  
  --  "gender": "Male", 
  --    "id": 1,  
  --     "job": {  
  --          "salary": 32000,   
  --            "title": "Financial Analyst"  
  --             },  
  --              "last_name": "Gioani",  
  --               "prev_company": [],   
  --               "spoken_languages": [    
  --                    {   
  --                           "language": "Kazakh",  
  --                                "level": "Advanced"     },  
  --                                   {       "language": "Lao",   
  --                                       "level": "Basic"     }   ] }







-- THIRD STEP - PARSE AND ANALYZE RAW JSON...

-- special snowflake syntax.
-- Selecting attribute/column by key-name.
SELECT RAW_FILE:city FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; ////EIS O CÓDIGO EM QUESTAO









-- """RAW_FILE"" --> É O NOME DE NOSSA COLUNA, nessa TABLE... 




-- "":city"" --> É UMA __ KEY__, DENTRO DESSA COLUMN, COLUMN DE DATA TYPE ""VARIANT""...




-- É BEM FÁCIL, NA VERDADE..


-- APENAS PRECISAMOS 


-- DA ESTRUTURA 

-- ""COLUMN_NAME:KEY-TO-BE-ACESSED-IN-THE-COLUMN""







-- AQUI TEMOS OUTRO EXEMPLO:

-- é a mesma coisa que ""SELECT RAW_FILE:first_name"", pq vamos selecionar a PRIMEIRA COLUMN dessa table... como essa column só tem 1 column, de nome ""raw_file"", acabamos selecionando a mesma coisa, com "$1"...
SELECT $1:first_name FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;







-- AGORA QUE CONSEGUIMOS ___ PARSEAR__ ESSA DATA,





-- DEVEMOS TENTAR __ FORMATAR ISSO DE UMA MANEIRA MAIS NICE...



-- ISSO PQ __ O 



-- COLUMN_NAME 


-- DE 


-- $1:FIRST_NAME 


-- NAO FICOU LEGAL...



-- SERIA MAIS LEGAL COLOCAR 1 NOME DIFERENTE, 


-- EM VEZ DE 

-- ""$1:FIRST_NAME""...














-- TAMBÉM SERIA MELHOR 




-- SE CONSEGUÍSSEMOS 





-- __CONVERTER _ 




-- OS VALUES QUE FORAM EXTRAÍDOS,


-- PQ ATUALMENTE 




-- ELES ESTAO COM 1 


-- FORMATO 





-- "Mina"


-- "Doug"


-- "Charlie",



-- ETC...






-- --> QUEREMOS TIRAR ESSES "", 

-- e 

-- fazer com que sejam retornados 


-- COMO DATA TYPE __ STRING..








-- SELECT attribute/column by key-name -- FORMATTED RESULTS:


SELECT RAW_FILE:first_name::string as first_name -- eis o código em questao.
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;




-- COM ESSA ESCRITA,

-- DE ""RAW_FILE:firstname::string",


-- CONSEGUIMOS 
-- CONVERTER ESSE VALUE,

-- CONVERTER A 1 DATA TYPE DE ___ STRING__ (em vez de variant)..

-- depois, por meio de 
-- ""as first_name"",

-- CONSEGUIMOS RENOMEAR O NOME DA COLUMN QUE VAI APARECER NO RESULT_SET,

-- PARA ""first_name"" (em vez de $1:first_name)...








-- QUER DIZER QUE "::"" REALIZA A CONVERSAO DOS DATA TYPES DE NOSSAS COLUMNS...







-- MAIS ESTE EXEMPLO:

-- com isso, convertemos o data type do id, de ""string"" para ""INT"...
SELECT RAW_FILE:id::INT as ID FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;











--> AGORA, SE COMBINARMOS TUDO ISSO,


-- PODEREMOS CRIAR 1 TABLE/RESULT SET BEM LEGAL...
-- TIPO ASSIM:



SELECT
    RAW_FILE:id::int as ID,
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;






-- PARA CRIAR 1 NOVA TABLE COM BASE NESSA EXPRESSION, FARÍAMOS ASSIM:



CREATE TABLE some_random_table AS
SELECT
    RAW_FILE:id::int as ID,
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;








-- HANDLING NESTED DATA

SELECT RAW_FILE:job::STRING as JOB from OUR_FIRST_DB.PUBLIC.JSON_RAW; //isso nao vai converter o object, ele ainda vai ficar como 1 object, mas em formato STRING.








--> ISSO NAO É IDEAL, SIM...











-- MAS, FELIZMENTE,




-- TEMOS 1 OPTION BEM FÁCIL


-- DE LIDAR COM ISSO, NO SNOWFLAKE..
-- .





-- VEREMOS ISSO NA PRÓXIMA AULA,

-- ""HEAVY NESTING""....

