


-- A COPY OPTION DE ""SIZE_LIMIT" --> ESPECIFICAMOS 1 LIMITE, EM BYTES, DO MAXIMUM SIZE DE DATA QUE DEVE SER CARREGADO POR ESSE COMANDO DE COPY..









-- EX:





-- COPY INTO <table_name>
-- FROM externalStage
-- FILES=('exemplo1.csv', 'exemplo2.csv')
-- FILE_FORMAT=<file_format_name>
-- SIZE_LIMIT= num 










--> PERCEBA QUE __ SEMPRE _ 1 FILE 


-- SERÁ CARREGADA, A PRIMEIRA FILE,



-- NAO INTERESSA O SIZE LIMIT QUE VC TENHA 
-- DEFINIDO...












    COPY INTO COPY_DB.PUBLIC.ORDERS
        FROM @aws_Stage_copy
        FILE_FORMAT=(type=csv, 
        field_delimiter=',',
        skip_header=1)
        pattern='.*Order.*'
        SIZE_LIMIT=20000;













-- -> RODAMOS ISSO AÍ...






-- SIZE_LIMIIT --> o tamanho definido 
-- como limite diz respeito a TODAS AS FILES, 
-- COMBINADAS (e nao file-por-file )





--> QUER DIZER QUE ESSE LIMIT SERÁ EXCEDIDO 

-- JÁ NA PRIMEIRA FILE...







--> COMO O LIMIT TERÁ SIDO EXCEDIDO JÁ NA PRIMEIRA FILE,

-- O RESTO DAS FILES ( o segundo arquivo)

-- NAO SERÁ CARREGADO....




-- -> É POR ISSO QUE APENAS A PRIMEIRA FILE FOI CARREGADA...




-- 1) FILE FOI CARREGADA 



-- 2) LIMITE FOI EXCEDIDO NO LOAD DA PRIMEIRA FILE 



-- 3) SEGUNDA FILE JÁ NAO SERÁ CARREGADA (E NENHUMA FILE POSTERIOR, TAMBÉM)...








-- o professor entao 


-- resetta a table,

-- PARA AÍ TESTAR COM 





-- 60.000....












-- ex:




    COPY INTO COPY_DB.PUBLIC.ORDERS
        FROM @aws_Stage_copy
        FILE_FORMAT=(type=csv, 
        field_delimiter=',',
        skip_header=1)
        pattern='.*Order.*'
        SIZE_LIMIT=60000;










-- --> PQ 60 MIL NAO SERÁ ATINGIDO PELA PRIMEIRA FILE...








-- -> O LIMITE SERÁ ATINGIDO COM A SEGUNDA FILE,


-- MAS ELA AINDA SERÁ CARREGADA (se tivéssemos 1 terceira file, ELA, SIM,
-- NAO SERIA CARREGADA)