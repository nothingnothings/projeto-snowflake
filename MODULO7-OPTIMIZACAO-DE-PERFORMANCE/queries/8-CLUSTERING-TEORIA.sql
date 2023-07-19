











-- AGORA VEREMOS OUTRA IMPORTANTE TECNICA USADA PELO SNOWFLAKE,



-- QUE ELE USA PARA __ MELHORAR A PERFORMANCE...








-- --> AO CONTRÁRIO DE CACHING,



-- PODEMOS TER 1 POUCO DE CONTROLE SOBRE O ""CLUSTERING"" NO SNOWFLAKE....











-- -> BEM, O QUE PODEMOS FAZER...




-- --> O NOME DA TECNICA É ""CLUSTERING""...










-- -> DEVEMOS PRIMEIRAMENTE ENTENDER O QUE É O CLUSTERING...








-- -------------------------------




--                 CLUSTERING:






-- --> O SNOWFLAKE CRIA CLUSTER KEYS, EM CERTAS COLUMNS,
-- PARA CRIAR 

-- ""SUBSETS OF ROWS"", PARA LOCALIZAR ESSES SUBSETS 
-- EM ""MICRO-PARTITIONS""...



-- ---> SUBSET OF ROWS _ TO LOCATE _ THE DATA IN MICRO-PARTITIONS...











-- --> A VANTAGEM DISSO É QUE, COM A CRIACAO DESSAS MICRO-PARTITIONS,

-- EVITAMOS ""fULL TABLE SCANS"", ou, em geral,

-- melhora a eficiencia dos table scans... ESPECIALMENTE 

-- SE __ ESTAMOS LIDANDO COM TABLES MT LARGAS...





-- --> FOR LARGE TABLES, THIS IMPROVES THE SCAN EFFICIENCY IN OUR 
-- QUERIES...








-- --> os benefícios sao realmente em tables gigantes...




-- MAS O QUE É UMA CLUSTER KEY?







-- --> O SNOWFLAKE CRIA CLUSTER KEYS EM 


-- __CERTAS  __ COLUMNS__.... PARA _ CRIAR __ SUBSETS 
-- OF ROWS,



-- PARA _ 

-- ENTAO __ LOCALIZAR_ ESSES ROWS 



-- EM AQUILO QUE CHAMAMOS DE ""MICRO-PARTITIONS""....










-- --> NO SNOWFLAKE, ESSAS CLUSTER KEYS SAO MANTIDAS __ AUTOMATICAMENTE


-- PELO SNOWFLAKE,


-- O QUE É MT BOM ----> PQ GERALMENTE TERÍAMOS DATABASE ADMINISTRATORS 

-- PARA ESSA TAREFA,

-- E ELES TERIAM 

-- 1
--   MONTE DE TRABALHO PARA __ CRIAR _ PRIMARY KEYS E TODO O RESTO.... --> COM ISSO,


--   COM O CLUSTERING DO SNOWFLAKE,



--   PODEMOS SKIPPAR __ TODA ESSA ETAPA,


--   PQ 



--   O SNOWFLAKE VAI MANAGEAR TUDO ISSO __ AUTOMATICAMENTE...















-- -> MANAGE AUTOMATICO --> É MT BOM,


-- E GERALMENTE PRODUZ __ TABLES _ 

-- MT BEM CLUSTERIZADAS (
--     well-clustered tables...
-- )












-- ---> OK... ISSO É MT BOM --> ENTRETANTO, HÁ 

-- PROBLEMAS.... --> NEM SEMPRE ESSAS CLUSTER KEYS 


-- SAO IDEAIS, E _ ELAS TAMBÉM PODEM MUDAR __ 

-- AO LONGO DO TEMPO....







-- --> OK.... QUER DIZER QUE APESAR DE ESSE CLUSTERING 
-- ACONTECER 

-- AUTOMATICAMENTE,

--  E GERALMENTE ELE SER BEM FEITO,



-- É BOM ENTENDER ESSE CLUSTERING EM SI,







-- E SABER __ O QUE _ PODEMOS/DEVEMOS 


-- FAZER __ PARA _ MELHORAR AS COISAS DO CLUSTERING,






-- SE _ ISSO FOR NECESSÁRIO...








-- ---> """MANUALLY CUSTOMIZE 
-- THESE CLUSTER KEYS""...












-- --> É ISSO QUE VEREMOS, NESSA LESSON...













-- --> PRIMEIRAMENTE, TEMOS 1 EXEMPLO DE 1 CLUSTERED TABLE:









-- EVENT_DATE   EVENT_ID   CUSTOMERS   CITY 
-- 2021-03-12      1         ...       NY
-- 2021-06-12      2         ...       SP











-- EX:










-- EVENT_DATE   EVENT_ID   CUSTOMERS   CITY 
-- --------------------------------------
-- 2021-03-12      1         ...       NY
-- 2021-06-12      2         ...       SP
-- 2021-08-05      3         ...       LA
-- 2021-09-21      4         ...       SF
-- 2022-01-10      5         ...       CH
-- 2022-04-15      6         ...       LD
-- 2022-07-02      7         ...       TK
-- 2022-09-09      8         ...       MI
-- 2022-12-01      9         ...       BJ
-- 2023-02-18      10        ...       SY














-- ---------> OK... É UMA EVENT TABLE BEM SIMPLES...










-- --> UM PARTICIONAMENTO CRIADO AUTOMATICAMENTE PODERIA 

-- FICAR COM ESTA APARENCIA:










-- EVENT_DATE   EVENT_ID   CUSTOMERS   CITY 
-- --------------------------------------
-- 2021-03-12     134584       ...       NY      A
-- 2021-12-04     134586       ...       SP      A
-- 2021-11-04     134588       ...       LA      A
-- 2021-04-05     134589       ...       SF      A
-- 2022-06-07     134594       ...       CH      B
-- 2022-07-03     134597       ...       LD      B
-- 2022-03-04     134598       ...       TK      C
-- 2022-08-03     134599       ...       MI      C
-- 2022-08-04     134601       ...       BJ      C
















-- --> ou seja,


-- FICARIAMOS COM 3 PARTITIONS... ---> 








-- ISSO JÁ NOS DEMONSTRA QUE, PARA 1 PARTITION,



-- NAO PRECISAMOS 




-- TER IDS IGUAIS (1 mesmo value)...










-- -> PODEMOS TER 1 RANGE DE VALUES, EM VEZ DISSO..



-- (
--     ou seja,

--     podemos 

--     ter todas as rows 

--     de 

--     id 

--     134584 ATÉ 134589.... ----> ESSE SERIA O CLUSTER A...

-- )













-- -------> ISSO FUNCIONA, SIM...














-- --> MAS IMAGINE QUE, INFELIZMENTE,

-- FICAMOS COM 



-- __MTAS__ QUERIES__ QUE 





-- ACABAM USANDO ESSA COLUMN DE ""EVENT_DATE""





-- COMO 1 FILTER DE WHERE,

-- TIPO ASSIM:











-- SELECT COUNT(*) 
-- WHERE "event_date" > '2021-07-01'
-- AND "event_date" < '2021-08-01';









-- --> NESSE CASO,




-- CASO DE QUERY POR __ EVENT_DATE,







-- NÓS AINDA FICARÍAMOS COM SCANS DA TABLE COMPLETA... -->  ISSO PQ 




-- O __ EVENT_ID NAO NOS 

-- DÁ NENHUMA 


-- INFORMACAO SOBRE 




-- O __ EVENT_DATE... ---> E COMO PODEMOS 




-- TER 





-- DADOS/ROWS 

-- QUE SE ENCAIXAM EM ""EVENT_DATE > X; EVENT_DATE < Y""




-- EM TODAS ESSAS PARTITIONS,

-- PRECISAMOS 


-- REALMENTE FAZER 


-- 1 FULL TABLE SCAN, PARA NOS CERTIFICARMOS DISSO...







-- -----------------------------









-- OK, MAS QUAL SERIA UMA SOLUCAO MELHOR, AQUI?











-- --> UMA PARTITION MELHOR,



-- PARA QUE NAO TENHAMOS QUE SCANNEAR A TABLE COMPLETA,


-- SERIA _ PARTICIONAR__ 




-- A PARTIR _ DAQUELE ___ EVENT_DATE, E NAO 


-- PARTICIONAR A PARTIR DO __ ""EVENT_ID""...







-- EVENT_DATE   EVENT_ID   CUSTOMERS   CITY 
-- --------------------------------------
-- 2021-03-04     134598       ...       TK      A
-- 2021-03-12     134584       ...       NY      A
-- 2021-04-05     134589       ...       SF      A
-- 2021-06-07     134594       ...       CH      A
-- 2021-07-03     134597       ...       LD      B
-- 2021-08-03     134599       ...       MI      B
-- 2021-08-04     134601       ...       BJ      C
-- 2021-11-04     134588       ...       LA      C
-- 2021-12-04     134586       ...       SP      C










-- --- ou seja,


-- poderíamos ficar 





-- com _ PARTITIONS_ EXATAMENTE COMO ANTES,

-- MAS AGORA 

-- DIVIDIDAS POR _ RANGES __ 


-- DE _ DATES, E NAO DE EVENT_IDs...















-- --> POR EXEMPLO, SE PROCURARMOS POR DATES EM AGOSTO,



-- O ___ SNOWFLAKE AUTOMATICAMENTE ENTENDERÁ QUE 


-- APENAS A PARTITION 

-- ""B"" (e aquelas poucas rows)


-- DEVERÁ SER SCANNEADA..
















-- --> QUER DIZER QUE CLUSTERING PODE AUMENTAR 


-- A _ PERFORMANCE __ UM MONTE...












-- --> COMO O CLUSTERING É AUTOMATIZADO 


-- PELO SNOWFLAKE,


-- __ A PERGUNTA É::











-- """"QUANDO DEVEMOS __ CLUSTERIZAR NOSSAS TABLES/
-- CRIAR CUSTOM _ CLUSTER KEYS _ PARA NOSSAS TABLES....
-- """""















-- BEM, AQUI TEMOS A PRIMEIRA OBSERVACAO:





-- 1) CLUSTERING/CREATE DE CUSTOM CLUSTER KEYS ___ NAO DEVE 
-- SER FEITO 

-- COM TODAS AS TABLES, COM QUALQUER TABLE...






-- 2) DEVEMOS REALIZAR CLUSTERING APENAS EM TABLES _ 
-- ABUSRDAMENTE LARGAS...







-- 3) QUANDO DIZEMOS ""TABLES LARGAS"",

-- nao queremos 


-- DIZER LARGAS EM QUESTAO DE __ ROWS,


-- E SIM __ LARGAS __ 


-- EM QUESTAO 



-- DE ___ DATA___...








-- 4) TABLE LARGA === TABLE COM MÚLTIPLOS TERABYTES DE EXTENSAO...












-- --> ESSE TIPO DE TABLE, DE MTOS TERABYTES,

-- REALMENTE PODE SE BENEFICIAR DE CLUSTER KEYS....






-- ---------------------------------------











-- MAS A PERGUNTA PRINCIPAL A SE RESPONDER, AQUI,



-- É ""QUAL COLUMN DEVEMOS USAR __ PARA FILTRAR/CLUSTER 
-- NOSSA TABLE"",

-- para criar 



-- ESSES MICRO-PARTITIONS...






-- para decidir isso, DEVEMOS:








-- 1) CONSIDERAR _ QUAIS _ COLUMNS SAO USADAS 
-- COM __ MAIOR FREQUENCIA 


-- _ COM __ CLÁUSULAS DE ""WHERE"" 

-- (
--     PARA TABLES DE _ EVENTS_, 

--     AS COLUMNS MAIS USADAS 

--     SAO QUASE SEMPRE 

--     COLUMNNS DE TIPO ""DATE""...
-- )






-- --> ESSE É O PRIMEIRO CRITÉRIO QUE DEVE SER CONSIDERADO....











-- 2) SE USAMOS TIPICAMENTE __ MÚLTIPLAS COLUMNS EM FILTERS (WHERE),


-- NÓS TIPICAMENTE PODEMOS NOS BENEFICIAR DE MÚLTIPLOS 

-- CLUSTER KEYS (

--     isso é possível, e pode fazer sentido, a depender das situacoes....
-- )





-- 3) DEPOIS DISSO, DESSES USE-CASES,





-- DEVE-SE CRIAR CUSTOM CLUSTERING 


-- __ SE __ TIVERMOS __ COLUMNS QUE __ 

-- SAO 

-- FREQUENTEMENTE USADAS EM __ JOINS__...










-- 4) TAMBÉM DEVEMOS 


-- TER CIENCIA/SABER QUE 


-- """"O NÚMERO DE VALUES DISTINTOS"""" também 

-- importa, para o clustering...



-- (


--     SE A TABLE/COLUMN QUE 
--     QUEREMOS USAR 

--     É _ MT __ FINE-GRANULAR, 


--     O _ CLUSTERING PODE NAO SER TAO EFETIVO...
-- )







-- --> SE TIVERMOS 1 COLUMN COM VALUES TOTALMENTE DISTINTOS,

-- COMO 

-- 1 COLUMN DE __ ""iD"" COM VALUES TOTALMENTE UNIQUE,



-- O CLUSTERING REALMENTE NAO SERÁ MT EFETIVO...

-- (esse é o exemplo mais extremo)









-- --> outro exemplo em que 

-- o clustering nao será efetivo 


-- é 1 table com 1 column de gender (female/male),




-- O QUE QUER DIZER QUE 

-- FICARÍAMOS COM 2 CLUSTERS GIGANTES,


-- APENAS 2 DISTINCT VALUES (


--     pouca mudanca....
-- )










-- --> É BOM EVITAR ESSES 2 CASES,



-- DE """VALUES TOTALMENTE UNIQUE"" EM 1 COLUMN (grupos mt pequenos) 



-- E 



-- O DE ""POUCOS GRUPOS (como 2 grupos) EM 1 COLUMN""














--> PARA PRATICAR ISSO AGORA,


-- DEVEMOS 




-- VER A SINTAXE E COMANDOS PARA CRIAR CLUSTERS...
















--> PARA CRIAR CLUSTERS EM NOSSAS TABLES,

-- ESCREVEMOS ASSIM:














CREATE TABLE exemplo (
    ... INT,
    ... STRING,
    ... VARCHAR(50),
    col_exemplo INT
) CLUSTER BY (col_exemplo);





-- É CLARO QUE PODEMOS CLUSTERIZAR/CRIAR CLUSTER KEY 


-- PARA __ MÚLTIPLAS COLUMNS,


-- MÚLTIPLOS CLUSTER KEYS...



-- TIPO ASSIM:







CREATE TABLE exemplo (
    ... INT,
    ... STRING,
    ... VARCHAR(50),
    col_exemplo INT,
    col_exemplo_2 STRING
) CLUSTER BY (col_exemplo, col_exemplo_2);







-- -> TAMBÉM PODEMOS CLUSTERIZAR NAO POR COLUMNS,


-- MAS POR STATEMENTS, SE QUISERMOS...







-- ex:






CREATE TABLE exemplo (
    ... INT,
    ... STRING,
    ... VARCHAR(50),
    col_exemplo INT
) CLUSTER BY (<expression>);






-- EXEMPLO: FUNCTION SQL DE ""MONTH"" (se estivermos 
-- FILTRANDO POR MONTH)






-- ENTRETANTO, SE NOSSA TABLE JÁ TIVER SIDO CRIADA,
-- E SE QUISERMOS 

-- ALTERAR O CLUSTERING JÁ EXISTENTE,




-- PODEMOS 



-- RODAR ASSIM:






ALTER TABLE exemplo CLUSTER BY (col_exemplo_1, col_exemplo_2, expression);






-- --> TAMBÉM PODEMOS DROPPAR CLUSTER KEYS,

-- POR MEIO DESTE COMANDO:








ALTER TABLE exemplo DROP CLUSTERING KEY;