







-- OK.... AGORA DEVEMOS DAR 1 OLHADA 

-- EM OUTRA FEATURE,


-- FEATURE MT SIMILAR


-- AO CLONING, MAS QUE NAO É A MESMA COISA....



















-- OK.... AGORA DEVEMOS DAR 1 OLHADA 

-- EM OUTRA FEATURE,


-- FEATURE MT SIMILAR


-- AO CLONING, MAS QUE NAO É A MESMA COISA....












-- ---> é A FEATURE DE 

-- ""SWAPPING TABLES""...














-- ---->  OK... ISSO PODE SER ESPECIALMENTE 

-- ÚTIL SE 


-- TIVERMOS 1 USE-CASE 

-- DE 





-- """QUEREMOS __ PEGAR 1 DEVELOPMENT 
-- DATABASE/TABLE  E ENTAO 

-- A COLOCAR __ EM PRODUCTION""""....















-- --> É CLARO QUE EXISTEM MÚLTIPLAS 

-- MANEIRAS DE FAZER ISSO, NA PRÁTICA...








-- ALGUMAS MANEIRAS:




-- 1) CRIAR 1 CLONE/CÓPIA

-- DA DEVELOPMENT TABLE... AÍ, POR EXEMPLO,

-- PODERÍAMOS A RENOMEAR 

-- COMO SENDO A PRODUCTION TABLE...
















-- --> ENTRETANTO, NO SNOWFLAKE HÁ UMA SEGUNDA 

-- OPCAO,

-- QUE TE DEIXA FAZER 

-- ISSO DE UMA MANEIRA ___ BEM MAIS SIMPLES...










-- --> O NOME DISSO É ""SWAPPING THE TABLES"""....












--> DIGAMOS QUE TEMOS 2 TABLES...







-- DEV TABLE 



-- PROD TABLE...











--> ESSE PROCESSO É SIMILAR AO CLONING,




-- PQ, NO FINAL DAS CONTAS,

-- O QUE ESTAMOS 


-- FAZENDO É 

-- O SIMPLES __ SWAP __ DA METADATA 


-- ENTRE 

-- AS TABLES..



----------------------








-- PARA COMPREENDER ESSA FEATURE,


-- DEVEMOS ENTENDER



-- """COMO AS TABLES SAO BUILT""""...













-- -> BEM, ELAS SAO ASSIM:









-- DEV TABLE                PROD TABLE 
--     ^                           ^
--     I                           I
-- (META DATA A)                 (META DATA B)
--     I                           I
--     I                           I

-- FILES/DATA                   FILES/DATA















-- JÁ SABEMOS QUE ESSA DEV TABLE 

-- POSSUI UMA META DATA... --> DEBAIXO DESSA 

-- METADATA,

-- HÁ A STORAGE EM QUE 



-- O CLOUD PROVIDER TEM A DATA ARMAZENADA...




-- -----------------------------








-- AGORA, SE SWAPPARMOS ESSAS 2 TABLES,


-- A ÚNICA COISA QUE ACONTECERÁ 


-- É 

-- O 


-- __SWAP _ DA _ METADATA...





-- EX:










-- DEV TABLE                PROD TABLE 
--     ^                           ^
--     I                           I
-- (META DATA B)                 (META DATA A)
--     I                           I
--     I                           I

-- FILES/DATA                   FILES/DATA












-- -> QUER DIZER QUE ESSA STORAGE, DA DEV TABLE,


-- APENAS VAI ESTAR APONTANDO PARA A STORAGE 

-- DA PRODUCITON VERSION... (e a storage 

-- da production table vai estar apontando 
-- para a DEV table)














-- RECAPITULANDO...











-- SWAPPAR AS TABLES...










-- COM O CLONE, NÓS __cOPIAMOS__ A METADATA...









-- MAS COM O SWAP,


-- NÓS __ SWAPPAMOS ___ METADATA...









-- BASICAMENTE SÓ SWAPPAMOS A METADATA...












-- QUER DIZER QUE A STORAGE/FILES



-- DE DEV __ FICARÁ APONTADA 



-- PARA A METADATA 


-- __ DA TABLE DE __ PRODUCTION.... (E  vice-versa)...














-- ESSAS TABLES SAO SWAPPADAS,

-- DE 1 MANEIRA BEM SIMPLES.........















-- --> E TUDO COM 1 COMANDO EXTREMAMENTE SIMPLES,








-- ESSA FEATURE PODE SER SUPER 


-- ÚTIL,

-- ESPECIALMENTE 




-- QUANDO VC QUER 




-- TRAZER 1 TABLE DE DEVELOPMENT PARA 


-- __ PRODUCTION...













-- -- PARA CONSEGUIR FAZER ESSE SWAP,

-- TEMOS ESTE COMANDO:










-- ALTER TABLE <table_name>
-- SWAP WITH <target_table_name>;











-- ----> COM ISSO,


-- ALTERAMOS A METADATA DESSA TABLE..









-- COM ISSO, 



-- ESSAS 2 TABLES SERAO __ SWAPPED... BEM FÁCIL...











-- --> PODEMOS FAZER A MESMA COISA COM SCHEMAS,


-- SWAPPAR 1 SCHEMA COM OUTRO SCHEMA..









-- BASTA ESCREVER 











-- ALTER SCHEMA <schema_name>
-- SWAP WITH <target_schema_name>


-- --------------------







-- DEVEMOS DAR 1 OLHADA NISSO, NAS NOSSAS 


-- WORKSHEETS...


















-- SWAPPING TABLES 


-- SETTING UP DEV TABLE 

SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS;
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;


DELETE FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS WHERE ID < 500;


SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS;


-- eis o código em questao
ALTER TABLE OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS
SWAP WITH OUR_FIRST_DB.PUBLIC.CUSTOMERS;






-- Verifying results 
SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS;
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;



-- Verifying results (data/rows were swapped)
SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS;
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;
