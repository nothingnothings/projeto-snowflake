


AGORA VEREMOS COMO PODEMOS TAMBÉM 

FAZER 

SHARE DE 1 




DATABASE OU SCHEMA COMPLETO....









ISSO PQ, ATÉ AGORA,


NÓS APENAS VIMOS COMO PODEMOS FAZER SHARE 


DE 

SINGLE TABLES,


MAS AGORA QUEREMOS 


VER COMO PODEMOS 




FAZER SHARE DE ___tODAS AS TABLES 


DE 1 GIVEN SCHEMA OU DATABASE....











--> o primeiro passo, é claro,


É CRIAR O OBJECT DE "SHARE"...










--> PARA ISSO, ESCREVEMOS:







SHOW SHARES;


-- Create share object -- 
CREATE OR REPLACE SHARE COMPLETE_SCHEMA_SHARE;

-- Grant usage on database and schema -- 
GRANT USAGE ON DATABASE OUR_FIRST_DB TO SHARE COMPLETE_SCHEMA_SHARE;
GRANT USAGE ON SCHEMA OUR_FIRST_DB.PUBLIC TO SHARE COMPLETE_SCHEMA_SHARE;

-- Grant select on all tables --
GRANT SELECT ON ALL TABLES IN SCHEMA OUR_FIRST_DB.PUBLIC TO SHARE COMPLETE_SCHEMA_SHARE;
GRANT SELECT ON ALL TABLES IN DATABASE OUR_FIRST_DB TO SHARE COMPLETE_SCHEMA_SHARE;

















A PRÓXIMA ETAPA, É CLARO,


É __ ADICIONAR __ A CONTA COM QUEM QUEREMOS COMPARTILHAR


A _ ESSA SHARE...







FAZEMOS ISSO COM ESTE COMANDO:





-- Add account to share -- 
ALTER SHARE COMPLETE_SCHEMA_SHARE
ADD ACCOUNT=KASSDA21s51;



SHOW MANAGED ACCOUNTS; -- usado para DESCOBRIRMOS QUAL É O NOME/ID de nossa account, para usar no ALTER SHARE. (é o LOCATOR)



---------------------------------




--> ESSE ACCOUNT QUE ADICIONAMOS É O ACCOUNT QUE 

QUEREMOS USAR 


COMO 

"READER ACCOUNT"...





POR ISSO VAMOS LÁ E LOGGAMOS 


DENTRO DESSA READER ACCOUNT, COM ISTO:





-- https://app.snowflake.com/wthzwsc/tech_joy_account







--> "tech_joy_account" --> vc deve substituir 


esse  

segmento 


pelo actual nome da conta reader que vc criou, no seu caso
concreto.

















-> É NA READER ACCOUNT QUE VAMOS QUERER FAZER 

CONSUME DESSA DATABASE/SCHEMA/DATA/TABLES...








-> LÁ NA READER ACCOUNT,



EXECUTO ESTES COMANDOS:




SHOW SHARES;


DESC SHARE WTHZWSC.ZNB24252.COMPLETE_SCHEMA_SHARE;

CREATE OR REPLACE DATABASE OUR_FIRST_DB FROM SHARE WTHZWSC.ZNB24252.COMPLETE_SCHEMA_SHARE;



SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;






-- --> MAS É CLARO QUE, PARA A DATA QUE 

-- JÁ EXISTIA no momento 
-- em que  RODAMOS "GRANT SELECT ON ALL TABLES",


-- AS READER ACCOUNTS TERAO ACESSO....