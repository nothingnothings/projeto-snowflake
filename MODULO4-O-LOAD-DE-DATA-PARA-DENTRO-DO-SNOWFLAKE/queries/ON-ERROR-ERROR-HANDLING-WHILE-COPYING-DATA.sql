

-- CREATE NEW STAGE


CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_error_example
    url='s3://bucketsnowflakes4';




-- LIST FILES IN STAGE


LIST @MANAGE_DB.external_stages.aws_stage_error_example;





-- create or replace table

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);



-- DEMONSTRATING ERROR MESSAGE (about possible error handling options)


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_error_example

    file_format=(type=csv,
    field_delimiter=',',
    skip_header=1
    );
-- ON_ERROR='ABORT STATEMENT'; ////ESTE É O COMPORTAMENTO DEFAULT DAS COPY OPERATIONS NO SNOWFLAKE (se existir 1 erro, a operation é ABORTADA)
-- e ESSE ABORT ACONTECE COM TODAS AS FILES ENVOLVIDAS NO COPY, E NAO SÓ A FILE QUE PRODUZIU O ERRO.




-- ERROR HANDLING BEHAVIOR 1... ON_ERROR = CONTINUE.


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_error_example

    file_format=(type=csv,
    field_delimiter=',',
    skip_header=1
    )
    ON_ERROR='CONTINUE';























-- ERROR HANDLING BEHAVIOR 3... ON_ERROR = SKIP_FILE, mas com ___ERROR_LIMIT (ON_ERROR=SKIP_FILE_X)
-- o "X" será o NÚMERO DE ERRORS QUE DEVEMOS TER, EM 1 GIVEN FILE, PARA SKIPPARMOS O LOAD DA FILE INTEIRA.
-- COM ESSE BEHAVIOR, SKIPPAMOS AS FILES QUE DERAM ERRO, MAS O RESTO DAS FILES ACABA EXECUTADO E INSERIDO NA TABLE.

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_error_example

    file_format=(type=csv,
    field_delimiter=',',
    skip_header=1
    )
    ON_ERROR='SKIP_FILE_1000'; --skippamos a file que deu erro, MAS __ APENAS_ SE TIVERMOS 1000 OU MAIS ERRORS.
-- PODEMOS TAMBÉM ESPECIFICAR UMA PORCENTAGEM, TIPO ASSIM:
-- ON_ERROR='SKIP_FILE_10%'; --skippamos a file que deu erro, MAS __ APENAS_ SE TIVERMOS 10% OU MAIS ERRORS.