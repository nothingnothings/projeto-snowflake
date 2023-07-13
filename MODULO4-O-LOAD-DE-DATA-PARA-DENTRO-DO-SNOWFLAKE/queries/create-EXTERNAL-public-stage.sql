--DATABASE TO MANAGE STAGE OBJECTS, FILEFORMATS, ETC...

CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;



-- EXEMPLO DE CRIACAO DE STAGE

-- precisamos do fully qualified name... ao final, colocamos
-- o nome do nosso stage (aws_stage), que queremos criar.
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
  -- url='s3://bucketsnowflakes3'
  -- credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');



DESC STAGE MANAGE_DB.external_stages.aws_stage;




ALTER STAGE aws_stage 
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='sasdxas')



DESC STAGE MANAGE_DB.external_stages.aws_stage;