








AGORA DEVEMOS ESTUDAR A MANEIRA COMO 

PODEMOS 


CRIAR 

""TREES OF TASKS""...










-> IMAGINE ESTA ESTRUTURA:


            ROOT TASK
          ---- [] ----
          i          i 
          i          i 
       TASK A      TASK B 
       I   I       I    i
   TASK C  TASK D  E     F 













--> COM ISSO, PODEMOS CRIAR __ DEPENDENCIES
 

 ENTRE AS TASKS QUE VAMOS CRIANDO...








 --> É CLARO QUE 1 TREE OF TASKS 

 CONSISTE DE 1 "ROOT TASK",




UMA TASK QUE PRECISA SER SCHEDULADA,

E QUE NAO DEPENDE DE NENHUMA OUTRA TASK....








-- AÍ ESSA TASK PODE TER CHILD TASKS,


O QUE QUER DIZER QUE 



_CRIAMOS ___ DEPENDENCIES__...









-> SIGNIFICA QUE AS TASKS A E B 

SOMENTE SERAO EXECUTADAS DEPOIS DA TASK ROOT SER 
EXECUTADA...




JÁ AS TASKS C E D SOMENTE SERAO 

EXECUTADAS DEPOIS DA EXECUCAO DA 

TASK A...







-> ASSIM QUE AS PARENT TASKS TERMINAM,

AS CHILD TASKS SAO STARTADAS --> É ASSIM QUE 

É CRIADA 

1 DEPENDENCY....










--> ATUALMENTE, O SNOWFLAKE 


NAO PERMITE QUE 1 GIVEN TASK 

TENHA "MAIS DE 1 PARENT" --> SEMPRE 


1 TASK TERÁ APENAS 1 ÚNICA DEPENDENCY,

1 ÚNICO PARENT QUE 

A CRIOU...








-> ENTRETANTO, É POSSÍVEL QUE 


1
 PARENT TASK TENHA MÚLTIPLAS CHILDREN 


 TASKS (


O LIMITE MÁXIMO É 

DE 100 TASKS POR __ PARENT TASK... 1 GIVEN 

TASK PODE TER 100 CHILD TASKS...

 )











--> OK... -> E O LIMITE DE 1 TREE INTEIRA 


É __ DE _ 1000 TASKS...









--> É QUASE ILIMITADO, DE TANTAS TASKS...

















MAS DEVEMOS VER COMO 

___iMPLEMENTAR __ ESSA TREE OF TASKS...







A SINTAXE É BEM SIMPLES:






CREATE TASK <task_name>
    AFTER <parent_task_name>
    AS ... (código normal de definicao dessa task, com o código sql a ser executado, o single statement a ser executado)












-- OK.... 






-- ALÉM DISSO, PODEMOS ALTERAR 1 TASK QUE JÁ EXISTE,



-- PODEMOS ALTERAR ESSA TASK E COLOCAR QUE 

-- ELA DEVE SER EXECUTADA COMO DEPENDENCY DE OUTRA 
-- TASK,


-- BASTA EXECUTAR ASSIM:




ALTER TASK <task_name>
    ADD AFTER <parent_task_name>









    