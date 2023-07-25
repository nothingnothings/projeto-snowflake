









AGORA DEVEMOS DESCOBRIR COMO PODEMOS 


CHECAR A HISTORY DE NOSSAS TASKS,





A HISTORY DE 1 GIVEN TASK,






E TAMBÉM 


CONSEGUIR 1 


__OVERVIEW__ DE NOSSAS TASKS....












COM ISSO, SEŔA POSSÍVEL HANDLAR 
ERRORS

E _ VISUALIZAR _ QUE 


TIPO __dE TASKS FORAM EXECUTADAS...








O PRIMEIRO PASSO, É CLARO,





É USAR O COMANDO DE 


"SHOW TASKS;"...











-- show overview of all tasks 
SHOW TASKS;









COM ISSO, OBSERVAMOS QUE TEMOS 4 TASKS CRIADAS...













--> CERTO... TEMOS TODA ESSA INFO:




--> OWNER 


--> DATABASE EM QUE ESSA TASK RODA...



--> SCHEDULE TIME 




-- PARENT_TASK 




--> STATE (se está SUSPENDED OU STARTED)...






---------------------------------








mas 



se desejamos TER MAIS DETAIL 


SOBRE ESSA TASK,




DEVEMOS USAR 


A 



TABLE FUNCTION 


"task_history()"...





-> MAS PARA CONSEGUIR 1 RESULTADO COM ESSA TABLE FUNCTION,

PRECISAMOS __ USAR ESSA FUNCTION COM ALGUMA 
QUERY, COMO 

COM ALGUM SELECT....










TIPO ASSIM:

-- Use the table function TASK_HISTORY() to get details about your task --
SELECT * FROM
    TABLE(information_schema.task_history())
    ORDER BY SCHEDULED_TIME DESC;















COM ISSO, PERCEBEMOS A QUANTIDADE DE VEZES 




QUE ESSAS TASKS FORAM EXECUTADAS,


E
 TAMBÉM RECEBER VÁRIAS INFOS:











O QUERY ID DA QUERY EXECUTADA POR ESSA TASK,


O NAME DA TASK,


SE HOUVE UMA ERROR_MESSGE,



QUANDO A QUERY COMECOU, QUANDO ACABOU,
ETC..







--> TAMBÉM MOSTRA SE FOI EXECUTADA COM BASE EM 1 SCHEDULE,


ETC ETC....











--> TAMBÉM HÁ ALGUMAS TASKS QUE ESTAO COMO 

"SCHEDULED"....









-> MAS QUAIS SAO AS INFOS MAIS INTERESSANTES A NÓS?














-> UMA DAS INFOS MAIS IMPORTANTES É 


""ERROR_MESSAGE""....








ISSO É IMPORTANTE PQ OCASIONALEMNTE 


PODEMOS FICAR COM ERRORS....









--> se temos alguma task que falhou,


é possível encontrar 




a column de "state" como FAILED....








ESSA COLUMN DE "ERROR_MESSAGE" 

nos ajuda a consertar 

essa task/statement/procedure usada nessa task...












O RESTO DAS INFOS TAMBÉM É ÚTIL...









-> MAS COMO FICAMOS COM MTAS INFORMACOES,


O PROFESSOR NOS MOSTRA 1 QUERY QUE DEIXA ESSA INFO TODA 
1 POUCO MAIS ORGANIZADA,


POR MEIO DO USO DE ALGUNS PARAMS DENTRO DA FUNCTION DE "task_history()"....



TIPO ASSIM:



-- See results for a SPECIFIC TASK, IN A GIVEN TIME.
SELECT * 
FROM TABLE (information_schema.task_history(

    scheduled_time_range_start => dateadd('hour', -4, CURRENT_TIMESTAMP()),
    result_limit => 5,
    task_name => 'CUSTOMER_INSERT_TASK_2'

))













CÓDIGO EXPLICADO:





-- See results for a SPECIFIC TASK, IN A GIVEN TIME.
SELECT * 
FROM TABLE (information_schema.task_history(
    scheduled_time_range_start => dateadd('hour', -4, CURRENT_TIMESTAMP()), -- visualizaremos task executions das 4 últimas horas... até 4 horas atŕas.
    result_limit => 5, -- veremos até 5 results, e nada além disso...
    task_name => 'CUSTOMER_INSERT_TASK_2' -- queremos ver as executions APENAS dessa task específica....

))







----------------------------------------













COM ISSO, VAMOS PEGAR TODOS OS 

RESULTS EXISTENTES 

NAS ÚLTIMAS 4 


HORAS...










--> PODEMOS TAMBÉM LIMTIAR OS


RESULTS, DEIXAR  1 MÁXIMO DE 5...







-> TAMBÉM PODEMOS DEFINIR O TASK_NAME,

PARA QUE FIQUEMOS COM MENOS RESULTS...












--> OK... ISSO É BEM ÚTIL...






















--> também podemos especificar 


MAIS DO QUE APENAS A "START RANGE";







PODEMOS ESPECIFICAR TAMBÉM O "END RANGE",





para que __ PEGUEMOS 

AS TASKS QUE 



RODARAM APENAS NESES PERÍODO DE TEMPO ESPECÍFICO..






TIPO  ASSIM:






-- See results for a SPECIFIC TASK, IN A GIVEN TIME.
SELECT * 
FROM TABLE (information_schema.task_history(
    scheduled_time_range_start => dateadd('hour', -4, CURRENT_TIMESTAMP()), -- visualizaremos task executions das 4 últimas horas... até 4 horas atŕas.
    scheduled_time_range_end => dateadd('hour', -2, CURRENT_TIMESTAMP()), -- visualizaremos task executions que terminaram até 2 horas atrás...
    result_limit => 5, -- veremos até 5 results, e nada além disso...
    task_name => 'CUSTOMER_INSERT_TASK_2' -- queremos ver as executions APENAS dessa task específica....








))














SE VC NAO SABE QUAL É O CURRENT TIMESTAMP,


VC SEMPRE PODE USAR 

"SELECT TO_TIMESTAMP_lTZ(CURRENT_TIMESTAMP)",






PQ É CLARO QUE ISSO NEM SEMPRE SERÁ 


O MESMO TIME/TIMESTAMP DA SUA REGIAO...





EX:





SELECT TO_TIMESTAMP_LTZ (CURRENT_TIMESTAMP);









