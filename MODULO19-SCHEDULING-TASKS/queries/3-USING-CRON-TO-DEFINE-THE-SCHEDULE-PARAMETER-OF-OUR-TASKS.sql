







NA ÚLTIMA AULA, VIMOS O QUAO FACILMENTE 


PODEMOS CRIAR 



1 TASK (que é um object que consegue rodar 

APENAS 1 ÚNICO SQL STATEMENT)....









O PROFESSOR ESCREVE ESTE CÓDIGO:









-- How to suspend a task in SNOWFLAKE SQL --
ALTER TASK CUSTOMER_INSERT_TASK SUSPEND;



SELECT * FROM CUSTOMERS;




CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
AS 
INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);





---------------------












É ASSIM  QUE PODEMOS 


CRIAR 1 TASK,


TASK QUE EXECUTA 1 SQL STATEMENT....










-> também aprendemos sobre esse method 



de definir SCHEDULE, em que colocamos 

1 quantidade de 

minutos x...



--> isso é o intervalo de tempo entre 
execucoes...

















---> QUER DIZER QUE, A CADA MINUTO,

ESSE SQL COMMAND 

SERÁ EXECUTADO...










--> PODEMOS DEFINIR 60 MINUTES, PARA QUE 

ISSO RODE 
A CADA HORA, ETC...








--> MAS EXISTE OUTRA MANEIRA DE 



DEFINIR INTERVALS PARA 1 TASK,



BASTA 


USAR CRONJOBS...








--> COM CRONJOBS,

FICA TIPO ASSIM:




CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK
    WAWREHOUSE = COMPUTE_WH 
    SCHEDULE = 'USING CRON * * * * * UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);












OUTRO EXEMPLO:




CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK
    WAREHOUSE=COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7-10 * * 1-5 UTC'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);








-> SE ESCREVEMOS "L" NO SLOT DE "DAY OF THE MONTH",



FICAMOS COM O VALUE DE "ÚLTIMO DIA DO MES" (pq 
pode ser 29, 30, 31, etc)...





EX:



CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK
    WAREHOUSE=COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7-10 L * 1-5 UTC' -- L = last day of month
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);





------------------------













--> PARA O WEEKDAY,




TAMBÉM PODEMOS COLOCAR "L"...









--> MAS NO WEEKDAY, SE COLOCAMOS "L",


O SIGNIFICADO 

É DIFERENTE...




EX:



5L ---> SIGNIFICA "ÚLTIMA SEXTA DO MÊS"....












EX:






EX:



CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK
    WAREHOUSE=COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7-10 * * 5L UTC'
    AS
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);










EX:










AGORA ALGUNS EXEMPLOS:




-- Every minute 
SCHEDULE = 'USING CRON * * * * * UTC';



-- EVery DAY AT 6AM UTC:
SCHEDULE = 'USING CRON 0 6 * * * UTC';

-- Every hour, starting at 9AM and ending at 5PM on sundays:
0 9-17 * * 0 America/Lost_Angeles 




CREATE OR REPLACE TASK CUSTOMER_INSERT_TASK
    WAREHOUSE = COMPUTE_wH
    SCHEDULE = 'USING CRON 0 9,17 * * * UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES (CURRENT_TIMESTAMP);


