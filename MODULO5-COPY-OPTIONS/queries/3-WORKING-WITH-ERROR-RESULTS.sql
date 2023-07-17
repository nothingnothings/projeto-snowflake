-- WORKING WITH ERROR RESULTS (with rows that errored out)


-- 1) SAVING REJECTED _ FILES __ AFTER/WITH _ VALIDATION MODE__...
CREATE OR REPLACE TABLE COPY_DB.PUBLIC.ORDERS (
        ORDER_ID VARCHAR(30),
        AMOUNT VARCHAR(30),
        PROFIT INT,
        QUANTITY INT,
        CATEGORY VARCHAR(30),
        SUBCATEGORY VARCHAR(30)
    );



-- isso vai ERROR OUT
COPY INTO COPY_DB.PUBLIC.ORDERS
FROM @aws_stage_copy FILE_FORMAT =(
        type = csv,
        field_delimiter = ',',
        skip_header = 1
    ) pattern = '.*Order.*'
     VALIDATION_MODE = RETURN_ERRORS;






-- SUPER GAMBIARRA - STORING REJECTED/FAILED RESULTS IN A TABLE (another table) - NOS DEIXA ARMAZENAR OS FAILED RECORDS DA QUERY ANTERIOR _ EM UMA TABLE _ ADICIONAL....
-- vamos pegar todos os values DA ÚLTIMA QUERY QUE FOI EXECUTADA (a de cima)...
-- CREATE OR REPLACE TABLE rejected AS 
-- SELECT * FROM table(result_scan(last_query_id())); ---usamos a ""TABLE()"" FUNCTION, junto com result_scan() e last_query_id()... nesting de functions.

-- usamos também a function ""RESULT_SCAN()"" --> É UMA FUNCTION PROVIDENCIADA PELO SNOWFLAKE, QUE NOS DEIXA __ PEGAR ALGUNS DOS RESULTS QUE TENHAM OCORRIDO NAS ÚLTIMAS 24 HORAS....



-- SUPER GAMBIARRA - STORING REJECTED/FAILED RESULTS IN A TABLE (another table) - NOS DEIXA ARMAZENAR OS FAILED RECORDS DA QUERY ANTERIOR _ EM UMA TABLE _ ADICIONAL....
-- vamos pegar __aPENAS__ A COLUMN DE ""rejected_record"" DA ÚLTIMA QUERY QUE FOI EXECUTADA (a de cima)...

CREATE OR REPLACE TABLE rejected AS 
SELECT rejected_record FROM table(result_scan(last_query_id())); ---usamos a ""TABLE()"" FUNCTION, junto com result_scan() e last_query_id()... nesting de functions.

-- usamos também a function ""RESULT_SCAN()"" --> É UMA FUNCTION PROVIDENCIADA PELO SNOWFLAKE, QUE NOS DEIXA __ PEGAR ALGUNS DOS RESULTS QUE TENHAM OCORRIDO NAS ÚLTIMAS 24 HORAS....




-- com isso, conseguimos 1 table, de nome ""rejected", com 1 column, de nome ""rejected_record""...


-- AS GAMBIARRAS SAO:


-- 1)  a function ""RESULT_SCAN()"" --> É UMA
--  FUNCTION PROVIDENCIADA PELO SNOWFLAKE, 
--  QUE NOS DEIXA __ PEGAR ALGUNS DOS RESULTS 
--  QUE TENHAM OCORRIDO NAS ÚLTIMAS 24 HORAS.... ----> E ESSA FUNCTION PRECISA _DE 1 ID __ PARA ___ENCONTRAR__ 1 RESULT, ENCONTRA 1 RESULT, COM BASE EM 1 ID DE ALGUMA QUERY...


-- tipo 

-- result_scan(123123sada)



-- 2) a function ""table()"" -> essa function CRIA 1 TABLE, A PARTIR DE 1 RESULT SET...





-- 3) a function ""last_query_id()""" --> ISSO NOS DÁ __ O EXATO ID _ DA ÚLTIMA QUERY 
-- QUE FOI RODADA... 

-- --> e é por isso que rodamos 


--         result_scan(last_query_id()),



--         DE FORMA NESTEADA, pq 


--         QUEREMOS _ PEGAR OS RESULTADOS (result set) DESSA QUERY, IDENTIFICADA 
--         POR MEIO DESSE ID...










--> OUTRA GAMBIARRA BOA:


-- MAIS TARDE, QUANDO TIVERMOS MAIS ERRORS,



-- SEMPRE PODEMOS ADICIONAR __ MAIS RECORDS __ NESSA TABLE DE 

-- ""REJECTED"",


-- basta rodar 

-- este statement:


-- se quisermos adicionar EVENTUAIS RECORDS DE ERRO ADICIONAIS NA TABLE DE REJECTED, TEMOS:



-- /ADDING ADDITIONAL EVENTUAL FAILED RECORDS TO REJECTED TABLE --

INSERT INTO rejected
SELECT rejected_record from table(result_scan(last_query_id())); -- pegamos os ""rows that errored out"" da última query que foi executada...

SELECT * FROM REJECTED;










-- temos outro caminho:


------ 2) SAVING REJECTED FILES/ENTRIES __WITHOUT _ VALIDATION MODE ------





COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage
    FILE_FORMAT = (
        type=csv, 
        field_delimiter= ',',
        skip_header=1
        )
    PATTERN='.*Order.*'
    ON_ERROR=CONTINUE;  -- para isso, para retrievar essas entries, precisamos da option de ""ON_ERROR=CONTINUE"""





--> o problema, quando usamos a option de 

-- ""continue"",

-- é que 

-- nao é possível visualizar 


-- os errors que recebemos, inicialmente..






--> queremos ver ESPECIFICAMENTE OS ERRORS....



-- PARA ISSO, TEMOS ESTA FUNCTION:





SELECT * FROM TABLE(validate(orders, job_id => '_last'));




-- validate ---> Validates
--  the files loaded in
--   a past execution of the COPY INTO command
--    and returns all the errors
--     encountered during the load, rather than just the first error









-- 1) O COMANDO DE COPY FOI EXECUTADO, MAS OCORRERAM ERRORS EM ALGUNS 

-- DOS INSERTS  --> MAS OS ERRORS NAO CONSEGUIAM SER VISUALIZADOS ESPECIFICAMENTE..

-- APENAS SABÍAMOS QUE ELES TINHAM OCORRIDO...





-- 2) por meio de 




-- SELECT * FROM TABLE(VALIDATE(COPY_DB.PUBLIC.ORDERS,JOB_ID => '_last')),








-- ficamos com info sobre os errors, 1 row para cada error...




-- o que ajuda mt a entender a causa do error...












-- -> O RETURN DE ERRORS DE 

-- """"
-- SELECT * FROM TABLE(VALIDATE(COPY_DB.PUBLIC.ORDERS,JOB_ID => '_last'));
-- """""







-- TAMBÉM NOS AJUDA COM O RETRIEVE DOS ROWS QUE DERAM ERROR,

-- POR MEIO DA COLUMN DE 


-- ""REJECTED RECORD""...





-- -------------------------------












-- OK... É ISSO QUE PODEMOS FAZER COM A OPTION DE 


-- ""ON_ERROR=CONTINUE",



-- COMBINADA 


-- COM AQUELE 

-- SELECT ESPECIAL,

-- DE 



-- """"
-- SELECT * FROM TABLE(VALIDATE(COPY_DB.PUBLIC.ORDERS,JOB_ID => '_last'));

-- """"


-- (select que usa essa function especial, de 

-- VALIDATE(), para retornar mais data sobre os errors de 1 query anterior)....




















-- POR FIM, 3: 







-- 3) WORKING WITH REJECTED RECORDS (manipulation)....




-- (rejected é a table com a column de ""rejected_record"", que possui toda 
-- a data do record, em 1 data type ESPECIAL, QUE __ NÃO É UMA STRING...)...






SELECT REJECTED_RECORD FROM rejected; //query simples 



CREATE OR REPLACE TABLE rejected_values AS
SELECT 
SPLIT_PART(rejected_record, ',', 1 ) as ORDER_ID,  // com isso, manipulamos cada 1 dos key-value pairs, dentro daquela single col.
SPLIT_PART(rejected_record, ',', 2 ) as AMOUNT,
SPLIT_PART(rejected_record, ',', 3 ) as PROFIT,
SPLIT_PART(rejected_record, ',', 4 ) as QUANTITY,
SPLIT_PART(rejected_record, ',', 5 ) as CATEGORY,
SPLIT_PART(rejected_record, ',', 6 ) as SUBCATEGORY
FROM rejected;





-- --> NESSE NOSSO CASO CONCRETO,


-- QUEREMOS __ 


-- TRANSFORMAR AQUELA COLUMN 

-- DE 
-- """"REJECTED_RECORD""""




-- EM MÚLTIPLAS COLUMNS,

-- SEPARADAS...  --> fazemos isso com ""SPLIT_PART()""....






-- ESSA FUNCTION, 



-- ""SPLIT_PART()""" --> ESSA FUNCTION EXIGE 


-- 1 
-- ""SPLIT DELIMIITER"""-->  E COLOCAMOS O DELIMITER 





-- COMO SENDO A 

-- __VÍRGULA,

-- para separar cada 1 dos items 



-- naquelas strings 

-- de 





-- ""B-12321,1,12321,10,7-,FURNITURE,BOOKCASES""

