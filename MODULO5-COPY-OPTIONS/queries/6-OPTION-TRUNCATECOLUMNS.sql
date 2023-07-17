




-- TEM ESTA SINTAXE:





-- COPY INTO <table_name>
-- FROM @externalStage
-- FILES=('<file_name>', '<file_name2>')
-- FILE_FORMAT=(
--     FORMAT_NAME=xxxx
-- )
-- TRUNCATECOLUMNS = TRUE | FALSE;










-- POR MEIO DESSA OPTION, PODEMOS ESPECIFICAR SE 1 GIVEN COLUMN,

-- OU VALUE NESSA COLUMN,




-- DEVE SER TRUNCATED OU NAO...






-- RESUMO:



-- """"SPECIFIES WHETHER TO TRUNCATE TEXT STRINGS THAT 
-- EXCEED THE TARGET COLUMN LENGTH"""""...









-- SE TEMOS, POR EXEMPLO, 1 TABLE,


-- E NESSA TABLE TEMOS 1 TARGET COLUMN DE TIPO 

-- ""VARCHAR(10)"",



-- ISSO SIGNIFICA QUE ESSA COLUMN 


-- __ PERMITE _ VALUES __ 
-- DE ATÉ 


-- 10 CARACTERES...




-- --> MAS AÍ, SE NOSSO SOURCE,

-- LA NO ARQUIVO CSV/JSON,

-- ESSE CHARACTER NUMBER É EXCEDIDO (como 20 caracteres),



-- ISSO __ GERALMENTE _ VAI CAUSAR 1 ERRO...









-- -> MAS SE SETTARMOS ESSA OPTION DE TRUNCATECOLUMNS COMO 

-- ""TRUE"",



-- AÍ PODEMOS SIMPLESMENTE __ TRUNCATE__ ESSE TEXT,


-- O QUE QUER DIZER QUE FICAREMOS COM OS 10 PRIMEIROS CARACTERES,

-- SENDO DESCARTADO O RESTO...




-- ex:





COPY INTO <table_name>
FROM @externalStage
FILES=('<file_name>', '<file_name2>')
FILE_FORMAT=(
    FORMAT_NAME=xxxx
)
TRUNCATECOLUMNS = TRUE | FALSE;









-- TRUE --> ""STRINGS ARE AUTOMATICALLY TRUNCATED TO THE TARGET COLUMN LENGTH"...


-- FALSE --> ""COPY"" PRODUCES AN ERROR IF A LOADED STRING EXCEEDS THE TARGET COLUMN LENGTH (MAX LENGTH OF A VARCHAR, FOR EXAMPLE)...





-- É CLARO QUE O DEFAULT É _ FALSE__... (é produzido um error, e o snowflake indica isso)...











CREATE OR REPLACE TABLE COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(10),
    SUBCATEGORY VARCHAR(30)
);



//PREPARE STAGE OBJECT 

CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';





LIST @COPY_DB.PUBLIC.aws_stage_copy;




COPY INTO COPY_DB.PUBLIC.ORDERS
FROM @COPY_DB.PUBLIC.aws_stage_copy
FILE_FORMAT=(
   type=csv,
   field_delimiter=',',
   skip_header=1
)
TRUNCATECOLUMNS = TRUE;  --- ou seja, as strings com mais de 10 caracteres serao TRUNCADAS/CORTADAS para caberem nessa column de category...



--> com isso, quando carregamos 


-- a data na table de ""ORDERS"",



-- A COLUMN DE 
-- ""CATEGORY"" 



-- ACABA """""COMENDO"""" 

-- o 

-- 'S' em ""ELETRONICS"",




-- JUSTAMENTE POR CONTA DESSA OPTION... (TRUNCATECOLUMNS = TRUE)...	





COPY INTO COPY_DB.PUBLIC.ORDERS
FROM @COPY_DB.PUBLIC.aws_stage_copy
FILE_FORMAT=(
   type=csv,
   field_delimiter=',',
   skip_header=1
)
TRUNCATECOLUMNS = FALSE;  --- ESSE É O DEFAULT... CASO O VALUE TENHA MAIS DO QUE 10 CARACTERES, ELE VAI DAR O THROW DE 1 ERRO...






-- ganhamos este error: User character length limit (10) exceeded by string 'Electronics'







COPY INTO COPY_DB.PUBLIC.ORDERS
FROM @COPY_DB.PUBLIC.aws_stage_copy
FILE_FORMAT=(
   type=csv,
   field_delimiter=',',
   skip_header=1
)
ON_ERROR=CONTINUE -- com isso, ganharemos errors, sim, mas eles nao vao interromper o LOAD das entries a partir das files... (PARTIALLY_LOADED).
TRUNCATECOLUMNS = FALSE; --- ESSE É O DEFAULT... 









-- ESSA É UMA SIMPLES COPY OPTION,

-- QUE PODEMOS DEFINIR 

-- COMO ""TRUE"",




-- SE QUISERMOS QUE 

-- OS VALUES QUE EXCEDEREM 

-- O LIMIT 



-- FIQUEM SIMPLESMENTE TRUNCADOS (

--     podemos querer usar isso 

--     se __ NAO QUISERMOS TROCAR 

--     O DATA TYPE DE NOSSA COLUMN,

--     E SIM FAZER UM ""FIX PORCO", 
--     POR MEIO 

--     DO SIMPLES TRUNCATE DESSES VALUES QUE SAO INSERIDOS...
-- )