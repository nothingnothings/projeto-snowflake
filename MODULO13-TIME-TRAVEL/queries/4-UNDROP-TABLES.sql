
-- O UNDROP DE TABLES É A OUTRA GRANDE FEATURE 
-- DE TIME TRAVEL DO SNOWFLAKE.

-- setting up table 


CREATE OR REPLACE STAGE MANAGE_DB.stages.time_travel_stage
    url='s3://data-snowflake-fundamentals/time-travel'
    file_format=(
        FORMAT_NAME=MANAGE_DB.file_formats.csv_file_format
    );



CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);

COPY INTO OUR_FIRST_DB.public.customers
FROM @OUR_FIRST_DB.stages.time_travel_stage;





SELECT * FROM OUR_FIRST_DB.public.customers;



-- bad scenario, you mistakenly drop your table:


-- UNDROP command - tables 

DROP TABLE OUR_FIRST_DB.public.customers;


SELECT * FROM OUR_FIRST_DB.public.customers;









-- OK... MAS NO SNOWFLAKE,

-- PODEMOS CONSERTAR 
-- ESSE DROP FACILMENTE,


-- COM 1 SIMPLES STATEMENT...








-- --> BASTA RODAR 


-- """""

UNDROP TABLE OUR_FIRST_DB.public.customers;

-- """""










--> É TAO SIMPLES ASSIM...





-- AGORA PODEMOS SELECIONAR NOSSA TABLE MAIS UMA VEZ,

-- E VISUALIZAR TODA A DATA...










-- E a COISA MAIS ABSURDA É QUE SOMOS CAPAZES 

-- DE FAZER UNDROP NAO SÓ DE 

-- TABLES,


-- MAS DE SCHEMAS TAMBÉM...


-- UNDROP COMMAND - SCHEMAS 




DROP SCHEMA OUR_FIRST_DB.public;


SELECT * FROM OUR_FIRST_DB.public.customers; -- will be missing, because we dropped its parent schema.

UNDROP SCHEMA OUR_FIRST_DB.public; -- will restore schema.





DROP DATABASE OUR_FIRST_DB;

SELECT * FROM OUR_FIRST_DB.public.customers; -- will be missing, because we dropped its parent database

UNDROP DATABASE OUR_FIRST_DB;






--> POR FIM, AGORA O PROFESSOR QUER 

-- MOSTRAR 


-- COMO PODEMOS __ 


-- RESTAURAR__ UMA TABLE 

-- QUE 


-- FOI ""REPLACED"",

-- ""REPLACED"" POR OUTRA 

-- TABLE...




-- -> PQ, SE LEMBRARMOS BEM,




-- RODAMOS O COMANDO DE "CREATE OR REPLACE" UM MONTE DE VEZES:






CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers 
AS SELECT * FROM OUR_FIRST_DB.public.customers BEFORE (
    statement => 'xxxx'
);





-- esse comando, o create or replace, às vezes pode nos incomodar,
-- pq ele impossibilita o uso das time travel features 
-- do snowflake, pq ele FAZ OVERWRITE DA TABLE ANTERIOR...
-- aí nao conseguimos fazer travel por meio de 1 id ou tempo anterior...







--- how to restore a REPLACED (create or replace) TABLE, with UNDROP


UPDATE OUR_FIRST_DB.public.customers
SET LAST_NAME = 'Tyson';



UPDATE OUR_FIRST_DB.public.customers
SET JOB = 'Data Analyst';







--UNDROPING A TABLE WHICH USES A NAME THAT ___ ALREADY EXISTS___ (in other words, this dropped table was probably REPLACED)


CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers
-- nós escolhemos a última etapa, que é a errada, de propósito. (consertamos apenas metade dos updates errados)
AS SELECT * FROM OUR_FIRST_DB.public.customers BEFORE (
    statement => '01adc265-0604-ad11-0077-a687000373b2' //before set job statement, but not before last_name update statemnt.
);






-- OU SEJA,
-- DIGAMOS QUE USAMOS O APPROACH BAD 


-- DE 

-- RESTAURAR TABLES,

-- EM QUE 


-- SUBSTITUÍMOS NOSSA TABLE 

-- ORIGINAL 



-- POR UMA TABLE NOVA, COM MESMO NOME.... (visto logo acima).






-- -> COMO APRENDEMOS ANTERIORMENTE,

-- SE SUBSTITUÍMOS/RECRIAMOS 1 TABLE COM 

-- 1 MESMO NOME,

-- AS FEATURES DE TIME-TRAVEL 

-- COM "AT" E "BEFORE" 
-- DEIXAM DE FUNCIONAR....













AINDA ASSIM,
NEM TUDO ESTÁ PERDIDO...







--> ISSO PQ _ PODEMOS USAR __ 




-- A FUNCTION DE "uNDROP" 

-- PARA 


-- UNDROP ESSA CUSTOMERS TABLE ANTERIOR,



-- A TABLE QUE ACABAMOS DROPPANDO 



-- COM O COMANDO DE 



-- ""



CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers
-- nós escolhemos a última etapa, que é a errada, de propósito. (consertamos apenas metade dos updates errados)
AS SELECT * FROM OUR_FIRST_DB.public.customers BEFORE (
    statement => '01adc265-0604-ad11-0077-a687000373b2' //before set job statement, but not before last_name update statemnt.
);



-- ""



-- rodado anteriormente...








-- mas isto nao funcionará (precisamos de uma sintaxe mais complexa, para restaurarmos aquela table de nome "customers" que foi droppada com aquele create or replace)

UNDROP TABLE OUR_FIRST_DB.public.customers;




-- -> certo, mas se rodarmos 


-- apenas 


-- "UNDROP TABLE OUR_FIRST_DB.public.customers;",



-- ISSO NAO FUNCIONARÁ,
 
--  PQ 

--  ESSA TABLE JÁ EXISTE,

--  A TABLE DE CUSTOMERS...











a solucao é fazer O


 RENAME__ DESSA TABLE ATUAL....







 --> REALMENTE, A SOLUCAO É FAZER:



 1) O RENAME DA TABLE 

 ___aTUAL___ de 
 "customers" para algo como "customers_wrong" (ou qualquer outra coisa)



 2) DEPOIS DISSO,
 DEVEMOS RODAR 


 "UNDO OUR_FIRST_DB.public.customers", que 

 agora REALMENTE VAI CONSEGUIR TARGETTAR 

 AQUELA __ TABLE QUE HAVIA SIDO DROPPED...




 quer dizer que o código fica assim:



 


-- rename the present (And wrong) table
 ALTER TABLE OUR_FIRST_DB.public.customers
 RENAME TO OUR_FIRST_DB.public.customers_wrong;

 -- undrop table that had been replaced with the wrong table.
UNDROP TABLE OUR_FIRST_DB.public.customers;






-- COM ESSE CÓDIGO, CONSEGUIMOS RESTAURAR 

-- AS FEATURES DE 
-- TIME TRAVEL QUE 

-- TÍNHAMOS PERDIDO,
-- COM O REPLACE/RECREATE 
-- DESSA TABLE... --------_> BASTA RENOMEAR 
-- ESSA TABLE,

-- E ENTAO 


-- __ RESTAURAR A TABLE ORIGINAL/ANTERIOR,


-- COM "UNDROP TABLE <table_name>"...