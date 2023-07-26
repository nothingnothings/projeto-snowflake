







AGORA DEVEMOS ESTUDAR 1 MANEIRA 

ALTERNATIVA 

DE FAZER TRACK 

DE CHANGES EM 1 GIVEN TABLE... (ou seja,

algo alternativo aos streams)...















--> OU SEJA,



NAO VAMOS CRIAR 1 STREAM OBJECT...










--> EM VEZ DE USAR 1 STREAM OBJECT,





VAMOS USAR UM "CHANGE STATEMENT"...










VEREMOS:



1) QUAIS AS DIFERENCAS DA CHANGE CLAUSE 

EM RELACAO A NORMAL STREAMS...





2) COMO USAR CHANGE CLAUSES...









VAMOS TRACKAR AS CHANGES FEITAS 


NA TABLE DE "SALES_RAW"....






COMECAMOS COM ESTE CÓDIGO:








-------------------- Change Clause ----------------



CREATE OR REPLACE DATABASE SALES_DB;


CREATE OR REPLACE TABLE SALES_RAW (
    ID VARCHAR,
    PRODUCT VARCHAR,
    PRICE VARCHAR,
    AMOUNT VARCHAR,
    STORE_ID VARCHAR
);




--- Insert values 
INSERT INTO SALES_RAW 
    VALUES 
        (1, 'Eggs', 1.39, 1, 1),
		(2, 'Baking powder', 0.99, 1, 1),
		(3, 'Eggplants', 1.79, 1, 2),
		(4, 'Ice cream', 1.89, 1, 2),
		(5, 'Oats', 1.98, 2, 1);



-- TO USE THE CHANGE CLAUSE, TO TRACK CHANGES, WE NEED TO SET THIS PROPERTY:
ALTER TABLE sales_raw
    SET CHANGE_TRACKING=TRUE;








--> SE QUEREMOS TRACKAR CHANGES NA NOSSA 

TABLE,

DEVEMOS SETTAR ESSA PROPERTY DE "CHANGE_TRACKING"


como sendo true....







ISSO FEITO,


PODEMOS ACTUALLY USAR __ O STATEMENT DE 

"CHANGES"...






tipo assim:






SELECT * FROM SALES_RAW 
CHANGES(information => default)
AT (offset => -0.5*60);
















-> OU SEJA, USAMOS ESSE CHANGES STATEMENT....





--> USAMOS ESSE VALUE DE "information => default"...

QUANDO DEFINIMOS O VALUE COMO "default",

queremos dizer que 

QUEREMOS VISUALIZAR 


TODOS OS TIPOS DE CHANGES (delete, update, insert)...




--> A ALTERNATIVA SERIA ESCREVER 


"information => append-only"...






-> VEREMOS ISSO NO PRÓXIMO EXEMPLO...















--------------------------->



MAS AQUI JÁ É POSSÍVEL CONSTATAR QUE 



A FEATURE DE 


"TIME TRAVEL" FOI UTILIZADA,



JUSTAMENTE PQ 

O PROFESSOR ESCREVEU 



"AT(offset => -0.5*60)"










--> SIGNIFICA QUE VAMOS VOLTAR 30 SEGUNDOS NO PASSADO...








--> ALÉM DISSO, COMO JÁ SABEMOS,


PARA USAR ESSA FEATURE (do CHANGE CLAUSE),



PRECISAMOS DO TIME TRAVEL... --> E O TIME TRAVEL 

PRECISA ESTAR HABILITADO, PARA QUE ISSO FUNCIONE....








---> e sabemos que O TIME TRAVEL 


NAO FUNCIONA COM TEMPORARY TABLES,

FUNCIONA APENAS COM 

TRANSIENT (1 dia) E PERMANENT TABLES (90 dias, default)..











OK... TENTAREMOS USAR ESSE STATEMENT,



ESTE AQUI:





SELECT * FROM SALES_RAW 
CHANGES(information => default)
AT (offset => -0.5*60);










OK....








COM ISSO CONSEGUIMOS VISUALIZAR 


NOSSAS CHANGES...











--> É CLARO QUE NAO SOMOS OBRIGADOS A USAR 


"AT (offset => xxx)"....










-- PODEMOS TAMBÉM USAR 

__UM TIMESTAMP,



OU ENTAO 

UM __ QUERY ID,
TIPO ASSIM:







SELECT CURRENT_TIMESTAMP;

-- Insert values
INSERT INTO SALES_RAW VALUES (6, 'Bread', 2.99, 1, 2);
INSERT INTO SALES_RAW VALUES (7, 'Onions', 2.89, 1, 2);


SELECT * FROM SALES_RAW
CHANGES(information  => default)
AT (timestamp => 'your-timestamp'::timestamp_tz);










UPDATES TAMBÉM SAO CAPTURADOS:






UPDATE SALES_RAW
SET PRODUCT = 'Toast2' WHERE ID=6;












--> O "DEFAULT" TAMBÉM 

CAPTURA 

UPDATES,






APENAS O "APPEND-ONLY" 

NAO CAPTURA 

UPDATES...







--> MAS TEMOS 1 DETALHE:




POR ROW,

NO CHANGES CLAUSE,




SEMPRE TEREMOS A "LATEST CHANGE"





EM RELACAO AOS UPDATES (o último value que 
foi settado)...







PARA COMUNICAR QUE VC QUER 

APENAS 


VER CHANGES DE TIPO "INSERT",



VOCE DEVE ESCREVER ASSIM:








SELECT * FROM SALES_RAW 
CHANGES(information => append_only)
AT(timestamp => 'your-timestamp'::timestamp_tz');










SE FAZEMOS ISSO, APENAS OS INSERTS 

SERAO TRACKADOS...




------------------------------










QUAL É A DIFERENCA ENTRE CHANGE CLAUSES 


E 


__ STREAM OBJECTS?















--> STREAM OBJECTS SAO "cONSUMIDOS",

QUER DIZER QUE SUA DATA/ROWS PODEM SER USADOS 

APENAS 1 ÚNICA VEZ (ou com 1 comando insert into,

ou com 1 comando CREATE OR REPLACE <table_name> AS SELECT * FROM <stream_name>)








--> JÁ COM A CHANGE CLAUSE, 

PODEMOS USAR A DATA DAS ROWS INDEFINIDAMENTE,



NADA VAI ACONTECER SE UTILIZARMOS ESSA DATA (



    quer dizer que PODEMOS CRIAR 1 TABLE A PARTIR 
    DESSA 

    CHANGE CLAUSE,

    E MESMO ASSIM A DATA 


    DA CHANGE CLAUSE, RELATIVA A ESSE PERÍODO/CHANGES
     NAO TERÁ SIDO CONSUMIDA...
)











com isso, podemos managear dinamicamente 

as changes feitas em 1 given table...







acabamos com este módulo...




