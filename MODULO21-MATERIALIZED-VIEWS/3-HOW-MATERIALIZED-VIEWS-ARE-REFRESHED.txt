










NA ÚLTIMA AULA,

VIMOS COMO PODEMOS CRIAR 


1 MATERIALIZED VIEW,


E 


COMO PODEMOS NOS BENEFICIAR DISSO...





(QUERY TIMES BEM MENOS LENTOS)...

















--> MAS AGORA QUEREMOS VER O QUE ACONTECE 



SE ALGUMA DATA É ATUALIZADA NA 

UNDERLYING TABLE (

    a table sobre a qual 

    a MATERIALIZED VIEW é criada...
)














--> SE A UNDERLYING TABLE FOR ALTERADA,

QUEREMOS QUE ESSAS ALTERACOES 

SEJAM APLICADAS 


INTEGRALMENTE NA MATERIALIZED VIEW...












temos este código:










-- How materialized views are refreshed --




SHOW MATERIALIZED VIEWS;




-- Query MATERIALIZED VIEW - much faster than normal view or normal select statements.
SELECT * FROM ORDERS_MATERIALIZED_VIEW
ORDER BY YEAR;



-- Update or Delete Values (changes to underlying table)
UPDATE ORDERS 
SET O_CLERK = 'Clerk#9999999999'
WHERE O_ORDERDATE='1992-01-01';


-- Update or Delete Values (changes to underlying table)
UPDATE ORDERS 
SET O_CLERK = 'Clerk#00000';





updatamos alguns values na table original, 

para ver 


se a 


materialized view 


consegue 

ser updatada a partir disso... (automaticamente)











ok... 62 mil rows foram atualizados...













-> AGORA, SE RODAMOS 


"SHOW MATERIALIZED VIEWS",



veremos que 



ALGUMAS COISAS TERAO MUDADO,

EM NOSSAS COLUMNS...







O VALUE DE 'behind_by',


que antes estava como '0s' (ou seja,

table originária e view estavam 
exatamente iguais)




AGORA ESTÁ COMO 


'13m42s'...





E FOI REFRESHADA PELA ÚLTIMA VEZ


15 MINUTOS ATRÁS,

COMO PODEMOS CONSTATAR 

NA COLUMN DE 

"refreshed_on"...






-----------------





QUER DIZER QUE O UPDATE 


DE NOSSAS 


MATERIALIZED VIEWS 


__NAO __ É INSTANTANEO....





--> BEM, MAS AINDA 


NAO FOI REFRESHADO...










--> mas é quase instantaneo,

na verdade....


--> nao é bem instantaneo,


depende da query... 


--> pode ser ou instantaneo,

ou demorar 1 pouco...


