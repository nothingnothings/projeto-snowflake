COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
FROM (select s_alias.$1, s_alias.$2 FROM @MANAGE_DB.external_stages.aws_stage s_alias)
file_format=( --MANEIRA DEFAULT DE ESTIPULAR 1 FILE_fORMAT (temos que 
--repetir em cada COPY INTO statement... nada prático.
)
    type=csv,
    field_delimiter=',',
    skip_header=1
    )
    files=('OrderDetails.csv');





-- É POR ISSO QUE PRECISAMOS CRIAR OBJECTS "file_format", para evitar 
-- essa repeticao de código.



-- CREATING TABLE 

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (

    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

-- CREATING SCHEMA TO KEEP THINGS ORGANIZED 
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;


-- Creating File Format object - com isso criamos 1 file format de nome 
--  'my_file_format'
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.my_file_format;



DESC FILE FORMAT my_file_format; --visualizamos o file_format que criamos...







--COPY INTO COMMAND QUE USA NOSSO OBJECT "FILE FORMAT", de nome my_file_format....
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
    FROM @MANAGE_DB.external_stages.aws_stage_errors_example
    file_format=(
        FORMAT_NAME=MANAGE_DB.file_formats.my_file_format
    )
    files=('OrderDetails_error.csv')
    ON_ERROR='SKIP_FILE_3';





-- OK.... É ASSIM QUE PODEMOS 




--  CRIAR-_ E ALTERAR __ AS options



--  DE 1 

--  OBJECT "file_format"...























COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
FROM (select s_alias.$1, s_alias.$2 FROM @MANAGE_DB.external_stages.aws_stage s_alias)
file_format=( //MANEIRA DEFAULT DE ESTIPULAR 1 FILE_fORMAT (temos que 
//repetir em cada COPY INTO statement... nada prático.
)
    type=csv,
    field_delimiter=',',
    skip_header=1
    )
    files=('OrderDetails.csv');





-- É POR ISSO QUE PRECISAMOS CRIAR OBJECTS "file_format", para evitar 
-- essa repeticao de código.




-- CREATING TABLE 

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (

    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);


-- CREATING SCHEMA TO KEEP THINGS ORGANIZED 
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;


-- Creating File Format object - com isso criamos 1 file format de nome 
-- 'my_file_format'
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.my_file_format;



DESC FILE FORMAT my_file_format;


-- ALTERING FILE FORMAT OBJECT's defaults
ALTER FILE FORMAT MANAGE_DB.file_formats.my_file_format 
    SET SKIP_HEADER = 1;


-- TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;



--COPY INTO COMMAND QUE USA NOSSO OBJECT "FILE FORMAT", de nome my_file_format....
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
    FROM @MANAGE_DB.external_stages.aws_stage_error_example
    file_format=(
        FORMAT_NAME=MANAGE_DB.file_formats.my_file_format
    )
    files=('OrderDetails_error.csv')
    ON_ERROR='SKIP_FILE_4';



-- alter the type of a given FILE_fORMAT OBJECT.
ALTER FILE FORMAT MANAGE_DB.file_formats.my_file_format
SET TYPE=CSV;

-- -- ^^^^^^^^
-- MAS VEREMOS QUE __ ISSO 

-- __ NAO FUNCIONARÁ,



-- NO SNOWFLAKE...


-- --> MAS PQ ISSO NAO FUNCIONA,

-- NO SNOWFLAKE?


-- -> ISSO N FUNCIONA PQ,

-- DEPENDENDO DO TYPE (csv ou JSON),


-- HÁ 

-- __DIFERENTES_ FILE OPTIONS __ 


-- ANEXADAS __ A ESSE OBJECT 

-- "file_format"....







-- --> QUER DIZER QUE, 

-- PARA O TYPE 

-- """CSV""", TEMOS DIFERENTES 



-- OPTIONS, NESSE FILE FORMAT OBJECT,



-- DO QUE 



-- OS 
-- FILE FORMAT OBJECTS DE TYPE "JSON"...
















-- --> ISSO QUER DIZER, EM OUTRAS PALAVRAS,



-- QUE É ______ IMPOSSÍVEL___ 


-- ALTERAR APENAS O TYPE 


-- DE 1 FILE_FORMAT OBJECT,


-- DEPOIS 

-- DE 
-- ELE 
-- JÁ TER SIDO CRIADO....





-- é por isso que ganhamos uma mensagem 



-- de error,



-- "FILE FORMAT TYPE CANNOT 
-- BE CHANGED"...









-- PARA REALMENTE MUDARMOS 

-- O TYPE DESSE FILE_FORMAT,

-- SOMOS OBRIGADOS A 

-- __rECRIAR ESSE FILE_FORMAT OBJECT...











--DEFINING PROPERTIES OF A FILE FORMAT, ON THE MOMENT 
--OF THE CREATION OF THE FILE FORMAT OBJECT:


CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;



--RECREATING A FILE FORMAT OBJECT, to have its type reset to the default (CSV)... so we unset the custom value of //"json" for its type 

CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.my_file_format
    -- TYPE=CSV ///as it is the default, we dont even need to specify it
    TIME_FORMAT=AUTO;








COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_error_example
    file_format=(
        FORMAT_NAME=MANAGE_DB.file_formats.my_file_format
        type=json -- assim, é possível fazer overwrite de APENAS ALGUMAS PROPRIEDADES DO FILE FORMAT OBJECT, e nao de todas as properties... (e apenas durante esse comando de "copy into")
    )
    files=('OrderDetails_error.csv')
    ON_ERROR='SKIP_FILE_5';






-- no caso,

-- USAMOS AS PROPRIEDADES 


-- DO 

-- "FILE FORMAT OBJECT"






-- PARA OVERWRITTAR 


-- AS __ PROPERTIES __ 

-- DO STAGE OBJECT...







-- -> A ORDEM DE PREFERENCIA, PORTANTO É:








-- file_format DENTRO DO COPY INTO 

--  >

-- file_format object no lado de fora

--  >

--  stage object 