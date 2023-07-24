









-- se queremos COMPARTILHAR DATA 

-- COM 1 COMPANHIA EXTERNA,

-- É BEM COMUM QUE ESSA COMPANHIA EXTERNA 



-- TERÁ 


-- __ MÚLTIPLOS USERS... -->  POR ISSO É BOM SABER 



-- COMO PODEMOS 
-- SETTAR 

-- ESSE 
-- "ACESSO MULTI-FACETADO",


-- DENTRO DA READER ACCOUNT QUE SERÁ USADA 

-- PELA OUTRA CONTA...








--> OK, MAS COMO PODEMOS ADICIONAR USERS AO NOSSO SHARE,

-- DENTRO DESSA READER ACCOUNT?






-- se queremos COMPARTILHAR DATA 

-- COM 1 COMPANHIA EXTERNA,

-- É BEM COMUM QUE ESSA COMPANHIA EXTERNA 



-- TERÁ 


-- __ MÚLTIPLOS USERS... -->  POR ISSO É BOM SABER 



-- COMO PODEMOS 
-- SETTAR 

-- ESSE 
-- "ACESSO MULTI-FACETADO",


-- DENTRO DA READER ACCOUNT QUE SERÁ USADA 

-- PELA OUTRA CONTA...








--> OK, MAS COMO PODEMOS ADICIONAR USERS AO NOSSO SHARE,

-- DENTRO DESSA READER ACCOUNT?







-- O PROFESSOR ESCREVE:







--- Create and Set Up Users --- 


-- CREATE USERS 
 CREATE or replace USER client_test  -- is not the user/login
 PASSWORD             = 'Client4321' -- password
 LOGIN_NAME           = 'client' -- "user/login"
 DISPLAY_NAME         = 'client test'
 FIRST_NAME           = 'client'
 LAST_NAME            = 'test'
 EMAIL                = 'exemplo@gmail.com'
 DEFAULT_ROLE         = sysadmin;


-- Grant USAGE ON WAREHOUSE 
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;



--> OK... 







-- AGORA O PROFESSOR 

-- NOS MOSTRA 





-- ""HOW TO GRANT __ PRIVILEGES __ ON A SHARED 

-- DATABASE, SHARED TO US/READER ACCOUNT, 

-- TO _ ADDITIONAL USERS, INSIDE OF THE READER ACCOUNT""...





---> O PROFESSOR ESCREVE 

GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO ROLE PUBLIC;


-- Granting privileges on a Shared Database for other users 
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO ROLE PUBLIC;


-- to login into that user (inside this reader account):

-- https://app.snowflake.com/wthzwsc/tech_joy_account


-- FAZEMOS ISSO JUSTAMENTE PARA QUE ESSE USER/ROLE 
-- CONSIGA FAZER QUERY NESSA DATABASE...



SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.USERS;


SHOW USERS;







-- quer dizer que para loggar dentro de 1 user 

-- específico,

-- dentro de 1 reader account, deve-se 


-- utilizar urls como esta:


-- https://app.snowflake.com/wthzwsc/tech_joy_account









-- e aí colocar o "login_name" 


-- e "password" que criamos para esse user,


-- DENTRO DA READER ACCOUNT.