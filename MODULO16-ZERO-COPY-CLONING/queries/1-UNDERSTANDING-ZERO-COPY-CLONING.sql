


-- ESSA COPIA É TOTALMENTE __INDEPENDENTE__ 

-- DA TABLE ORIGINAL... MAS É TOTALMENTE IGUAL.



-- SINTAXE BÁSICA:


CREATE TABLE <table_name>
    CLONE <source_table_name>...
    







-- BASTA VC ESCREVER "CREATE TABLE",


-- colocar o nome que vc quer que esse clone tenha,


-- e entao 


-- "CLONE" + NOME DA TABLE ORIGINAL....













--> ALÉM DISSO, O PROFESSOR MENCIONOU QUE PODEMOS 
-- USAR


-- ESSE COMANDO DE "CLONE"


-- junto com a feature de 

-- "TIME TRAVEL",



-- tipo assim:





CREATE TABLE <table_name> ...
CLONE <source_table_name>
BEFORE (TIMESTAMP => <timestamp>)