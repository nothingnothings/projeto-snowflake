-- AGORA VAMOS COPIAR NOSSA DATA PARA 1 TABLE FINAL, a data estruturada e flattenada...



NA VERDADE, NAO PRECISARÍAMOS FAZER TUDO ISSO, AQUI.. ---->



PQ 



AS OPCOES 

DO SNOWFLAKE 

PARA 

""PARSE E FLATTEN"" A DATA  ""ON THE GO"",




elas já sao bem boas...

















--> MAS O PROFESSOR AINDA ACHA QUE É MELHOR, MAIS FÁCIL,

-- TERMOS 1 TABLE FINAL,

-- COM ESSES FINAL RESULTS...











-- PARA ISSO, TEMOS A QUERY DE FLATTEN ANTERIOR:





SELECT RAW_FILE:first_name::STRING AS First_name,
        f.value:language::STRING as Language,
        f.value:level::STRING as Level_Spoken
        FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f; ---- EIS O GRANDE DIFERENCIAL.






-- PARA CRIAR 1 TABLE A PARTIR DESSA DATA EXTRAÍDA, TEMOS ALGUMAS OPTIONS:


-- 1a option) CREATE TABLE AS (clássico) --> com isso, copiamos a data enquanto criamos a nova table.




CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.final_languages_table AS 
    SELECT
        RAW_FILE:first_name::STRING as First_name,
        f.value:language::STRING as Language,
        f.value:level::STRING as Level_Spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;








-- 2a option) INSERT INTO -- com isso,  CRIAMOS A NOSSA TABLE ANTES, E SÓ DEPOIS INSERIMOS A DATA MANIPULADA, DENTRO DELA...





-- CREATE THE TABLE FIRST
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.final_languages_table (
    first_name STRING,
    language STRING,
    level_spoken STRING
);


-- THEN INSERT THE DATA.


INSERT INTO OUR_FIRST_DB.PUBLIC.final_languages_table
    SELECT 
        RAW_FILE:first_name::STRING as first_name,
        f.value:language::STRING as language,
        f.value:level::STRING as level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table (flatten(RAW_FILE:spoken_languages)) f;