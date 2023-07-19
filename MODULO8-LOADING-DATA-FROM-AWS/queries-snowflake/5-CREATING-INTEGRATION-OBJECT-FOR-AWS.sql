-- NESTA LECTURE ,



-- VAMOS CRIAR O INTEGRATION OBJECT QUE 


-- SERÁ USADO PARA ARMAZENAR AS CREDENTIALS 


-- __ E __ TODO O ACCESS INFORMATION 



-- _ DO __ SNOWFLAKE __ À CONTA AWS... (
--     TUDO PARA QUE CONSIGAMOS FETCHEAR DATA 

--     DE NOSSOS S3 BUCKETS, NO AWS...
-- ).









--Create storage integration object (to retrieve from an aws account's s3 bucket)

CREATE OR REPLACE STORAGE INTEGRATION S3_EXAMPLE_INTEGRATION
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED=TRUE
    STORAGE_AWS_ROLE_ARN= ''
    STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/', 
    '<cloud>://<bucket>/<path>/')
    COMMENT='<string_literal>';









-- ESSA É A MANEIRA RECOMENDADA DE CRIAR E USAR 1 CONNECTION.....


-- O CREATE DE 1 CONNECTION À AWS (e outros providers) GERALMENTE É FEITA POR MEIO 

-- DESSES ""INTEGRATION OBJECTS""


-- --> MAIS TARDE, SERÁ POSSÍVEL USAR __ ESSES INTEGRATION OBJECTS 

-- NOS __NOSSOS STAGES_....







--> O TYPE --> DEVE SER DE TIPO EXTERNAL_STAGE...


--> STORAGE_PROVIDER --> NO NOSSO CASO, QUEREMOS S3...


--> ENABLED ---> SIGNIFICA SE DESEJAMOS __ SE _ ESSE INTEGRATION OBJECT FIQUE ENABLED OU NAO...   
--             se estiver settado como false, ele nao é ativado....






-- AÍ TEMOS OS 2 VALUES MAIS IMPORTANTES:



-- --> STORAGE_AWS_ROLE_ARN='' ------> DENTRO DESSE SLOT,
--                                     DEVEMOS COLOCAR UM ""ARN""... (amazon resource names)


--                                     --> NO CASO, DEVEMOS IR ATÉ 
--                                     A PÁGINA DE ""IAM""... --> NESSA PAGE,
--                                     DEVEMOS 

--                                     IR ATÉ ""ROLES"",
--                                     E AÍ DEVEMOS SELECIONAR O ROLE 

--                                     DO SNOWFLAKE  (role com permission
--                                     de full access ao s3)





-- FICA TIPO ASSIM:





-- arn:aws:iam::269021562924:role/snowflake_s3_access_role









-- E, NA NOSSA QUERY, FICA ASSIM:




CREATE OR REPLACE STORAGE INTEGRATION S3_EXAMPLE_INTEGRATION
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED=TRUE
    STORAGE_AWS_ROLE_ARN= 'arn:aws:iam::269021562924:role/snowflake_s3_access_role'
    STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/', 
    '<cloud>://<bucket>/<path>/')
    COMMENT='<string_literal>';






-- A ÚLTIMA COISA QUE PRECISAMOS FAZER É PROVIDENCIAR 

-- """"STORAGE_ALLOWED_LOCATIONS"""""" --> OU SEJA,



-- TEMOS QUE PROVIDENCIAR 


-- ""s3://""



-- E DEPOIS O BUCKET e o path dentro do bucket,

-- TIPO ASSIM:




CREATE OR REPLACE STORAGE INTEGRATION S3_EXAMPLE_INTEGRATION
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED=TRUE
    STORAGE_AWS_ROLE_ARN= 'arn:aws:iam::269021562924:role/snowflake_s3_access_role'
    STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/', 
    '<cloud>://<bucket>/<path>/')
    COMMENT='<string_literal>';




















--> E PODEMOS USAR MÚLTIPLOS BUCKETS, É CLARO...




-- AS URLS SAO:


-- s3://snowflake-test-masterclass-bucket/CSV/




-- E 


-- s3://snowflake-test-masterclass-bucket/JSON/




-- E



-- s3://snowflake-test-masterclass-bucket/DIFFERENT_FILES/











-- POR ISSO, FICA ASSIM:





CREATE OR REPLACE STORAGE INTEGRATION S3_EXAMPLE_INTEGRATION
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED=TRUE
    STORAGE_AWS_ROLE_ARN= 'arn:aws:iam::269021562924:role/snowflake_s3_access_role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-test-masterclass-bucket/CSV/', 
    's3://snowflake-test-masterclass-bucket/JSON/', 's3://snowflake-test-masterclass-bucket/DIFFERENT_FILES/')
    COMMENT='<string_literal>';





-- POR FIM, PODEMOS DESCREVER ESSE INTEGRATION OBJECT,

-- COM ESTE COMANDO:



-- See storage integration properties to fetch external_id so we can update it in S3.

-- PRECISAMOS DESSE "external_id", POIS ELE DEVE SER COLOCADO LÁ NAS OPTIONS DO ROLE DA AWS, NO IAM, EM ""external_id""...

DESC INTEGRATION S3_EXAMPLE_INTEGRATION;









NA VERDADE, AO DESCREVERMOS ESSE OBJECT 

DE ""STORAGE INTEGRATION"",


ficamos com estes values:










-- ENABLED --> TRUE 



-- STORAGE_PROVIDER --> S3 



-- STORAGE_ALLOWED_LOCATIONS --> AS URLS DOS NOSSOS BUCKETS 



-- STORAGE_BLOCKED_LOCATIONS --> VAZIO 





-- STORAGE_AWS_IAM_USER_ARN -->  SUPER IMPORTANTE --> É ALGO COMO 
--                                             arn:aws:iam:123123213231231 

    



-- STORAGE_AWS_ROLE_ARN --> nao tao importante --> arn:aws:iam:1231312312




-- STORAGE_AWS_EXTERNAL_ID --> SUPER IMPORTANTE --> algo como
--                                                 QNA123123_SFCRole=2_1221dasdazxaws











-- A PRIMEIRA COISA QUE O PROFESSOR PEGA É 



-- STORAGE_AWS_IAM_USER_ARN...

                                




-- --> ESSE VALUE É IMPORTANTE... O MEU FICOU TIPO 


-- arn:aws:iam::269021562924:role/snowflake_s3_access_role












-- -> COM ESSE VALUE,


-- NAVEGAMOS 

-- ATÉ O MANAGEMENT CONSOLE DO AWS...







-- --> ENTRAMOS NO IAM,


-- E ENTAO 



-- EM ROLE...







-- DENTRO DO ROLE DO SNOWFLAKE,


-- ENTRAMOS EM "TRUST RELATIONSHIPS""....








-- --> EDITAMOS ESSA TRUST RELATIONSHIP...






-- --> O QUE DEVEMOS FAZER, AGORA, É EDITAR AQUELE 

-- DOCUMENTO JSON:










-- temos esta string:


-- arn:aws:iam::269021562924:role/snowflake_s3_access_role


-- --> DEVEMOS COLOCÁ-LA NA KEY DE "AWS",  dentro de 
-- ""Principal"":











-- EX:






-- {
-- 	"Version": "2012-10-17",
-- 	"Statement": [
-- 		{
-- 			"Effect": "Allow",
-- 			"Principal": {
-- 				"AWS": "arn:aws:iam::269021562924:root"
-- 			},
-- 			"Action": "sts:AssumeRole",
-- 			"Condition": {
-- 				"StringEquals": {
-- 					"sts:ExternalId": "00000"
-- 				}
-- 			}
-- 		}
-- 	]
-- }









-- OK... SUBSTITUÍMOS O AWS,
-- TIPO ASSIM:









-- {
-- 	"Version": "2012-10-17",
-- 	"Statement": [
-- 		{
-- 			"Effect": "Allow",
-- 			"Principal": {
-- 				"AWS": "arn:aws:iam::269021562924:role/snowflake_s3_access_role"
-- 			},
-- 			"Action": "sts:AssumeRole",
-- 			"Condition": {
-- 				"StringEquals": {
-- 					"sts:ExternalId": "00000"
-- 				}
-- 			}
-- 		}
-- 	]
-- }




-- ----------------------------------












-- CERTO.... POR FIM,

-- NAQUELE SLOT DE ""sts:ExternalId",





-- DEVEMOS 

-- COLOCAR 
-- O EXTERNAL 


-- ID DO FIELD DE 



-- """""
-- STORAGE_AWS_EXTERNAL_ID"""",




-- LÁ NO STORAGE INTEGRATION OBJECT,


-- QUE CRIAMOS NO SNOWFLAKE...














-- TIPO ASSIM:








-- {
-- 	"Version": "2012-10-17",
-- 	"Statement": [
-- 		{
-- 			"Effect": "Allow",
-- 			"Principal": {
-- 				"AWS": "arn:aws:iam::269021562924:role/snowflake_s3_access_role"
-- 			},
-- 			"Action": "sts:AssumeRole",
-- 			"Condition": {
-- 				"StringEquals": {
-- 					"sts:ExternalId": "BHB55148_SFCRole=2_ekhvS3FpZsF5eJ6/ZKFdQ+GsjGg="
-- 				}
-- 			}
-- 		}
-- 	]




-- TIPO ASSIM:








-- {
-- 	"Version": "2012-10-17",
-- 	"Statement": [
-- 		{
-- 			"Effect": "Allow",
-- 			"Principal": {
-- 				"AWS": "arn:aws:iam::269021562924:role/snowflake_s3_access_role"
-- 			},
-- 			"Action": "sts:AssumeRole",
-- 			"Condition": {
-- 				"StringEquals": {
-- 					"sts:ExternalId": "BHB55148_SFCRole=2_ekhvS3FpZsF5eJ6/ZKFdQ+GsjGg="
-- 				}
-- 			}
-- 		}
-- 	]
-- }





-- --------------------------







-- CERTO...





-- FEITO ISSO,





-- TEREMOS CONFIGURADO ESSE ROLE, NO AWS, CORRETAMENTE (
--     IAM user configurado corretamente...
-- )















-- CERTO...






-- COM ISSO, PERCEBEMOS QUE TRUSTED ENTITIES do IAM, no aws, AGORA TEM 


-- ESSES VALUES DO INTEGRATION OBJECT (

--     STORAGE_AWS_IAM_USER_ARN 

--     E 

--     STORAGE_AWS_EXTERNAL_ID

-- )








-- com isso,

-- agora 


-- ESTAMOS PRONTOS PARA CARREGAR A DATA,

-- USANDO 


-- ESSA SECURE CONNECTION COM NOSSO INTEGRATION OBJECT...











-- COMO FAREMOS ISSO, VEREMOS NA PRÓXIMA AULA...