-- O MANAGE DE ARQUIVOS JSON,
-- COM STORAGE INTEGRATION OBJECTS,
-- NO SNOWFLAKE,
-- É UM POUCO MAIS COMPLICADO DO QUE O MANAGE DE ARQUIVOS CSV....- _ > MAS SEREMOS CAPAZES DE _ HANDLAR ISSO...











-- Let's tame the JSON file 


-- first, query the file from an S3 bucket





-- first, we need to TO CREATE THIS 
--""json_folder" stage... 
-- but before that, we need to adjust the file format object 
-- and storage integration object...



-- CREATE FILE_FORMAT OBJECT:
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.json_format_2
    TYPE=JSON;
    




-- CREATE STORAGE INTEGRATION OBJECT:
CREATE OR REPLACE STORAGE INTEGRATION EXAMPLE_JSON_S3
    TYPE=EXTERNAL_STAGE
    STORAGE_PROVIDER=S3
    ENABLED=TRUE
    STORAGE_AWS_ROLE_ARN= 'arn:aws:iam::269021562924:role/snowflake_s3_access_role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-test-masterclass-bucket/JSON/')
    COMMENT='this is a test bucket, in my aws account';





-- CREATE STAGE OBJECT (and attach file format and storage integration objects)
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.EXAMPLE_JSON_STAGE_S3
    url='s3://snowflake-test-masterclass-bucket/JSON/'
    FILE_FORMAT=(
    FORMAT_NAME=MANAGE_DB.FILE_FORMATS.json_format_2
    )
    STORAGE_INTEGRATION=EXAMPLE_JSON_S3;



-- describe integration.
DESC INTEGRATION S3_EXAMPLE_INTEGRATION;





-- query data (json data) FROM S3 BUCKET.
SELECT * FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3;



DESC INTEGRATION S3_EXAMPLE_INTEGRATION;







-- FORMAT DATA (json data) INTO APPROPRIATE COLUMN DATA, in new table...




-- TO_DATE($1:reviewTime::STRING, 'MM DD, YYYY')

-- funcionou
CREATE OR REPLACE TABLE MANAGE_DB.public.example_json_table AS
    SELECT 
        $1:asin::STRING as asin,
        $1:overall::INT as overall,
        $1:reviewText::STRING as review_text,
        TO_DATE($1:reviewTime::STRING, 'MM DD, YYYY') as review_date,
        $1:reviewerID::STRING as reviewer_id,
        $1:reviewerName::STRING as reviewer_name,
        $1:summary::STRING as summary,
        (DATE($1:unixReviewTime)::STRING) as review_time
        FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3;
        


SELECT * FROM MANAGE_DB.PUBLIC.example_json_table;









--> MAS ALGUMAS COISAS AINDA NAO CONSERTEI...





-- o field de ""helpful"" 

-- AINDA NAO FOI CONSERTADO:





--   "helpful": [     0,     0   ], 






  --> para isso, preciso da function de FLATTEN()



--   COM A FUNCTION DE table()...


--   -> UM EXEMPLO É ESTE:




--   SELECT RAW_FILE:first_name::STRING AS First_name,
--         f.value:language::STRING as Language,
--         f.value:level::STRING as Level_Spoken
--         FROM OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f; ---- EIS O GRANDE DIFERENCIAL.








-- nossa mesma query, daquela forma, fica:







CREATE OR REPLACE TABLE MANAGE_DB.public.example_json_table AS
    SELECT 
        $1:asin::STRING as asin,
        $1:overall::INT as overall,
        $1:helpful:: as helpful
        $1:reviewText::STRING as review_text,
        TO_DATE($1:reviewTime::STRING, 'MM DD, YYYY') as review_date,
        $1:reviewerID::STRING as reviewer_id,
        $1:reviewerName::STRING as reviewer_name,
        $1:summary::STRING as summary,
        (DATE($1:unixReviewTime)::STRING) as review_time
        FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3;
        


SELECT * FROM MANAGE_DB.PUBLIC.example_json_table;








-- na verdade, 



-- "helpful"


-- é sempre composto por 2 values.... mas ainda assim, 

-- é melhor 


-- usar o ""flatten()""

-- com o table()....



-- tipo assim:




-- sem o uso de flatten, com indexadores para os arrays:
CREATE OR REPLACE TABLE MANAGE_DB.public.example_json_table AS
    SELECT 
        $1:asin::STRING as asin,
        $1:overall::INT as overall,
        $1:reviewText::STRING as review_text,
        $1:helpful[0]::INT as helpful_1,
        $1:helpful[1]::INT as helpful_2,
        TO_DATE($1:reviewTime::STRING, 'MM DD, YYYY') as review_date,
        $1:reviewerID::STRING as reviewer_id,
        $1:reviewerName::STRING as reviewer_name,
        $1:summary::STRING as summary,
        (DATE($1:unixReviewTime)::STRING) as review_time
        FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3;











-- com o uso de flatten, e sem  indexadores para os arrays (necessário cross join):
CREATE OR REPLACE TABLE MANAGE_DB.public.example_json_table AS
    SELECT 
        stage.$1:asin::STRING as asin,
        stage.$1:overall::INT as overall,
        stage.$1:reviewText::STRING as review_text,
        helpful_array.value::INT as helpful,
        TO_DATE(stage.$1:reviewTime::STRING, 'MM DD, YYYY') as review_date,
        stage.$1:reviewerID::STRING as reviewer_id,
        stage.$1:reviewerName::STRING as reviewer_name,
        stage.$1:summary::STRING as summary,
        DATE(stage.$1:unixReviewTime::INT) as review_time
    FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3 as stage
CROSS JOIN LATERAL FLATTEN(input => stage.$1:helpful) AS helpful_array;











-- o mesmo código, mas etapa por etapa, sem rodar tudo em 1 statement só (de create table):





-- introduce columns
SELECT 
$1:asin,
$1:helpful,
$1:overall,
$1:reviewText,
$1:reviewTime,
$1:reviewerID,
$1:reviewerName,
$1:summary,
$1:unixReviewTime
FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3






-- MAS O PROFESSOR DIZ QUE PODEMOS FORMATAR UM MONTE...










--> A PRIMEIRA COISA UQE ELE FAZ É CONVERTER 1 MONTE DE COISAS EM STRINGS,
-- COM ESTE CÓDIGO:





-- SELECT 
-- $1:asin::STRING as asin,
-- $1:helpful as helpful,
-- $1:overall as overall,
-- $1:reviewText::STRING as review_text,
-- $1:reviewTime::STRING as review_time,
-- $1:reviewerID::STRING as reviewer_id,
-- $1:reviewerName::STRING as reviewer_name,
-- $1:summary::STRING,
-- $1:unixReviewTime
-- FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3








--> ELE ENTAO FORMATA AINDA MAIS,

-- USANDO 



-- A FUNCTION DE 


-- ""DATE()'"",


-- tipo assim:







-- SELECT 
-- $1:asin::STRING as asin,
-- $1:helpful as helpful,
-- $1:overall as overall,
-- $1:reviewText::STRING as review_text,
-- $1:reviewTime::STRING as review_time,
-- $1:reviewerID::STRING as reviewer_id,
-- $1:reviewerName::STRING as reviewer_name,
-- $1:summary::STRING,
-- DATE($1:unixReviewTime::INT) as review_time
-- FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3















-- mas entao o professor fala da column de 

-- ""review_time"" estragada (
--     com '02 28, 2014' --> CONVERTI 

--     ISSO COM MEU PRÓPRIO CÓDIGO...




-- )










-- MEU PRÓPRIO CÓDIGO  FOI ESTE:



--         TO_DATE($1:reviewTime::STRING, 'MM DD, YYYY') as review_date,













-- E FUNCIONOU...














-- PARA TERMINAR, O PROFESSOR CRIA A TABLE 


-- EM QUE VAMOS COPIAR TUDO,

-- COM ESTE COMANDO:






CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.reviews (
    asin STRING,
    helpful STRING,
    overall STRING,
    review_text STRING, 
    review_time STRING,
    reviewer_id STRING,
    reviewer_name STRING,
    summary STRING,
    unix_review_time DATE
);







-- E DEPOIS RODA O COMANDO DE COPY, ASSIM:


COPY INTO OUR_FIRST_DB.PUBLIC.reviews FROM (
   SELECT 
        stage.$1:asin::STRING as asin,
        stage.$1:overall::INT as overall,
        stage.$1:reviewText::STRING as review_text,
        stage.$1:helpful::STRING as helpful,
        TO_DATE(stage.$1:reviewTime::STRING, 'MM DD, YYYY') as review_date,
        stage.$1:reviewerID::STRING as reviewer_id,
        stage.$1:reviewerName::STRING as reviewer_name,
        stage.$1:summary::STRING as summary,
        (DATE(stage.$1:unixReviewTime)::STRING) as review_time
    FROM @MANAGE_DB.STAGES.EXAMPLE_JSON_STAGE_S3 as stage
)
