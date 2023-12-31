
-- RESUMO:





-- 1) CRIAMOS AS VIRTUAL WAREHOUSES DEDICADAS... (com os tamanhos apropriadas)






-- 2) CRIAMOS OS __ ROLES__ PARA OS USER GROUPS....





-- 3) CONFERIMOS (GRANT) PERMISSION DE USAGE 
-- A ESSES ROLES.... 





-- 4) ASSIGNAMOS (GRANT) esses ROLES __ AOS USERS QUE 

-- QUEREMOS QUE TENHAM ESSE ACESSO/PERMISSIONS...






-- CREATE VIRTUAL WAREHOUSE FOR DIFFERENT USER GROUPS IN A COMPANY.


-- GROUP 1 ---- DATA SCIENTISTS
CREATE WAREHOUSE SCIENCE_WH
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE='STANDARD'
AUTO_SUSPEND=300
AUTO_RESUME=TRUE
MIN_CLUSTER_COUNT=1
MAX_CLUSTER_COUNT=1
SCALING_POLICY='STANDARD';





-- GROUP2 ----- DATABASE ADMINS
CREATE WAREHOUSE ADMIN_WH
WITH WAREHOUSE_SIZE = 'XSMALL'
WAREHOUSE_TYPE='STANDARD'
AUTO_SUSPEND=300
AUTO_RESUME=TRUE
MIN_CLUSTER_COUNT=1
MAX_CLUSTER_COUNT=1
SCALING_POLICY='STANDARD';




-- MAS É CLARO QUE ISSO NAO É TUDO...

-- PRECISAMOS CRIAR TAMBÉM OS USERS... PARA SERMOS MAIS PRECISOS,

-- PRECISAMOS 
-- CRIAR OS ""USER ROLES"" ( com todas suas permissions e etc)...



--> E PRECISAMOS ASSIGNAR ESSAS WAREHOUSES A ESSES ROLES,

-- E 

-- A ESSES USERS...











-- TO CREATE ROLES AND GRANT PERMISSIONS, YOU NEED TO BE USING AN ACCOUNT WITH THE REQUIRED PRIVILEGES (such as ACCOUNTADMIN, for example)


-- Create role and GRANT PERMISSIONS for ROLES
CREATE ROLE DATA_SCIENTIST; -- to create a role, one must be a ACCOUNTADMIN or a SECURITYADMIN
GRANT USAGE ON WAREHOUSE SCIENCE_WH TO ROLE DATA_SCIENTIST; 
-- to assign a permission to a role, one must be a ACCOUNTADMIN or a SECURITYADMIN

CREATE ROLE DB_ADMIN
GRANT USAGE ON WAREHOUSE ADMIN_WH TO ROLE DB_ADMIN;








DROP ROLE DATA_SCIENTIST; -- só é possível DROPPAR 1 ROLE _ se ESTAMOS USANDO O ROLE QUE CRIOU ESSE ROLE, PARA INÍCIO DE CONVERSA (ou seja, securityadmin pode apenas droppar roles QUE ELE MESMO CRIOU... MAS O ACCOUNTADMIN PODE DROPPAR QUAISQUER ROLES CRIADOS PELO SECURITY ADMIN, no entanto)









-- OK... MAS __ ROLES__ NAO _ SAO __ A MESMA COISA QUE USERS_... PRECISAMOS DE USERS, PARA PODERMOS RODAR QUERIES...









-- OK... MAS __ ROLES__ NAO _ SAO __ 
-- A MESMA COISA QUE USERS_... PRECISAMOS DE USERS,
--  PARA PODERMOS RODAR QUERIES...




--> PARA ISSO, PRECISAMOS DEFINIR OS _ LOGINS__ 

-- DESSES USERS,

-- E ENTAO 

-- ASSIGNAR 


-- USERS A ESSES ROLES (ou os roles aos users, mesma coisa)....









-- SETTING UP USERS, AND THEN ASSIGNING ROLES TO THEM....


-- creating USERS 
CREATE USER DS1 PASSWORD = 'DS1' LOGIN_NAME = 'DS1' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'SCIENCE_WH' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS2 PASSWORD = 'DS2' LOGIN_NAME = 'DS2' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'SCIENCE_WH' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS3 PASSWORD = 'DS3' LOGIN_NAME = 'DS3' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'SCIENCE_WH' MUST_CHANGE_PASSWORD = FALSE;



-- assigning roles to users
GRANT ROLE DATA_SCIENTIST TO USER DS1;
GRANT ROLE DATA_SCIENTIST TO USER DS2;
GRANT ROLE DATA_SCIENTIST TO USER DS3;






-- CREATE USER FOR DB ADMINS 
CREATE USER DBA1 PASSWORD = 'DBA1' LOGIN_NAME= 'DBA1' DEFAULT_ROLE='DB_ADMIN' DEFAULT_WAREHOUSE='ADMIN_WH' MUST_CHANGE_PASSWORD=FALSE;
CREATE USER DBA2 PASSWORD = 'DBA2' LOGIN_NAME= 'DBA2' DEFAULT_ROLE='DB_ADMIN' DEFAULT_WAREHOUSE='ADMIN_WH' MUST_CHANGE_PASSWORD=FALSE;




-- GRANT ROLE TO DB ADMINS 
GRANT ROLE DB_ADMIN TO USER DBA1;
GRANT ROLE DB_ADMIN TO USER DBA2;




SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.USERS; //nothingnothings e snowflake
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES; //é possível ver o data_scientist e o db_admin

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES;







-- se logamos nessa outra conta,

-- "DBA1" (que tem role de ""DB_ADMIN""),




-- VEREMOS QUE 

-- SÓ SERÁ 


-- POSSÍVEL




-- MANIPULAR A WAREHOUSE ""ADMIN_WH"",




-- QUE FOI JUSTAMENTE A 


-- WAREHOUSE 




-- QUE ""ENTREGAMOS"" A ESSE TIPO DE USER...







--  e realmente ficamos com 1 monte de features limitadas, nessa conta...




-- E O PRÓPRIO ""DB_ADMIN"" NAO PODE FAZER DROP DE 1 WAREHOUSE, PQ ISSO SÓ É PERMITIDO A ROLES COM PERMISSSIONS 
-- MAIS ELEVADAS...







-- -> é claro que é possível ENTREGAR O ROLE DE ""ACCOUNTADMIN'"



-- A OUTROS USERS DE NOSSO APP...---> MAS ESSA NAO É UMA BOA PRÁTICA...



-- -> E PODEMOS COLOCAR MÚLTIPLOS ROLES EM 1 MESMO USER....