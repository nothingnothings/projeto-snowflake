









APRENDEMOS QUE O SYSADMIN EXISTE PARA PRINCIPALMENTE 

FAZER O MANAGE DE OBJECTS (databases, SCHEMAS, TABLES, ETC)


E SEUS PRIVILEGES...












--> É POR ISSO QUE FAREMOS ISSO, NESSA LESSON...














--> AGORA QUE CRIAMOS ESTA HIERARQIUA:









                        ACCOUNTADMIN 
                       ^           ^
                SECURITYADMIN      SYSADMIN             HR_ADMIN
                       ^               ^                    ^
                    USERADMIN        SALES_ADMIN           HR
                       ^                   ^
                       I                  SALES
                       ----PUBLIC






COM O SYSADMIN,




--> DEVEMOS:





1) CREATE A VIRTUAL WAREHOUSE 


2) ASSIGNAR ESSA VIRTUAL WAREHOUSE AOS CUSTOM ROLES QUE 
JÁ CRIAMOS  (SALES, SALES_ADMIN, HR E HR_ADMIN)


3) CREATE 1 DATABASE E 1 TABLE,

E AÍ AS ASSIGNAR AOS NOSSOS CUSTOM ROLES...













-> COMO PODEMOS NOS LEMBRAR,


TÍNHAMOS CRIADO 1 USER, "ADAM",


COM O ROLE DE "SYSADMIN"...







--> PODEMOS LOGGAR NELE,


E AÍ USAREMOS 



O SEU ROLE DE SYSADMIN PARA 

REALIZAR TODAS AQUELAS OPERATIONS...





--> SE ENTRAMOS NAQUELA CONTA, DE ADAM,


TEMOS OS ROLES:

PUBLIC 


SYSADMIN (Default)


SALES_ADMIN 

SALES_USERS 




(SALES_ADMIN E SALES_USERS FORAM HERDADOS POR SYSADMIN,
QUE É O ROLE ASSIGNADO AO ADAM)..









VAMOS CRIAR NOSSOS OBJECTS, COM O ROLE DE SYSADMIN:





-- SYSADMIN -- 



-- Create a warehouse of size XSMALL 



CREATE WAREHOUSE PUBLIC_WH WITH 
WAREHOUSE_SIZE = XSMALL
AUTO_SUSPEND=300
AUTO_RESUME=TRUE;









-- Grant usage to role public --
GRANT USAGE ON WAREHOUSE PUBLIC_WH 
TO ROLE PUBLIC;




-- Create a database acessible to everyone --
CREATE DATABASE COMMON_DB
GRANT USAGE ON DATABASE COMMON_DB TO ROLE PUBLIC;



-- Create sales database for sales --
CREATE OR REPLACE DATABASE SALES_DB
GRANT OWNERSHIP ON DATABASE SALES_DB TO ROLE SALES_ADMIN;
GRANT OWNERSHIP ON SCHEMA SALES_DB.PUBLIC TO ROLE SALES_ADMIN;












CERTO... REALIZEI TODAS ESSAS OPERATIONS...









TAMBÉM PRECISAMOS CRIAR 1 DATABASE PARA SALES,


TIPO ASSIM:








CREATE DATABASE HR_DB;
GRANT OWNERSHIP ON DATABASE HR_DB TO ROLE HR_ADMIN;
GRANT OWNERSHIP ON SCHEMA HR_DB.PUBLIC TO ROLE HR_ADMIN;









ACABEI DE CONSTATAR O PROBLEMA...







SE TENTO AGORA MANIPULAR/ENXERGAR 

ESSA TABLE 

DE 


"HR_DB",


NAO CONSIGO.... NAO CONSIGO NEM COM O "SYSADMIN",




NEM COM O 



ACCOUNTADMIN...







O ÚNICO 


ROLE QUE CONSEGUE ACESSAR 


E VISUALIZAR ESSA TABLE É "HR_ADMIN",

QUE É UM ROLE COMPLETAMENTE INDEPENDENTE DE 

"SYSADMIN",




O QUE É TERŔIVEL (

    pq aí o SYSADMIN nao vai conseguir 

    visualizar/manipular essa table...
)












--> OU SEJA, FICAMOS FORCADOS A LOGGAR COM 1 CONTA 


COM ROLE DE "HR_ADMIN"...










--> tudo isso aconteceu PQ 

TRANSFERIMOS A OWNERSHIP LÁ PARA 


O ROLE DE "HR_aDMIN",

com este código:






CREATE DATABASE HR_DB;
GRANT OWNERSHIP ON DATABASE HR_DB TO ROLE HR_ADMIN;
GRANT OWNERSHIP ON SCHEMA HR_DB.PUBLIC TO ROLE HR_ADMIN;












--> MAS, COMO SYSADMIN, NAO TEMOS OWNERSHIP/NAO 

HERDAMOS 


ESSE ROLE DE "hR_ADMIN" (pq deixamos de definir 


QUE O SYSADMIN É HIERARQUICAMENTE SUPERIOR A ESSE ROLE
),


o que nos deixa com 1 grande problema...











--> A ÚNICA MANEIRA DE RECUPERAR O ACESSO 

A ESSA DATABASE 



É _ ENTRAR NA CONTA DE "SECURITY ADMIN" OU 


"ACCOUNTADMIN" 




E DEFINIR QUE __ O ROLE DE "HR_ADMIN"



DEVE SE SUBMETER AO ROLE DE "SYSADMIN"...














CASO CONTRÁRIO, FICAMOS SEM ACESSO A ESSA DATABASE...












--> TUDO ISSO DEIXA BEM DIFÍCIL O MANAGE DESSES OBJECTS,

PELO SYSADMIN,



SE _ NÓS NEM AO MENOS TEMOS ACESSO 



A ELES, QUANDO TRANSFERIMOS A OWNERSHIP 



PARA O ROLE QUE DEVE MANAGEAR ESSA DATABASE,

ISSO SE NAO 

FIZERMOS "ASSIGN" DE ESSES CUSTOM ROLES 

AO 

ROLE DE SYSADMIN....















CERTO...





MAS AGORA QUE JÁ CRIAMOS TODOS ESSES OBJECTS 

E JÁ CONFERIMOS 

OWNERSHIPS E PRIVILEGES A ESSES OBJECTS,

DEVEMOS 
ESTUDAR 

OS __ CUSTOM ___ ROLES 

E AS COISAS QUE PODEMOS FAZER COM ELES...