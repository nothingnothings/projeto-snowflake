








-- COMO CRIAR E "COMPARTILHAR" DATA SHARES, COM OUTRAS CONTAS SNOWFLAKE... (CONSUMER ACCOUNTS)




CREATE OR REPLACE DATABASE DATA_S;




CREATE OR REPLACE STAGE aws_stage
    url='s3://bucketsnowflakes3';




-- LIST FILES IN STAGE 
LIST @aws_stage;


-- create table
CREATE OR REPLACE TABLE DATA_S.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT NUMBER(38,0),
    PROFIT NUMBER(38,0),
    QUANTITY NUMBER(38,0),
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);





-- Load data, using copy command.

COPY INTO DATA_S.PUBLIC.ORDERS 
FROM @MANAGE_DB.stages.aws_stage
FILE_FORMAT=(
    type=csv,
    field_delimiter=',',
    skip_header=1
)
pattern='.*OrderDetails.*';




SELECT * FROM ORDERS;





-- certo.... isso criou essa table,

-- e copiou essas rows para dentro dela...









-- É ESSA  A TABLE QUE VAMOS QUERER COMPARTILHAR 


-- COM OUTRAS CONTAS....





-- para criar 1 object "data share", usado para o data sharing, escrevemos:




-- Create a share object (data sharing)
CREATE OR REPLACE SHARE ORDERS_SHARE;


-- SINTAXE:
-- CREATE OR REPLACE SHARE <share_name>;












--> PARA SETTAR ESSA SHARE,

-- PRECISAMOS DEFINIR OS __ "GRANTS" DELA....







-- -> AS PRIMEIRAS ETAPAS SERAO  


-- DAR __ GRANT __ DE "USAGE"

-- NA DATABASE E TAMBÉM NO SCHEMA EM SI...






-- GRANTS NEEDED FOR DATA SHARING --


-- Grant usage on DATABASE
GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE;




-- Grant usage on SCHEMA 
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE;


-- Grants SELECT usage on this specific table
GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE;


-- Check if Grants were given to share object:
SHOW GRANTS TO SHARE ORDERS_SHARE; -- usage, usage and select (on a single table).



-- Done (on the PRODUCER account side). Now we only need to have a CONSUMER ACCOUNT.







-- Creating/setting up a CONSUMER ACCOUNT.







-- -> QUER DIZER QUE 

-- PRECISAMOS FAZER "ADD"



-- DA __ CONSUMER __ ACCOUNT


-- A ESSE OBJECT DE "SHARE",



-- TUDO PARA QUE _ O CONSUMER 
-- CONSIGA 


-- SER CAPAZ DE _USAR __ESSE SHARE...





-- PARA ISSO, RODAMOS:







---- Add Consumer Account to DATA SHARE OBJECT ----

ALTER SHARE ORDERS_SHARE ADD ACCOUNT=kaaa21312;






-- OK... MAS O PROBLEMA É QUE 

-- PRECISAMOS 

-- DE 1 


-- ID VÁLIDO, AQUI...


-- -> precisamos do "UNIQUE ACCOUNT NUMBER"...







--> ESSE ACCOUNT NUMBER É ENCONTRADO 

-- NA __ URL__... 


-- --> NO NOSSO CASO, É 


-- znb24252


ALTER SHARE ORDERS_SHARE ADD ACCOUNT=kaaa21312;










-- PARA ISSO, PRECISAMOS DE OUTRA 

-- CONTA, 

-- PARA 


-- VER OS RESULTADOS DESSE DATA SHARE....



-- NA OUTRA CONTA (PRECISAMOS 

-- DE OUTRA CONTA, COM WORKSHEETS E ETC)















-- OS CÓDIGOS QUE DEVEM/PODEM SER EXECUTADOS PELO 
-- CONSUMER ESTAO ESCRITOS EM "3-DATA-SHARING-CONSUMER-ACCOUNT-SIDE"...