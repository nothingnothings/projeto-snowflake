




AGORA DAREMOS 1 OLHADA 

EM UMA TASK OPTION MT 

INTERESSANTE,


QUE 



É 



O SETUP DE CONDITIONS 


NAS NOSSAS TASKS...




----------------------











VEJA O SEGUINTE CÓDIGO:











------- TASK OPTION - WHERE - ------------------




-- Prepare Table 
CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID INT AUTOINCREMENT START = 1 INCREMENT == 1,
    FIRST_NAME VARCHAR(40) DEFAULT 'JENNIFER',
    CREATE_DATE DATE
);


-- Create Task (With condition)
CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK_WITH_CONDITION
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN 1=2 -- esta condition nunca será true, o que quer dizer que essa task NUNCA SERÁ EXECUTADA.
    AS 
    INSERT INTO CUSTOMERS (CREATE_DATE, FIRST_NAME)
    VALUES (CURRENT_TIMESTAMP, 'MIKE');





    --------------------------









QUANDO ESSA CONDITION 

FOR EVALUATED COMO TRUE,

NOSSA TASK 
SERÁ EXECUTADA (
    CASO CONTRÁRIO, CASO NAO SEJA 
    EVALUATED COMO TRUE,

    A TASK NAO É EXECUTADA.
)






















--> O PROFESSOR DESCREVE 

O EXEMPLO...








--> DEVEMOS DEFIINR A CONDITION 


__ ANTES DA DEFINICAO DO 

CONTEÚDO/SQL STATEMENT DA TASK...






-> 



WHEN (CONDICAO)...









--> DEVEMOS COLOCAR QUALQUER EXPRESSAO 

QUE SEJA EVALUATED COMO TRUE 
OU FALSE...










--> DEVEMOS CRIAR ESSA TASK,


PARA VER QUE ELA NUNCA SERÁ EXECUTADA...








-> COLOCAMOS 1 SEGUNDA TASK,
DESSA VEZ UMA TASK QUE SERÁ EVALUATED 

COMO TRUE(será executada):





-- Create Task 
CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK_WITH_CONDITION_2
    WAREHOUSE = COMPUTE_WH,
    SCHEDULE = '1 MINUTE',
    WHEN 1=1 -- sempre será true, o que quer dizer que essa task SEMPRE SERÁ EXECUTADA.
    AS 
    INSERT INTO CUSTOMERS (CREATE_DATE, FIRST_NAME) 
    VALUES (CURRENT_TIMESTAMP, 'Williams');



-------------------------











ok... 

quer dizer que a segunda 

task será executada,

e a primeira, nao...








DEVEMOS STARTAR ESSAS TASKS,
CLARO,

COM ESTE COMANDO:









ALTER TASK CUSTOMER_INSERT_TASK_WITH_CONDITION RESUME;
ALTER TASK CUSTOMER_INSERT_TASK_WITH_CONDITION_2 RESUME;

















COM ISSO, CONSTATAREMOS QUE 


NOSSA TABLE 

VAI 


TER RECORDS DE "Williams",


e nao "mike",









PQ __ APENAS A SEGUNDA CONDITION 


FOI/É SATISFEITA...









PODEMOS VER ISSO COM 1 SELECT:





SELECT * FROM CUSTOMERS;





DEPOIS PAUSAMOS 


ESSAS TASKS,



COM ISTO:



ALTER TASK CUSTOMER_INSERT_TASK_WITH_CONDITION SUSPEND;
ALTER TASK CUSTOMER_INSERT_TASK_WITH_CONDITION_2 SUSPEND;







----------------------









por fim, PODEMOS VISUALIZAR A 


HISTORY 


DESSAS TASKS,


COM ESTE COMANDO:







SELECT * FROM TABLE(information_schema.TASK_HISTORY())
ORDER BY SCHEDULED_TIME DESC;











--> NESSA HISTORY, É POSSÍVEL 

CONSTATAR QUE 



AQUELA TASK 


COM A CONDITION IMPOSSÍVEL 

ESTÁ SEMPRE COM 1 

COLUMN 



DE ERROR_MESSAGE PREENCHIDA,



JUSTAMENTE POR CONTA 



DA MESSAGE "CONDITION IS EVALUATED 
TO FALSE"....








--> E QUANDO ISSO ACONTECE, QUANDO 

1 EXPRESSION DE "WHEN" EM 1 

TASK É EVALUATED COMO FALSE,

A TASK INTEIRA É SKIPPADA,


COMO CONSTATAMOS NA COLUMN 
"STATE", QUE DIZ "SKIPPED"...




---------------------













OK... FAZ SENTIDO...








-> essa parece uma ótima feature 

que podemos usar 


para settar conditions...












--> INFELIZMENTE,


POR ENQUANTO TEMOS 



1 PEQUENO DOWNSIDE.... -------->









O DOWNSIDE É QUE 



ATUALMENTE __PODEMOS ___ 

USAR APENAS _ 1 ÚNICO TIPO DE 

FUNCTION (STREAMS, stream functions) DENTRO DESSA CONDITION....




 



 -> ISSO PODE SER DEMONSTRADO 

 COM O SEGUINTE CÓDIGO:












 -- Condition and functions (only ""STREAM FUNCTIONS"" allowed in conditions) --
CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK_2
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN CURRENT_TIMESTAMP_LIKE '20%' -- wont work (is not a stream function)
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE, FIRST_NAME) VALUES (CURRENT_TIMESTAMP, 'Aron');





ESSA TASK NAO VAI FUNCIONAR,

INFELIZMENTE.... --> i




ISSO PQ __ APENAS 


1 ÚNICO TIPO DE FUNCTION é 

CAPAZ DE SER USADO 


COM ESSAS CONDITIONS..... E ESSE TIPO DE FUNCTION 

É "STREAM FUNCTIONS", QUE APRENDEREMOS MAIS TARDE...












--> O ERRO, NO CASO, É 


'Invalid expression for task 
condition expression. Expecting 
one of the following: SYSTEM$STREAM_HAS_DATA;'











--> ESSA É A FUNCTION QUE PODEMOS USAR...







ESSA FUNCTION PODE SER USADA,

E MAIS TARDE 

VEREMOS O QUE SAO ESSES STREAMS,


E COMO PODEMOS __ COMBINAR__ 


ESSES STREAMS COM TASKS...






SYSTEM$STREAM_HAS_DATA 













--> AINDA ASSIM, MESMO QUE NAO CONSIGAMOS RODAR FUNCTIONS 

"NORMAIS" NESSA CONDITION,

AINDA É 

ÚTIL PODERMOS 

RODAR ESSAS STREAM FUNCTIONS...










-> MAIS TARDE VEREMOS SOBRE ESSES STREAMS,
E SOBRE COMO PODEMOS COMBINAR 

ESSES STREAMS COM TASKS....










UM EXEMPLO DE CÓDIGO QUE FUNCIONA (pq usa STREAMS com essa condition):



-- Conditions and functions (with STREAMS - only way to run a function in a condition) ----
CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK_2
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA(<stream_name>)
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE, FIRST_NAME) VALUES (CURRENT_TIMESTAMP, 'Anderson');
















OK... POR ENQUANTO, SABEMOS QUE PODEMOS SETTAR CONDITIONS NAS 

NOSSAS TASKS....






--> OK... E TUDO ISSO FICA MAIS ÚTIL SE FALAMOS SOBRE ___ STREAMS....