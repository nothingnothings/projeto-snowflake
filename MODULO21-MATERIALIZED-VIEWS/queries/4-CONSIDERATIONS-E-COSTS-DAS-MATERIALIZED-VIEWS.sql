











NA ÚLTIMA AULA,

VIMOS QUE SE 

ALTERARMOS A DATA 


DE UMA UNDERLYING TABLE 

DE 


UMA 

MATERIALIZED VIEW,


ESSA VIEW 


VAI SER AUTOMATICAMENTE UPDATADA 

TAMBÉM...











E ESSE UPDATE AUTOMÁTICO É 

"""MANAGEADO PELO SNOWFLAKE"",





é manageado pelo próprio snowflake,

e nao precisamos usar 

uma virtual warehouse 




para handlar esse update da 


materialized view...














--> MAS O PROBLEMA É QUE 

__tEMOS QUE PAGAR CŔEDITOS SEPARADAMENTE 


AO SNOWFLAKE...









--> ESSE É UM SERVICE ADICIONAL,


OBVIAMENTE PAGO...










MAS COMO PODEMOS CHECAR 

ESSES CUSTOS?









DEVEMOS IR ATÉ OS COSTS 


DA WAREHOUSE....






--> OS COSTS FICAM EM 



"MATERIALIZED_VIEW_MAINTENANCE"....







ACCOUNT > USAGE.











temos que levar isso em consideracao, também....






MAS TAMBÉM HÁ OUTRO COMANDO QUE PODEMOS 

RODAR,




PARA VER A "REFRESH HISTORY",





E __ O CUSTO ASSOCIADO A ESSA REFRESH HISTORY,

DE NOSSAS MATERIALIZED 
VIEWS...








É ESTE STATEMENT:






SELECT * FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.MATERIALIZED_VIEW_REFRESH_HISTORY())