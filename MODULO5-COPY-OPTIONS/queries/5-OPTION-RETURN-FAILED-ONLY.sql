


-- OUTRA OPTION DE COPY, SIMPLES PORÉM ÚTIL:

-- RETURN_FAILED_ONLY...

-- ELA ESPECIFICA _ SE _ DEVEMOS _ RETORNAR _ APENAS _ AS FILES_ QUE FALHARAM A CARREGAR, NO STATEMENT RESULT...

-- SINTAXE:

-- COPY INTO <table_name>
-- FROM @externalStage
-- FILES=('<file_name>', '<file_name2>')
-- FILE_FORMAT=(
--     FORMAT_NAME=xxxx
-- )
-- RETURN_FAILED_ONLY= TRUE | FALSE   (true ou false);



-- EX:
COPY INTO COPY_DB.PUBLIC.ORDERS 
    FROM @aws_stage_copy
    file_format=(
        type=csv,
        field_delimiter=',',
        skip_header=1
    )
    pattern='.*Order.*'
    RETURN_FAILED_ONLY = TRUE;














-- se usamos essa copy option,

-- ISSO __ VAI, EM 1 GIVEN COPY COMMAND,

-- APENAS 

-- MOSTRAR 

-- AS FILES 

-- QUE 

-- __FORAM _ CARREGADAS _ COM ERRORS....











-- -> o value DEFAULT dessa option é __ FALSE_...



--> ESSA OPTION GERALMENTE SÓ FAZ SENTIDO 

-- QUANDO É USADA 




-- JUNTO DA OPTION DE ""ON_ERROR=CONTINUE"",









-- ex:






COPY INTO COPY_DB.PUBLIC.ORDERS 
    FROM @aws_stage_copy
    file_format=(
        type=csv,
        field_delimiter=',',
        skip_header=1
    )
    pattern='.*Order.*'
    ON_ERROR=CONTINUE
    RETURN_FAILED_ONLY = TRUE;






-- PQ AÍ 


-- __O SNOWFLAKE VAI _ IGNORAR 


-- O ERROR,

-- E AÍ 



-- VEREMOS 



-- ALGUMAS FILES QUE FORAM CARREGADAS APENAS PARCIALMENTE,


-- E ALGUMAS FILES QUE FORAM CARREGADAS 
-- COMPLETAMENTE...













--> AS FILES QUE FORAM _ CARREGADAS COM SUCESSO,

-- COMPLETAMENTE, FICARAO COMO 

-- "-" (blanks).... JÁ AS FILES QUE 

-- DERAM ERRO 


-- VAO APARECER COM SEUS NOMES DE VERDADE (
--     com isso, podemos focar exatamente nas files que 
--     tiveram alguns errors....
-- )














-- ESSE COMANDO É ÚTIL EM CASOS EM QUE QUEREMOS FOCAR APENAS 

-- NAS FILES QUE TIEVRAM ERRORS....