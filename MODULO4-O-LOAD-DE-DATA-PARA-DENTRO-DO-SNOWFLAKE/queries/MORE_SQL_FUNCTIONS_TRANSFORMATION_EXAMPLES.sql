CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
); //para recriar/esvaziar a table anterior...







COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX (ORDER_ID, PROFIT) -- com isso, inserimos apenas nas columns de números 1 e 3, e o resto das columns, nessa table (amount e profitable_flag) FICAM/FICARAO VAZIAS (isso é possível out of the box, com o snowflake)....
FROM (
    SELECT s_alias.$1,
           s_alias.$3
           FROM @MANAGE_DB.external_stages.aws_stage s_alias)
    file_format=(    
        type=csv,
        field_delimiter=',',
        skip_header=1)
    files=('OrderDetails.csv');










-- exemplo 5 - AUTO INCREMENT ID...




CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID NUMBER autoincrement start 1 increment 1,  -- criamos um id artificial, que será autoincrementing...
    amount INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
);


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX (PROFIT, AMOUNT) -- com isso, inserimos apenas nas columns de números 1 e 3, e o resto das columns, nessa table (amount e profitable_flag) FICAM/FICARAO VAZIAS (isso é possível out of the box, com o snowflake)....
FROM (
    SELECT s_alias.$2,
           s_alias.$3
           FROM @MANAGE_DB.external_stages.aws_stage s_alias)
    file_format=(    
        type=csv,
        field_delimiter=',',
        skip_header=1)
    files=('OrderDetails.csv');








-- versao chat GPT:








-- -- Create a sequence object
-- CREATE SEQUENCE my_sequence;

-- -- Create a table with an auto-increment ID column
-- CREATE TABLE my_table (
--   id NUMBER DEFAULT my_sequence.NEXTVAL,
--   name VARCHAR(50),
--   age INTEGER
-- );
