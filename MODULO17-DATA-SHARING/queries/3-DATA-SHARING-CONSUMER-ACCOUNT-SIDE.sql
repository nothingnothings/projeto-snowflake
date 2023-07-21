
-- Show all shares (consumers (you) and PRODUCERS) 
SHOW SHARES;

-- See details of a share 
-- ex: --> shows our grants of database, schema and table
DESC SHARE <producer_account>.ORDERS_SHARE;

-- Create a database in CONSUMER ACCOUNT, USING THE SHARE
CREATE DATABASE DATA_S FROM SHARE <producer_account>.ORDERS_SHARE;

-- Validate table access 
SELECT * FROM DATA_S.PUBLIC.ORDERS;






--> O SHOW SHARES NOS DÁ


-- DATA COMO:

-- created_on 

-- kind -> outbound (estamos conferindo o share a alguém, somos o producer)
--      --> inbound( estamos RECEBENDO O SHARE DE ALGUÉM, SOMOS O CONSUMER)...



-- name --> é possível ver o nome/id da account que nos deu esse share (e nosso nome também)
--             EX: WTHZWSC.ZNB24252.ORDERS_SHARE


-- database_name -> NOME DA DATABASE SENDO COMPARTILHADA COM O DATA SHARE...






---> CERTO... 




-- MAS PARA USARMOS A DATA CONFERIDA PELO SHARE/DATA SHARE,



-- PRIMEIRAMENTE PRECISAMOS __ CRIAR _ 1 DATABASE COM ESSE SHARE...







--> PQ ESSE COMPARTILHAMENTO DE DADOS NAO ACONTECE DE FORMA AUTOMÁTICA,

-- PRECISAMOS CRIAR 1 TABLE, LÁ NA CONSUMER ACCOUNT,

-- A PARTIR 

-- DESSA SHARE...







-- FAZEMOS ISSO COM ESTE COMANDO:




-- FAZEMOS ISSO COM ESTE COMANDO:



-- Create a database in CONSUMER ACCOUNT, USING THE SHARE
CREATE DATABASE DATA_S FROM SHARE <producer_account>.ORDERS_SHARE;


-- ex:
CREATE DATABASE DATA_S FROM SHARE WTHZWSC.ZNB24252.ORDERS_SHARE;


