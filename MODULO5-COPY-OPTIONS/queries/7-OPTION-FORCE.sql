-- SINTAXE:


-- COPY INTO <table_name>
-- FROM @externalStage
-- FILES=('<file_name>', '<file_name2>')
-- FILE_FORMAT=(
--     FORMAT_NAME=xxxx
-- )
-- FORCE = TRUE | FALSE;



-- com essa OPTION SETTADA COMO TRUE,




-- PODEMOS DIZER QUE 



-- 1 FILE QUE FOI 

-- CARREGADA ___ANTERIORMENTE__, E QUE NAO MUDOU DESDE ENTAO,

-- PODERÁ/DEVERÁ 


-- __SER CARREGADA NOVAMENTE, ""MESMO ASSIM""....



-- --> ou seja, 

-- fazemos overwrite do comportamento do 
-- snowflake que evita o insert repetido de arquivos identicos 

-- nas databases manageadas por ele....









-- -> É CLARO QUE SE HABILITARMOS ESSA OPTION,




-- PODEMOS FICAR COM _ DUPLICATED _ DATA _ NA NOSSA TABLE...















----- FORCE= TRUE | FALSE -----








CREATE OR REPLACE TABLE COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);



--PREPARE STAGE OBJECT 

CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';





LIST @COPY_DB.PUBLIC.aws_stage_copy;





--  O DEFAULT É ""FORCE=FALSE"" --> QUER DIZER QUE INSERTS DE ARQUIVOS QUE NAO MUDARAM NADA (csvs iguais) NAO VAO OCORRER, PARA EVITAR DUPLICATE DATA...

-- como resultado, lemos ""COPY EXECUTED WITH 0 FILES PROCESSED""...
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy 
    file_format=(
        type=csv,
        field_delimiter=',',
        skip_header=1
    )
    pattern='.*Order.*';
    






--  A OPTION ALTERNATIVA É ""FORCE=TRUE"", que vai justamente inserir essas entries mesmo assim, mesmo o arquivo csv nao tendo mudado nada...
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy 
    file_format=(
        type=csv,
        field_delimiter=',',
        skip_header=1
    )
    pattern='.*Order.*'
    FORCE=TRUE;