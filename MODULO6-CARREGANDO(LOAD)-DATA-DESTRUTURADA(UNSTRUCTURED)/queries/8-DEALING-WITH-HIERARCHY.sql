-- vamos revisar tudo que aprendemos até agora...

SELECT
    RAW_FILE:spoken_languages::STRING as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;



-- first way to deal with array data ---> AGGREGATE (transform in 1 value, with array_size() function):


SELECT
    array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;





-- combined with other normal columns
SELECT
    RAW_FILE:first_name as first_name,
    array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;





-- select only a single value, first value, in an array:
SELECT
    RAW_FILE:spoken_languages[0] as first_language
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;




-- select only a single value, first value, in an array - combined with normal columns (with transformation to string):
SELECT
    RAW_FILE:first_name::STRING as first_name
    RAW_FILE:spoken_languages[0] as first_language
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;



-- select only a single value, first value, in an array... also acessing property in object:
SELECT
    RAW_FILE:first_name::STRING as first_name
    RAW_FILE:spoken_languages[0].language as first_language, -- access property in object.
    RAW_FILE:spoken_languages[0].level as level_spoken,
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;





--> SE QUISERMOS FAZER COM QUE _ AS OUTRAS LANGUAGES DA 
-- PESSOA APARECAM,
-- TEMOS QUE __ USAR _ o RECURSO DO UNION ALL....








SELECT
    RAW_FILE:id::INT as ID,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as Language_spoken,
    RAW_FILE:spoken_languages[0].level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL
SELECT
    RAW_FILE:id::INT as ID,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as Language_spoken,
    RAW_FILE:spoken_languages[1].level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY ID;





-- PODEMOS FAZER ISSO COM QUANTAS LANGUAGES QUISERMOS:









-- 3 records para cada pessoa, pq cada pessoa pode ter 1 máximo de 3 languages.

SELECT
    RAW_FILE:id::INT as ID,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as Language_spoken,
    RAW_FILE:spoken_languages[0].level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL
SELECT
    RAW_FILE:id::INT as ID,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as Language_spoken,
    RAW_FILE:spoken_languages[1].level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL
SELECT
    RAW_FILE:id::INT as ID,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[2].language::STRING as Language_spoken,
    RAW_FILE:spoken_languages[2].level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY ID;





-- -> MAS É CLARO QUE ISSO É SUBOPTIMAL..



-- RAZOES:



-- 1) TEMOS MT CÓDIGO....


-- 2) MTAS UNIONS


-- 3) NAO SABEMOS QUANTOS ELEMENTOS EXISTEM, NESSES OBJECTS... (ficamos com mtos null values)













--> ISSO NAO É NADA IDEAL...

-- PARA RESOLVER ISSO,


-- HÁ UMA 


-- MANEIRA BEM MAIS FÁCIL,



-- E MAIS SIMPLES...



-- -> PARA ISSO, O PROFESSOR NOS MOSTRA ESTE CÓDIGO:






SELECT RAW_FILE:first_name::STRING AS First_name,
        f.value:language::STRING as Language,
        f.value:level::STRING as Level_Spoken
        FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f; ---- EIS O GRANDE DIFERENCIAL.



--> PARA ISSO, DEVEMOS USAR 
-- A __ FUNCTION __ DE ""table()""""
-- JUNTO COM A FUNCTION DE ""FLATTEN()"",
-- combinadas com 

-- 1 

-- ALIAS...









-- O RESULTADO DISSO É:






-- FIRST_NAME  LANGUAGE             LEVEL_SPOKEN
-- Portia      Kazakh               Advanced
-- Portia      Lao                  Basic
-- Dag         Assamese             Basic
-- Dag         Papiamento           Expert
-- Dag         Telugu               Basic
-- Heath       Swati                Expert
-- Dita        Chinese              Advanced
-- Dita        Mongolian            Basic
-- Nikki       Filipino             Basic
-- Nikki       Kazakh               Basic
-- Austina     Northern Sotho       Basic








-- OU SEJA, É O MESMO RESULTADO DAS UNION, MAS AGORA BEM MAIS FÁCIL DE ESCREVER,
-- E COM BEM MENOS CÓDIGO (apenas com o uso de table, flatten e 1 alias)...
-- OUTRO BENEFÍCIO É QUE NAO TEMOS NENHUM ""NULL VALUE"" EM ALGUM ROW...




--> E ESSA FUNCTION É REALMENTE SUPER ÚTIL SE ESTAMOS TRABALHANDO 
-- COM ESSA DATA UNSTRUCTURED/HIERARCHICAL...



--> PRIMEIRAMENTE DEVEMOS ANALISAR A SINTAXE:




-- 1) A FUNCTION DE ""FLATTEN"" --> usamos essa function em conjunto com 

-- a function de ""table()""...


-- EM ""flatten()"",

-- passamos a COLUMN, 


-- a column e o parent attribute,
-- tipo assim:




-- flatten(RAW_FILE:spoken_languages)



-- RAW_FILE --> É NOSSA COLUMN.


-- spoken_languages -> é o attribute/propriedade que contém o array...










-- NA PARTE DE 

-- ""FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;""

-- NESSA SINTAXE, NÓS ESTAMOS __ BASICAMENTE_ FAZENDO _ UM __ JOIN....


-- ESTAMOS FAZENDO 

-- 1 JOIN ENTRE 2 """"TABLES"""",




-- a table de 





-- ""OUR_FIRST_DB.PUBLIC.JSON_RAW""


-- e 


-- a table de 

-- ""table(flatten(RAW_FILE:spoken_languages))"",



-- QUE GANHOU UM ALIAS DE "f"....










-- OUTRO DETALHE --> PARA TODOS OS ""NESTED OBJECTS"",




-- devemos usar a keyword de 

-- "".value"",



-- como observado nestas linhas:



--         f.value:language::STRING as Language,
--         f.value:level::STRING as Level_Spoken











-- "f" --> nos dá o value da table flattenada....




-- "f.value" --> nos dá o VALUE de cada elemento dessa table (como {language: 'english', level: 2})




-- "f.value:language" --> nos dá o VALUE DESSA CHILD/property dessa table flattenada.






-- A ÚLTIMA ETAPA:

-- CREATE _ DA NOSSA FINAL TABLE,

-- E AÍ 

-- COPIAR _ TODA 

-- ESSA DATA NA NOSSA TABLE FINAL,
-- COM ESSA FORMA ESTRUTURADA LEGAL...