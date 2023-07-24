

-- agora que sabemos como criar 1 share 

-- e como criar 1 secure view,


-- o processo 



-- DE SHARE DE 1 SECURE VIEW 

-- NAO É TAO DIFERENTE 

-- DO SHARE DE 1 TABLE/SCHEMA/DATABASE...





--> O CÓDIGO COMECA ASSIM (NA CONTA MAIN):


SHOW SHARES;


-- Create share object -- 

CREATE OR REPLACE SHARE SECURE_VIEW_SHARE;


-- Grant usage on database and schema -- 
GRANT USAGE ON DATABASE CUSTOMER_DB TO SHARE SECURE_VIEW_SHARE;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO SHARE SECURE_VIEW_SHARE;

-- Grant select on view --
GRANT SELECT ON VIEW CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW TO SHARE SECURE_VIEW_SHARE;






--> AS ÚNICAS VIEWS QUE PODEM SER SHAREADAS 
-- SAO 


-- AS VIEWS "SECURE', SECURE VIEWS...











-> POR FIM, ADICIONAMOS 1 CONTA, OUTRA CONTA SNOWFLAKE (
    ou nossa reader account
)


A ESSE SHARE...






TIPO ASSIM:




-- ADD ACCOUNT TO SHARE -- 
ALTER SHARE SECURE_VIEW_SHARE
ADD ACOUNT=ASDASDSdD12



















EX:



-- ADD ACCOUNT TO SHARE -- 
ALTER SHARE SECURE_VIEW_SHARE
ADD ACCOUNT=RYB24955;



--> ESSA É A CONSUMER ACCOUNT COM QUE 


QUEREMOS COMPARTILHAR NOSSA DATA...










ISSO FEITO,





LOGGAMOS NA OUTRA ACCOUNT...





com esta url e credentials:


-- {"accountName":"TECH_JOY_ACCOUNT",
-- "accountLocator":"RYB24955",
-- "url":"https://wthzwsc-tech_joy_account.snowflakecomputing.com",
-- "accountLocatorUrl":"https://ryb24955.us-east-1.snowflakecomputing.com"

-- }



pegamos essa url,

e aí usamos 

as credentials como as utilizamos 

lá no 



comando de create dessa READER ACCOUNT, que 

rodamos anteriormente:


CREATE MANAGED ACCOUNT tech_joy_account 
ADMIN_NAME=tech_joy_admin,
ADMIN_PASSWORD='Tech_Account_Joy@456',
TYPE=READER;


















POR FIM, PARA PODERMOS _ USAR/RODAR 


SELECTS NESSA VIEW,


LÁ NA NOSSA 


READER ACCOUNT,


RODAMOS ASSIM:



SHOW SHARES; -- pegamos o identificador da share QUE QUEREMOS USAR PARA CRIAR 1 DATABASE a partir dela...

CREATE OR REPLACE DATABASE VIEW_DATABASE FROM SHARE WTHZWSC.ZNB24252.SECURE_VIEW_SHARE;



SELECT * FROM VIEW_DATABASE.PUBLIC.SECURE_CUSTOMER_VIEW;