-- há 2 maneiras de fazer time travel e restaurar dados àquilo que eram anteriormente... 1 maneira boa, e outra ruim.


-- primeiro, temos o setup:



-- Setting up table 


CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
    ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    GENDER STRING,
    JOB STRING,
    PHONE STRING
);

LIST @OUR_FIRST_DB.stages.time_travel_stage;


COPY INTO OUR_FIRST_DB.PUBLIC.TEST 
FROM @OUR_FIRST_DB.stages.time_travel_stage;



SELECT * FROM OUR_FIRST_DB.public.test;



--use-case: update data (by mistake - fuck-up)

UPDATE OUR_FIRST_DB.public.test 
SET LAST_NAME = 'Tyson';


UPDATE OUR_FIRST_DB.public.test 
SET JOB = 'Data Analyst';



-- one mistake after another...





-- one mistake after another...

-- podemos usar a time-travel feature, para voltar no tempo.

-- pegamos o query id... pq sabemos qual statement foi...







------------------------





--> 








-- ESCREVEMOS A QUERY ASSIM:



SELECT * FROM OUR_FIRST_DB.public.test BEFORE (
statement => '01adc216-0604-ad1c-0077-a6870003820a'
);






--------------------------------------------------










-- O IDEAL SERIA FAZER TIME TRAVEL 2 STEPS PARA TRÁS... 
-- pq tivemos 2 mistakes- -> o ideal é usar a PRIMEIRA STEP...



-- MAS PARA NOSSO EXEMPLO, VAMOS DESFAZER APENAS A PRIMEIRA STEP,
-- A PRIMEIRA MISTAKE...





-- TIME-TRAVEL ONE STEP (ONE MISTAKE REMAINS, BASICALLY):


SELECT * FROM OUR_FIRST_DB.public.test BEFORE (
statement => '01adc216-0604-ad1c-0077-a6870003820a'
);

-- COM ISSO, CONSEGUIMOS CONSERTAR O "JOB", MAS O NAME CONTINUA
-- COMO "TYSON"




















-- AGORA VEREMOS PQ 


-- É UMA MÁ IDEIA FAZERMOS TIME-TRAVEL ASSIM...










-- -> PARA RESTAURAR NOSSA TABLE,




-- RODAMOS O COMANDO CLÁSSICO,


-- DE










CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test AS 
SELECT * FROM OUR_FIRST_DB.public.test BEFORE (
    statement => '01adc216-0604-ad1c-0077-a6870003820a'
);





-- CERTO...












--> RODAMOS ESSE COMANDO, E ELE FUNCIONA..







--> CONSERTAMOS "METADE" DO PROBLEMA,

PQ 

A OUTRA MISTAKE VAI CONTINUAR..











--> e aqui é que o GRANDE PROBLEMA VAI SURGIR...









-- PODEMOS PENSAR ""AH, MAS NÓS TEMOS TIME-TRAVEL,
-- BASTA FAZERMOS 

-- TIME-TRAVEL PARA 1 STEP ALÉM"...









-- -> MAS SE ABRIRMOS 
-- A NOSSA QUERY HISTORY,


-- VEREMOS QUE TUDO FICARÁ ESTRAGADO...







--> se tentarmos voltar àquela etapa anterior,

-- receberemos 




-- "Time travel data is not available 
-- for table TEST. The requested time is either
-- BEYOND THE ALLOWED TIME TRAVEL PERIOD OR
-- BEFORE THE OBJECT CREATION TIME"...









E É AQUI QUE SURGE O PROBLEMA...








O PROBLEMA SURGE -_ JUSTAMENTE_ PQ 


NÓS __ RECRIAMOS A TABLE, INFELIZMENTE...








NÓS __ RECRIAMOS ESSA TABLE.... ISSO QUER DIZER QUE 







_____ PERDEMOS__ TODA A METADATA__ DA 

TABLE ANTERIOR... --> ISSO PQ 


__DROPPAMOS A TABLE ANTERIOR QUANDO 

RODAMOS 

"CREATE OR REPLACE"...

















--> PQ O TIME TRAVEL FUNCIONA ASSIM:


-- 1) HÁ UM HIDDEN TABLE ID PARA 
-- CADA TABLE...



-- 2) NESSE TABLE ID,

-- TAMBÉM TODA A METADATA ESTÁ ARMAZENADA...


-- 3) QUER DIZER QUE 

-- SE __DROPPARMOS OU RECRIARMOS A TABLE,


-- __ NOSSO TIME-TRAVEL NAO VAI MAIS FUNCIONAR 

-- PARA AQUELA QUERY DO PASSADO...




-- 4) ISSO ACONTECE PQ __ ESSA TABLE VAI ESTAR DISPONÍVEL
-- COMO 1 TABLE TOTALMENTE SEPARADA,
-- COM 1 TABLE ID TOTALMENTE DIFERENTE...










-- E É JUSTAMENTE POR CONTA DISSO,


-- QUE 

-- "CREATE OR REPLACE <TABLE_NAME> 
-- AS XXX"


-- É UM METHOD RUIM PARA 

-- VOLTAR NO TEMPO E RESTAURAR DADOS, anteriores 
-- a queries/timestamps/intervals







-- O METHOD ___ BOM, ADEQUADO, PERFEITO...





-- -> NESSE METHOD/APPROACH, TEMOS VÁRIAS ETAPAS:





1) CRIAMOS UMA BACKUP TABLE



2) COPIAMOS A DATA "VIAJADA NO TEMPO", DA TABLE ORIGINAL,
PARA DENTRO DESSA BACKUP TABLE.


3) NA TABLE ORIGINAL, QUE SE ENCONTRA ERRADA 
(COM FIELDS COM VALOR INCORRETO), MAS QUE 
AINDA 

TEM A ""TIMELINE CORRETA"", __RODAMOS _ TRUNCATE,

PARA ESVAZIAR TOTALMENTE SEU CONTEÚDO...


4) POR FIM, INSERIMOS TODA A DATA 

DA "BACKUP TABLE", QUE CRIAMOS ANTERIORMENTE,

COM AQUELA DATA "DO PASSADO", PARA _DENTRO _ 



DA NOSSA TABLE ORIGINAL, QUE AGORA ESTÁ VAZIA...











-- good method - uso de uma backup table, e o truncate da original table.





-- create backup table and fill it with time-travelled data from --- original table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup AS 
SELECT * FROM OUR_FIRST_DB.public.test BEFORE (statement => '01adc234-0604-ad1c-0077-a6870003826e');


-- truncate original table
TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.test;


-- insert data from BACKUP TABLE (restored data) INTO ORIGINAL TABLE (now empty)
INSERT INTO OUR_FIRST_DB.PUBLIC.test
SELECT * FROM OUR_FIRST_DB.public.test_backup;


-- data is now restored to what it was, in original table,
-- and its timeline is still maintained.
SELECT * FROM OUR_FIRST_DB.public.test;



-- we can now delete the backup table, if we wish.