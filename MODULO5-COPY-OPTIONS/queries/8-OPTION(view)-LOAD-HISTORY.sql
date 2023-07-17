


-- AGORA TEMOS A OPTION DE ""LOAD HISTORY""...


-- PQ ÀS VEZES TEREMOS INTERESSE 


-- NA __ HISTORY__ DE NOSSA DATA...



-- --> A HISTORY DA DATA QUE FOI CARREGADA 

-- NAS NOSSAS TABLES POR MEIO DO COMANDO ""COPY INTO"""...










-- PARA CONSEGUIR ISSO, 



-- FELIZMENTE HÁ UMA 






-- """"""VIEW"""""" (nao é bem uma option,

-- e sim uma 

-- ___vIEW___....)













-- --> HÁ UMA VIEW ÚTIL,
-- QUE PODEMOS 

-- FACILMENTE QUERIAR,

-- PARA CONSEGUIR ESSA INFO..







-- É ISSO QUE VEREMOS, NESSA LICAO...













-- --> EM CADA DATABASE QUE TEMOS NA GUI,





-- PODEMOS OBSERVAR QUE EXISTE 1 SCHEMA 

-- CHAMADO 

-- DE 

-- """"INFORMATION_SCHEMA"""""...














-- --> SE EXPANDIRMOS ESSE SCHEMA,




-- FICAMOS COM __ MTAS VIEWS_...














-- VIEWS DE TODAS COISAS IMAGINÁVEIS:







-- 1) APPLICABLE_ROLES 




-- 2) COLUMNS 



-- 3) DATABASES 




-- 4) ENABLED_ROLES 




-- 5) EVENT_TABLES 




-- 6) FILE_FORMATS 



-- 7) FUNCTIONS 



-- 8) INFORMATION_SCHEMA_CATALOG_NAME 



-- 9) LOAD_HISTORY 


-- 10) OBJECT_PRIVILEGES 


-- 11) PACKAGES 



-- 12) PIPES 



-- 13) PROCEDURES 




-- 14) REFERENTIAL_CONSTRAINTS 



-- 15) REPLICATION_DATABASES 


-- 16) REPLICATION_GROUPS 



-- 17) SCHEMATA 



-- 18) SEQUENCES 


-- 19) STAGES 



-- 20) STREAMLITS 




-- 21) TABLES 




-- 22) TABLE_CONSTRAINTS 



-- 23) TABLE_PRIVILEGES 



-- 24) TABLE_STORAGE_METRICS 



-- 25) USAGE_PRIVILEGES 



-- 26) VIEWS...
















-- --> CADA DATABASE TEM 1 DESSES SCHEMAS DE INFORMATION...






-- UM MONTE DE VIEWS...









-- -> DEVEMOS ABRIR A VIEW DE ""LOAD_HISTORY""....










-- este é um exemplo de ""load_history"" view, de uma database qualquer.
COPY_DB.INFORMATION_SCHEMA.LOAD_HISTORY;








USE COPY_DB;

-- PODEMOS FAZER QUERY DESSA VIEW, COM ESTE COMANDO:

SELECT * FROM COPY_DB.INFORMATION_SCHEMA.LOAD_HISTORY;







-- COM ISSO, É POSSÍVEL VER A LOAD HISTORY 


-- DESSA TABLE (

--     OU SEJA,

--     CTODOS OS ARQUIVOS CSV/JSON QUE FORAM CARREGADOS PARA DENTRO DESSA TABLE...
-- )











--> TALVEZ QUEIRAMOS VER A __ GLOBAL_ _ TABLE HISTORY....









--> QUEREMOS VER A GLOBAL TABLE HISTORY __ JUSTAMENTE PQ 


-- 1 TABLE FOI RECRIADA,



-- E ESSA TABLE FOI RECRIADA COM O MESMO NOME...  (
--     aí fica difícil de identificar a 

--     history ANTES e DEPOIS do recreate...
-- )














-- PARA OBTERMOS ACESSO A ESSA INFO,




-- __dEVEMOS __ DAR UMA OLHADA _ 



-- NA DATABASE ""SNOWFLAKE"",




-- QUE É BASICAMENTE A 


-- """"COMMON DATABASE"""" do snowflake...








--> NESSA DATABASE (SNOWFLAKE), 
-- PODEMOS VER 

-- INFO SOBRE __ TODAS AS COPIES _ 

-- QUE __ ACONTECERAM NO NOSSO APP...











-- ESSA É A GLOBAL DATABASE DO NOSSO APP...











-- NELA,



-- TEMOS 



-- 1 SCHEMA CHAMADO DE ""ACCOUNT_USAGE""....













-- -> SE EXPANDIRMOS O ""ACCOUNT_USAGE"",



-- e visualizarmos as views,


-- PODEMOS SEGUIR ATÉ ""LOAD_HISTORY""...









-- ok............ 






-- COM ISSO, REALMENTE É POSSÍVEL CONSEGUIR ESSA DATA....















-- COM ISSO, É POSSÍVEL VISUALIZAR 




-- A EXATA HISTORY DE NOSSOS COMANDOS DE COPY...












-- -> nessa global table,





-- visualizamos a global data....













--> dentro dali, 


-- encontramos 1 column 

-- chamada de ""table_id"" ---> ESSA COLUMN 

-- GERALMENTE 

-- NAO É VISÍVEL,




-- E PODEMOS VER __ QUE __ AINDA QUE TENHAMOS 

-- ESSA TABLE MÚLTIPLAS VEZES (criado e recriado várias vezes),





-- O ACTUAL TABLE_ID SERÁ DIFERENTE.. --> OU SEJA,



-- 1 TABLE NUNCA TERÁ 1 MESMO ID,




-- PODEMOS RECRIAR COM O MESMO NOME, 


-- MAS O ID _SEMPRE VAI DENUNCIAR 




-- QUE _A TABLE FOI RECRIADA....


-- (
--     ESSA COLUMN DE ""TABLE_ID""

--     NUNCA TERÁ VALUES DUPLICADOS... PODE TER VALUES DUPLICADOS 

--     NA COLUMN DE ""TABLE_NAME"",


--     MAS NUNCA EM ""TABLE_ID""...
-- )









-- O COMANDO PARA VER A INFO DESSA TABLE GLOBAL É:








-- PODEMOS CARREGAR A DATA DE TODOS OS COPIES OCORRIDOS NO NOSSO APP, POR MEIO DESTE COMANDO:
-- ou seja, visualizamos a data dentro da database SNOWFLAKE (database global), no schema ACCOUNT_USAGE, na view de ""load_history""
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY;



-- FILTER ON SPECIFIC TABLE E SCHEMA:  (com o WHERE statement)
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY
    WHERE schema_name='PUBLIC' AND 
    table_name='ORDERS';

    


--> COM ISSO, CONSEGUI VER QUE 
-- ESSA TABLE DE ORDERS 
-- FOI RECRIADA 
-- 4 VEZES.... (pq o table_id mudou)...





SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY
    WHERE schema_name='PUBLIC' AND 
    table_name='ORDERS' AND 
    error_count > 0; -- visualizar apenas os eventos de copy em que tivemos ERRORS...





--> NÓS TAMBÉM PODEMOS __ IR ALÉM..... --> ESPECIFICAR 

-- MAIS COISAS AINDA...











--. ESPECIFICAR __ OS EVENTS DE LOAD _ QUE OCORRERAM EM 1 
-- __dATE __ESPECIFICA...




-- ex:


SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY
    WHERE DATE(LAST_LOAD_TIME) <= DATEADD(days, -1, CURRENT_DATE);

-- COM ISSO, DIZEMOS QUE ""QUEREMOS TODA A LOAD_HISTORY 
--         DE 1 DIA PARA CÁ""...






-- OK.... É ASSIM QUE PODEMOS USAR ESSA GLOBAL VIEW...





-- OK... QUER DIZER QUE ESSA PODE SER UMA VIEW BEM ÚTIL

-- SE QUISERMOS 

-- VER A LOAD HISTORY 

-- GLOBALMENTE, OU EM 1 DATABASE ESPECÍFICA, EM 1 TABLE ESPECÍFICA...