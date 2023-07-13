-- CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
--     ORDER_ID VARCHAR(30),
--     AMOUNT INT,
--     PROFIT INT,
--     QUANTITY INT,
--     CATEGORY VARCHAR(30),
--     SUBCATEGORY VARCHAR(30)
-- );



-- SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;


-- --* FIRST COPY COMMAND - SNOWFLAKE




-- COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
--     FROM @aws_stage
--     file_format = (
--         type=csv
--         field_delimiter=','
--         skip_header=1
--     );















USE DATABASE OUR_FIRST_DB;

CREATE OR REPLACE STAGE OUR_FIRST_DB.PUBLIC.aws_stage
  url='s3://bucketsnowflakes3';

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);


SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;

LIST @aws_stage;


-- --* FIRST COPY COMMAND - SNOWFLAKE

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
-- COM CONTEXTO (basta escrever o @nome_do_stage): 
    -- FROM @aws_stage/OrderDetails.csv
-- SEM CONTEXTO (preferível, caminho completo, com @db>schema>stage_object):
    -- FROM @OUR_FIRST_DB.PUBLIC.aws_stage/OrderDetails.csv
    -- file_format = (
    --     type=csv
    --     field_delimiter=','
    --     skip_header=1
    -- );

    -- *  SINTAXE ALTERNATIVA (definindo 1 lista de files a serem fetcheadas, em vez de 1 só):

    FROM @OUR_FIRST_DB.PUBLIC.aws_stage/OrderDetails.csv
    file_format = (
        type=csv
        field_delimiter=','
        skip_header=1
    )
    files=('OrderDetails.csv');
