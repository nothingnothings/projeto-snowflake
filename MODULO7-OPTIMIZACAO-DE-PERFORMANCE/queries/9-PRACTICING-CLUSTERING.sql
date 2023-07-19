
-- Public accessible staging area 


CREATE OR REPLACE STAGE MANAGE_DB.stages.aws_stage
    url='s3://bucketsnowflakes3';



-- List files in stage 

LIST @MANAGE_DB.stages.aws_stage;



-- Load data, using copy command 



COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MAANGE_DB.stages.aws_stage
    FILE_FORMAT=(
        TYPE=csv,
        field_delimiter=',',
        skip_header=1
    )
    PATTERN='.*Orderdetails.*';




-- Create table 

    CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_CACHING (
        ORDER_ID VARCHAR(30),
        AMOUNT NUMBER(38, 0),
        PROFIT NUMBER(38, 0),
        QUANTITY NUMBER(38, 0),
        CATEGORY VARCHAR(30),
        SUBCATEGORY VARCHAR(30),
        DATE DATE
    );



-- insert data into table 



-- TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS;

USE DATABASE OUR_FIRST_DB;


INSERT INTO ORDERS_CACHING
    SELECT 
t1.ORDER_ID,
t1.AMOUNT,
t1.PROFIT,
t1.QUANTITY,
t1.CATEGORY,
t1.SUBCATEGORY,
DATE(UNIFORM(1500000000000, 1700000000000, RANDOM() ))
FROM ORDERS t1
CROSS JOIN (SELECT * FROM ORDERS) t2
CROSS JOIN (SELECT TOP 100 * FROM ORDERS) t3;

    


--> esta query é mais complexa..
--> DEMORA 4 MINUTOS, COM A WAREHOUSE DE TAMANHO EXTRA SMALL...







--> QUANDO CRIARMOS ESSA TABLE,



-- DE ""ORDERS_CACHING"",







-- PERCEBEMOS QUE 


-- FICAMOS SEM NENHUM CLUSTER KEY NELA...





-- Query performance BEFORE cluster key 


SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-06-09';




-- Adding CLUSTER KEY:
ALTER TABLE ORDERS_CACHING CLUSTER BY (DATE);







-- QUERY PERFORMANCE __ AFTER __ CLUSTER KEY

SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-06-05';







-- --> o tablescan TOMOU 67.9% -->  E FOI 1 FULL SCAN --> 


-- TODAS AS PARTITIONS FORAM ESCANEADAS... --> ISSO ACONTECEU/ACONTECE 


-- PQ _ DEMORA __ ALGUMAS HORAS PARA 


-- 1 NOVA CLUSTER KEY SER ADICIONADA/IMPLEMENTADA..










-- --> DEVEMOS ESPERAR ALGUNS MINUTOS,

-- E RODAR 

-- DE NOVO..



-- --> MUDAMOS 1 POUCO A DATA USADA NO STATEMENT,

-- PARA NAO USARMOS O CACHING DO SNOWFLAKE...








-- NOT IDEAL CLUSTERING TARGET EXAMPLE (dont do this), AND USING EXPRESSIONS/FUNCTIONS IN THE PLACE OF COLUMNS, to create clusters:

SELECT * FROM ORDERS_CACHING WHERE MONTH(DATE)=8;




-- takes a while - more than 5 seconds - we can use this EXPRESSION as a cluster key... (é diferente de usar a PRÓPRIA COLUMN DE ""DATE"" COMO CLUSTER KEY)...)
SELECT * FROM ORDERS_CACHING WHERE MONTH(DATE)=8;




