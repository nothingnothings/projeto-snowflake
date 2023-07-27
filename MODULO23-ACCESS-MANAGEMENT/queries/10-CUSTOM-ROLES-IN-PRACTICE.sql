





OK... NAS ÚLTIMAS AULAS,

ASSIGNAMOS O CUSTOM ROLE DE 


"SALES_ADMIN"



AO ROLE BUILT-IN "SYSADMIN"...








POR ISSO, AGORA VAMOS USAR O SYSADMIN (na conta do adam)

PARA TRABALHARMOS COM ESSES CUSTOM ROLES 



E CHECARMOS SEU BEHAVIOR....











--> OK...





NA CONTA DO ADAM,

ABRIMOS 1 WORKSHEET...









--. JÁ TÍNHAMOS VINCULADO OS ROLES DE 
"SALES_ADMIN" (COM SALES_USERS)


AO 


ROLE DO SYSADMIN, 

POR ISSO O 


ADAM TEM ESSES ROLES E SEUS PRIVILEGES....







--> agora queremos usar o role de "sales_admin":





--> bem, agora vamos escrever assim: 






USE ROLE SALES_ADMIN;
USE SALES_DATABASE;




-- Create table -- 
CREATE OR REPLACE TABLE CUSTOMERS (
    ID NUMBER,
    FULL_NAME VARCHAR,
    EMAIL VARCHAR,
    PHONE VARCHAR,
    SPENT NUMBER,
    CREATE_DATE DATE DEFAULT CURRENT_DATE
);




-- Insert values in table -- 
INSERT INTO CUSTOMERS (id, full_name, email, phone, spent) 
VALUES 
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);










COMO "SALES_ADMIN" é o DONO DO OBJECT "SALES_DB",


podemos 

fazer o que quiser com essa table...






tipo assim:



SHOW TABLES; -- mostra a única table disponível ao sales_admin role..


-- query from table --
SELECT * FROM CUSTOMERS;




-- we change role, lower role --
USE ROLE SALES_USERS;





QUANDO TROCAMOS DE ROLE, PARA "SALES_USERS",




A NOSSA TABLE FICA INVISÍVEL,
NAO FICA DISPONÍVEL A ELE....






QUER DIZER QUE SALES_USERS 


NAO TEM PERMISSAO PARA QUERIAR ESSA TABLE/NEM VISUALIZAR...



















É POR ISSO QUE TROCAREMOS PARA O ROLE DE "SALES_ADMIN"
E ENTAO VAMOS DAR GRANT DOS PRIVILEGES NECESSÁRIOS 


AO ROLE DE "SALES_USERS",


PARA QUE ELE CONSIGA QUERIAR E TRABALHAR COM ESSA DATABASE/TABLE...











-- GRANT USAGE TO ROLE 'SALES_USERS' --
USE ROLE SALES_ADMIN;




GRANT USAGE ON DATABASE SALES_DB TO ROLE SALES_USERS;
GRANT USAGE ON SCHEMA SALES_DB.PUBLIC TO ROLE SALES_USERS;
GRANT SELECT ON TABLE SALES_DB.PUBLIC.CUSTOMERS TO ROLE SALES_USERS;


--------------------------------------






COMO VC PODE PERCEBER, PRECISAMOS GARANTIR ACCESS 

E USAGE TANTO NA DATABASE COMO NO SCHEMA DENTRO 

DA DATABASE...









--> TAMBÉM PRECISAMOS GARANTIR SELECT NA TABLE (
    E OUTRAS OPERATIONS, CASO NECESSÁRIO...
)






ESCREVEMOS ASSIM:






-- Validate privileges -- 
USE ROLE SALES_USERS;
SELECT * FROM CUSTOMERS;
DROP TABLE CUSTOMERS; -- not allowed (only select) 
DELETE FROM CUSTOMERS WHERE ID=3; --  not allowed (only select) 


SHOW TABLES;










--> NAO CONSEGUIMOS FAZER NADA ALÉM DE SELECT NESSA TABLE,


POIS NAO TEREMOS PRIVILEGES SUFICIENTES...










--> MAS O QUE PODEMOS FAZER, PARA 
CONTORNAR ISSO,


É FAZER GRANT DE PRIVILEGES COMO "DELETE" E "UPDATE"

NESSA TABLE, AO ROLE DE "SALES_USERS",



USANDO O _ _ROLE DE "SALES_ADMIN" (
    que pode conferir esses privileges, sim...
)


------------------------------------














OK...




BASTA RODAR ASSIM:




-- grant DROP on table to a role --
USE ROLE SALES_ADMIN;
GRANT DELETE ON TABLE SALES_DB.PUBLIC.CUSTOMERS TO ROLE SALES_USERS;




















--> E O SYSADMIN TAMBÉM É CAPAZ DE VER E MANAGEAR ESSA TABLE....









--> MAS SE TENTAMOS FAZER A MESMA COISA COM O ROLE DE 


"HR", QUE NAO ESTÁ CONECTADO AO "SYSADMIN",



FICAMOS 



__ COM PROBLEMAS___...










VEREMOS ISSO __ NA PRÓXIMA AULA...








