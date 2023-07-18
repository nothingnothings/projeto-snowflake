






-- outro aspecto importante para a performance (
--     ALÉM DO EXECUTE DE QUERIES EM PARALELO,
--     POR MEIO DE 

--     MULTI-CLUSTERING/AUTOSCALING
-- ),






-- é O 




-- ""CACHING""










-- CACHING -------> É UM PROCESSO ENABLADO AUTOMATICAMENTE,




-- ENABLADO 


-- PARA __ ACELERAR A  VELOCIDADE 



-- DE SUAS QUERIES....













-- --> É UM PROCESSO 



-- QUE SERVE PARA _ ACELERAR A EXECUCAO 


-- DOS QUERY RESULTS... -->  QUER DIZER QUE 



-- _SE 1 QUERY FOI EXECUTADA NO PASSADO,

-- O RESULT 


-- SET 


-- É _ CACHEADO_,





-- E PODE SER USADO MAIS TARDE...












-- É CLARO QUE ESSES RESULT SETS NAO SAO 

-- STORADOS PARA SEMPRE,





-- __ MAS __ ELES _ SAO ARMAZENADOS 


-- POR ATÉ 24 HORAS..., OU ENTAO,


-- ATÉ QUE 

-- A UNDERLYING DATA _ SEJA 

-- ALTERADA....













-- --> ISSO QUER DIZER QUE O SNOWFLAKE É SUPER BOM 


-- EM COMPREENDER METADATA,





-- TUDO PARA QUE SAIBAM QUANDO 


-- ELES 
-- JÁ NAO PODEM MAIS 

-- USAR ESSE CACHE (
--  ou seja,

--  quando é REALMENTE NECESSÁRIO REEXECUTAR 

--  ESSA QUERY... apenas 
--  quando 

--  a underlying data realmente for alterada...


-- )









-- ------> E, COMO O PROFESSOR MENCIONOU,


-- ESSE PROCESSO (o caching) É HANDLADO AUTOMATICAMENTE PELO SNOWFLAKE...














-- -> MAS O QUE PODEMOS FAZER QUANTO A ISSO...?

-- PODEMOS MUDAR O COMPORTAMENTO?








-- NAO MESMO... --> BEM,




-- NA VERDADE 


-- PODEMOS 



-- FAZER 


-- 1 COISA... --------> PODEMOS __GARANTIR __ QUE 




-- O MESMO TIPO DE QUERIES_  SEMPRE VÁ 



-- PARA _A MESMA WAREHOUSE --> PQ ESSE 


-- SERÁ 

-- O 

-- LOCAL EM QUE 



-- OS RESULTS ESTARAO ARMAZENADOS/CACHEADOS (results que foram produzidos 
-- por essas queries)













-- --> EXEMPLO CONCRETO:


-- TEMOS 1 TIME DE DATA SCIENTISTS,

-- QUE 
-- RODAM 



-- QUERIES __SIMILARES,


-- PARA _ DIFERENTES USERS... ----> AÍ, NESSE CASO,

-- DEVEMOS GARANTIR QUE 


-- ESSES 

-- DATA SCIENTISTS SEMPRE USEM 

-- A 

-- MESMA WAREHOUSE,

-- PARA MAXIMIZAR OS EFEITOS DESSE CACHING...



