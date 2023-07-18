




-- PARA MUDARMOS O TAMANHO DE 1 DE NOSSOS WAREHOUSES, PODEMOS RODAR 
-- COMANDOS SQL.
-- também podemos alterar esses tamanhos na GUI.
ALTER WAREHOUSE COMPUTE_WH
SET WAREHOUSE_SIZE = 'XSMALL';



ALTER WAREHOUSE COMPUTE_WH
SET WAREHOUSE_SIZE = 'SMALL';







-- SCALE-UP (aumentar o tamanho FIXO de 1 warehouse) --> IDEAL QUANDO FICAMOS 
-- COM ___ QUERIES __ MAIS COMPLEXAS...







-- DETALHE --> ___ UM CENÁRIO ___ MUITO COMUM___ 


-- É __ A MAIOR __ COMPLEXIDADE DE QUERIES,



-- E NAO __ A MAIOR __ QUANTIDADE _DE USERS (


--     EM CASOS COMO __ MAIOR COMPLEXIDADE DE _ QUERIES,

--     __ O SCALE UP, COM virtual houses maiores, cheias de maquinas
--     ,
--     É MELHOR...  ---> é a comparacao entre o L e o XS..
-- )






-- SCALE-OUT (aumentar o número de CLUSTERS,
-- MULTI-CLUSTERING, automático/MIN_CLUSTER_COUNT e 
-- MAX_CLUSTER_COUNT) --> IDEAL QUANDO FICAMOS 
-- COM ___ MAIS USERS/MAIS QUERIES AO MESMO TEMPO...







-- OK, PRECISAMOS DESSES MULTI-CLUSTER WAREHOUSES PARA REGULAR/LIDAR COM 

-- PERFORMANCE 


-- ISSUES RELACIONADAS A LARGAS QUANTIDADES DE CONCURRENT USERS...