










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
ORDER BY ORDER_YEAR;



-- Update or Delete Values (changes to underlying table)
UPDATE ORDERS 
SET O_CLERK = 'Clerk#9999999999'
WHERE O_ORDERDATE='1992-01-01';