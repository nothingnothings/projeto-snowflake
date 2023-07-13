
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX 
-- podemos fazer o TRANSFORM de data, enquanto a copiamos para 1 table snowflake, POR MEIO DE SELECT STATEMENTS, por exemplo...
--- assim, o stage inteiro fica representado por 1 alias, o alias de "s_alias"... e entao conseguimos selecionar apenas alguns de seus fields, com s_alias.$1 e s_alias.$2....
FROM (select s_alias.$1, s_alias.$2 FROM @MANAGE_DB.external_stages.aws_stage s_alias)
--$1 é O ORDER_ID... $2 É O AMOUNT...
file_format=(
    type=csv,
    field_delimiter=',',
    skip_header=1
    )
    files=('OrderDetails.csv');




CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT
);


