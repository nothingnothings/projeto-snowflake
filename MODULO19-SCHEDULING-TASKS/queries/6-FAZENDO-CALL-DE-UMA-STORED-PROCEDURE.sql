



AGORA VEREMOS ALGO MAIS AVANCADO...








--> VEREMOS COMO PODEMOS "CALL" 


UMA STORED PROCEDURE...







"""PROCEDURE"""...











--> NAO FALAREMOS SOBRE COMO PROCEDURES 

FUNCIONAM EM GERAL,



E SIM 

VAMOS APENAS 


CRIAR 


UMA PEQUENA E SIMPLES STORED 


PROCEDURE...










O CÓDIGO É ESTE:








-- Create a STORED PROCEDURE -- 
USE TASK_DB;


SELECT * FROM CUSTOMERS;


CREATE OR REPLACE PROCEDURE CUSTOMERS_INSERT_PROCEDURE (CREATE_DATE varchar)
    RETURNS STRING NOT NULL 
    LANGUAGE JAVASCRIPT
    AS 
    $$
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
    $$;



CREATE OR REPLACE TASK CUSTOMER_TASK_PROCEDURE
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    AS CALL CUSTOMERS_INSERT_PROCEDURE(CURRENT_TIMESTAMP)























OK... MAS COMO ISSO FUNCIONA....









nessa table de customers,
temos 5 rows...

















AGORA QUEREMOS CRIAR NOSSA 
PEQUENA 


STORED PROCEDURE EXEMPLO...










O FORMATO DA STORED PROCEDURE É ASSIM:





CREATE OR REPLACE PROCEDURE <procedure_name> __VARIABLE__ 











--> OU SEJA,

VAMOS USAR __ 1 VARIÁVEL NESSA PROCEDURE (
    é quase como uma FUNCTION....
)





--> MAIS TARDE ESSE ARGUMENTO É PASSADO 


NA STORED PROCEDURE,


E ENTAO É UTILIZADO DENTRO DELA....




AÍ USAMOS AQUELE COMANDO SQL ESTRANHO,


ESTE AQUI:













    AS 
    $$
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
    $$;







-> O PROFESSOR EXPLICA QUE 

A SINTAXE DESSAS STORED PROCEDURES 


É PRATICAMENTE QUASE SEMPRE


A MESMA COISA...







--> TIPICAMENTE COLOCAMOS A LANGUAGE COMO 

"javascript",



E ENTAO DEFINIMOS QUE 


QUEREMOS __SEMPRE RETORNAR 


1 STRING (


    podemos definir "NOT NULL" como 

    1 constraint, no caso...
)












código comentado:
















-- Create a STORED PROCEDURE -- 
USE TASK_DB;


SELECT * FROM CUSTOMERS;


CREATE OR REPLACE PROCEDURE CUSTOMERS_INSERT_PROCEDURE 
(CREATE_DATE varchar) -- esta é a VARIABLE
    RETURNS STRING NOT NULL (tipo de data a ser retornada)
    LANGUAGE JAVASCRIPT -- definicao da language a ser usada (obrigatório. Geralmente é JS)
    AS  -- aqui embaixo, o comando sql a ser executado.
    $$ 
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
    $$;



CREATE OR REPLACE TASK CUSTOMER_TASK_PROCEDURE
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    AS CALL CUSTOMERS_INSERT_PROCEDURE(CURRENT_TIMESTAMP)






-------------------------------------









OK... MAS O QUE SIGNIFICA ESTA PARTE:







    $$ 
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
    $$;
















    - bem, definimos 1 variable como "INSERT INTO CUSTOMERS" e etc..




    -> vamos inserir algo apenas na column de "create_date"...




    -_> quanto ao "VALUES()", temos a marcacao 
    ":1" 



        ":1" SIGNIFICA NOSSA VARIÁVEL, O ARGUMENT 
        DE VALUE/NOME "CREATE_DATE", de type varchar,

        QUE ESTAREMOS PASSANDO 

        DENTRO DESSA EXPRESSAO...




E É EXATAMENTE ISSO QUE É ESPECIFICADO DENTRO 

DAQUELA "FUNCTION",


tipo assim:








    $$ 
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE] -- é usado para BINDAR O VALUE DE "CREATE_DATE"...
            });
        return "Successfully executed.";
    $$;







--> NAQUELA FUNCTION É ESPECIFICADa essa VARIÁVEL


dentro da key de "binds"...









quer dizer que esse "sql_command"

será executado,

e dentro dele passaremos esse value de ":1",

que é o value do CREATE_DATE passado como parameter, na verdade....












por fim temos o return,


que vai retornar aquela mensagem ali....










CERTO...



ESSA É NOSSA STORED PROCEDURE...








O PROFESSOR APENAS QUER NOS MOSTRAR 



COMO PODEMOS CHAMAR ESSA STORED PROCEDURE IN ANY GIVEN TASK...











O COMANDO É ESTE:




CREATE OR REPLACE TASK CUSTOMER_TASK_PROCEDURE
    WAREHOUSE = COMPUTE_WH
    SCHEDULE='1 MINUTE'
    AS 
    CALL CUSTOMERS_INSERT_PROCEDURE (CURRENT_TIMESTAMP);



















-> COM ISSO, ESSA 
PROCEDURE É SEMPRE CHAMADA COM 1 PARAM 
DINAMICO (CURRENT_TIMESTAMP),

DENTRO DESSA TASK AÍ...










-> PARA STARTAR ESSA TASK QUE RODA 

ESSA STORED PROCEDURE,



PRECISAMOS 

ESCREVER:










SHOW TASKS;



ALTER TASK CUSTOMER_TASK_PROCEDURE RESUME;