

-- example of using snowflake result set caching to the max:



SELECT AVG(C_BIRTH_YEAR) FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER;















-- FICAMOS COM 1958...






















-- --> quando executamos pela primeira vez, demora 3 segundos...













-- -----------> se clicamos no query id dessa query,


-- FICAMOS COM OS DETAILS DESSA QUERY...












-- PODEMOS VER A PROFILE DA QUERY...










-- --> O PROFILE FOI TIPO:










-- TABLESCAN(2) --> aggregate(1) --> result(3)















-- -> mas se re-rodamos essa query, ficamos com isto:







-- QUERY RESULT REUSE(0)



-- -> OU SEJA, ELE REUTILIZOU ESSE RESULT SET...






-- --> MAS AGORA DEVEMOS INVESTIGAR O QUE ACONTECE _ SE 

-- TENTAMOS RODAR ESSA QUERY COM 1 USER DIFERENTE...






--> CRIAMOS 1 NOVO ROLE, DATA_SCIENTIST_2...





-- TIPO ASSIM:




CREATE ROLE DATA_SCIENTIST_2;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DATA_SCIENTIST_2;





CREATE USER DS4 PASSWORD = 'DS1' LOGIN_NAME = 'DS1' DEFAULT_ROLE='DATA_SCIENTIST_2'
DEFAULT_WAREHOUSE = 'SCIENCE_WH' MUST_CHANGE_PASSWORD=FALSE;


GRANT ROLE DATA_SCIENTIST_2 TO USER DS1;











--> certo... agora trocamos o user LOGGADO...


-- fazemos login com esse novo user, para ver 

-- se 

-- a query realmente vai demorar tanto tempo...











--> certo... agora trocamos o user LOGGADO...


fazemos login com esse novo user, para ver 

se 

a query realmente vai demorar tanto tempo...


















--> BEM, FICAMOS COM BEM MENOS SEGUNDOS, NOVAMENTE...




--> isso aconteceu justamente pq REUTILIZAMOS A QUERY....





-- QUER DIZER QUE PREVIOUS QUERIES PODEM SER REUTILIZADAS, MESMO QUANDO 
-- ESTAMOS COM USERS DIFERENTES... (em 1 mesma warehouse, 
-- rodando as mesmas queries nessa warehouse)


-- SE USERS TIVEREM MESMAS QUERIES, DEVEM SER CAPAZES DE USAR O MESMO WAREHOUSE PARA 
-- ESSAS QUERIES, PARA OPTIMIZAR O RETRIEVAL DE DATA..