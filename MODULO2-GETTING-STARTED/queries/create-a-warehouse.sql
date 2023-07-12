



CREATE WAREHOUSE COMPUTE_WAREHOUSE -- sintaxe SNOWFLAKE... ISTO CRIA 1 COMPUTE WAREHOUSE...
WITH -- OUTRA KEYWORD SNOWFLAKE, usada para definir as PROPRIEDADES DA WAREHOUSE QUE CRIAREMOS...

WAREHOUSE_SIZE=XSMALL   -- outra keyword snowflake. É usada para DEFINIR O TAMANHO DE NOSSO WAREHOUSE (quantos clusters), e é uma das propriedades mais importantes...
-- tamanhos podem ser XSMALL, SMALL, MEDIUM, LARGE, XLARGE, ETC.....

MAX_CLUSTER_COUNT=1  -- se nao especificarmos nada, ficamos com 1 cluster, mas podemos especificar o maximo de clusters que queremos que nossa warehouse tenha...
-- MIN_CLUSTER_COUNT=1 -- se nao especificarmos nada, ficamos com 1 cluster, mas podemos especificar o minimo de clusters que queremos que nossa warehouse tenha...

AUTO_SUSPEND = 600 -- após 600 segundos (10 minutos) sem uso, nossa warehouse será SUSPENSA.
AUTO_RESUME = TRUE -- se a warehouse for suspensa, ela será automaticamente resumida quando for requisitada novamente (Quando forem rodadas sql queries contra ela)...
INITIALLY_SUSPENDED= TRUE -- usamos isto se queremos que a instance COMECE DE FORMA SUSPENDED (o comportamento default é comecar de forma ACTIVE, com ela já ACTIVE)
COMMENT = 'This is a Snowflake warehouse';










-- CERTO...









-- E, É CLARO, 


-- AS PROPERTIES QUE NAO FOREM ESPECIFICADAS 



-- RECEBERAO SEUS VALUES DEFAULT