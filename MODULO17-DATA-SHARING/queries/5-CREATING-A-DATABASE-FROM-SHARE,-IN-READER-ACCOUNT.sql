

AGORA QUE CRIAMOS UMA READER ACCOUNT E ADICIONAMOS 

ESSA CONTA NA NOSSA SHARE (da main account 
), COM ESTES COMANDOS:






CREATE MANAGED ACCOUNT tech_joy_account 
ADMIN_NAME=tech_joy_admin,
ADMIN_PASSWORD='Tech_Account_Joy@456',
TYPE=READER;




SHOW MANAGED ACCOUNTS; -- shows created accounts, with login credentials and loginURl





-- SHARING THE DATA -- 
ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = <consumer_account>

















-- AGORA QUE FIZEMOS ISSO, É HORA DE FAZER LOGIN NA OUTRA 

-- CONTA, NA READER ACCOUNT DE NOSSA CONTA PRINCIPAL.







--> OK...





-- ENTRAMOS NESSA CONTA, COM A ACCESSURL E AS CREDENTIALS....











--> COM ISSO,



-- NOSSA READER ACCOUNT FICOU COM ACESSO 

-- A ESSA DATABASE...







-- -> SE CLICAMOS EM DATA > PRIVATE SHARING,



-- PODEMOS VER TODAS AS SHARES COMPARTILHADAS COM 

-- A READER ACCOUNT....







--> BASTA CLICAR EM "ORDERS_SHARE"

-- E "GET_DATA"



-- PARA CRIARMOS 1 DATABASE PARA QUERIAR ESSA DATA....
-- (
--     E ESSA DATABASE NAO VAI GASTAR NENHUM STORAGE 
--     SPACE, NA NOSSA CONTA READER... PQ VAI USAR 

--     O STORAGE SPACE DA MAIN ACCOUNT...
-- )






------------------------






O PROFESSOR NOS MOSTRA COMO FAZER O CREATE 

DESSA DATABASE,



MAS COM CÓDIGO SQL...









ELE ESCREVE ASSIM:





-- Create Database from SHARE (From main account - THIS CODE MUST BE EXECUTED IN THE READER ACCOUNT, NOT THE MAIN ACCOUNT) --


-- Show all Shares (consumers and producers)
SHOW SHARES;


-- See DETAILS on SHARE 
DESC SHARE DASAKAS121.ORDERS_SHARE; -- dummy example 

-- Create a database in consumer account, using the share 
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

-- Validate table access
SELECT * FROM DATA_SHARE_DB.PUBLIC.ORDERS;





-- Setup virtual warehouse 
CREATE WAREHOUSE READ_WH WITH 
WAREHOUSE_SIZE = XSMALL,
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE 
INITIALLY_SUSPENDED = TRUE;

















-- CÓDIGO COMPLEMENTADO:



-- -- Create Database from SHARE (From main account - THIS CODE MUST BE EXECUTED IN THE READER ACCOUNT, NOT THE MAIN ACCOUNT) --


-- //Show all Shares (consumers and producers)
-- SHOW SHARES;


-- //See DETAILS on SHARE 
-- DESC SHARE WTHZWSC.ZNB24252.ORDERS_SHARE -- example 

-- //Create a database in consumer account, using the share 
-- -- CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

-- CREATE DATABASE DATA_SHARE_DB FROM SHARE WTHZWSC.ZNB24252.ORDERS_SHARE;

-- //Validate table access
-- SELECT * FROM DATA_SHARE_DB.PUBLIC.ORDERS;





-- //Setup virtual warehouse -- THIS WILL USE READER ACCOUNT'S COMPUTE POWER
-- CREATE WAREHOUSE READ_WH WITH 
-- WAREHOUSE_SIZE = XSMALL,
-- AUTO_SUSPEND = 180
-- AUTO_RESUME = TRUE 
-- INITIALLY_SUSPENDED = TRUE;

