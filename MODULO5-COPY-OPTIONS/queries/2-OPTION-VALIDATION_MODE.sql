


-- COM A OPTION VALIDATION_MODE, VERIFICAMOS E VALIDAMOS O PROCESSO DE COPY, SEM COPIAR NENHUMA DATA...






-- FORMATO:




    COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE=XXXX










-- PRIMEIRO EXEMPLO:



   COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE = RETURN_n_ROWS;







  COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE = RETURN_ERRORS;





    -- COM ISSO, SE ACONTECEREM QUAISQUER ERRORS 

    -- DURANTE ESSE COPY PROCESS,




    -- O SNOWFLAKE VAI NOS AVISAR DISSO,

    -- E VAI RETORNAR 1 LISTA DOS ERRORS OCORRIDOS...





   COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE = RETURN_10_ROWS;



--  A OUTRA OPTION,




-- "return_n_rows",




-- COM ISSO, PODEMOS ESPECIFICAR 

-- O NÚMERO 


-- DE ___ROWS __ QUE DEVEM SER RETORNADOS,


-- CASO NENHUM ERRO OCORRA...




--> SE QUISERMOS TER A FORMA COMPLETA DESSA VALIDATION,

PODEMOS ESCREVER ASSIM:






 COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE = RETURN_10_ROWS | RETURN ERRORS;













-- COM ISSO, VAMOS RETORNAR 10 ROWS SE TIVERMOS SUCESSO NO COPY,


-- E _ VAMOS RETORNAR ERRORS, SE TIVERMOS QUALQUER ERROR 

-- DURANTE O COPY...























--> SE QUISERMOS TER A FORMA COMPLETA DESSA VALIDATION,

-- PODEMOS ESCREVER ASSIM:






 COPY INTO <table_name>
    FROM @externalStage
    FILES=('Exemplo1.csv', 'Exemplo2.csv')
    FILE_FORMAT=(FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    VALIDATION_MODE = RETURN_10_ROWS | RETURN ERRORS;













-- COM ISSO, VAMOS RETORNAR 10 ROWS SE TIVERMOS SUCESSO NO COPY,


-- E _ VAMOS RETORNAR ERRORS, SE TIVERMOS QUALQUER ERROR 

-- DURANTE O COPY...