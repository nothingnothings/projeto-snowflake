






NAS 2 ÚLTIMAS LICOES,

JÁ VIMOS O COMPORTAMENTO DAS STREAMS 



EM RELACAO 
A CHANGES,


PARTICULARMENTE EM RELACAO 




A INSERTS E UPDATES...












MAS AGORA DEVEMOS 






VER O BEHAVIOR 


DOS DELETES,






VER COMO PODEMOS 








__ CONSUMIR__ STREAMS 


QUE POSSUEM DATA/CHANGES 


DE TIPO DELETE,






TUDO PARA QUE CONSIGAMOS IMPLEMENTAR 

ESSAS CHANGES 



NA NOSSA FINAL TABLE...








---------------------------------







COMECAMOS COM ESTE CÓDIGO:








-- ******* DELETE **********



SELECT * FROM SALES_FINAL_TABLE;

SELECT * FROM SALES_RAW_STAGING;

SELECT * FROM SALES_STREAM_EXAMPLE;

-- Simple Delete
DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Lemon';















--> NOSSA STREAM ESTÁ EMPTY, ATUALMENTE...










--> TEMOS 7 ROWS EM AMBAS TABLES..







--> VAMOS DELETAR O PRODUCT DE "LEMON",



LÁ NA TABLE DE "SALES_RAW_STAGING"...







--> NOSSA STREAM ESTÁ ATUALMENTE VAZIA...

ISSO PQ TÍNHAMOS A CONSUMIDO, ANTERIORMENTE,

PARA REFLETIR AS CHANGES FEITAS NA 
TABLE DE 
SALES_RAW_STAGING


NA SALES_FINAL_TABLE...













--> certo, mas agora 

DELETAMOS 1 ROW NA TABLE DE SALES_RAW_STAGING,


PARA QUE NOSSO STREAM OBJECT CAPTURE ESSA MUDANCA...







-> AGORA NOSSA SALES_RAW_STAGING TABLE 

TERÁ 


APENAS 6 ROWS, pq deletamos 1 deles...















-> E AGORA NOSSA STREAM TERÁ 1 



ROW NA SUA TABLE,

REFERENTE A ESSE PRODUCT QUE FOI APAGADO 


DA TABLE QUE ELE ESTAVA "WATCHING"...












--> PERCEBEMOS QUE ESSE É UM __DELETE__ PURO/comum


PQ A COLUMN DE 

"METADATA$ISUPDATE", no stream object,

ESTÁ COMO __ FALSE___... (
    significa que é realmente essa change 
    é derivada de 1 delete operation, e 
    nao de 1 update...
)












OK...


AGORA VEREMOS COMO PODEMOS CONSUMIR/PROCESSAR 

ESSA STREAM,
PARA 

APLICAR ESSA CHANGE (essa deleção) 


À NOSSA FINAL TABLE...











ESCREVEMOS ASSIM:








-- ******** Process/Consume Stream ***********





MERGE INTO SALES_FINAL_TABLE F 
USING SALES_STREAM_EXAMPLE S 
    ON F.ID = S.ID
WHEN MATCHED 
    AND S.METADATA$ACTION = 'DELETE'
    AND S.METADATA$ISUPDATE = 'FALSE'
THEN DELETE;

















OK, E ISSO REALMENTE FUNCIONA, 



NOSSOS ROWS 


SAO DELETADOS, NESSA FINAL TABLE...








OBS: O MERGE STATEMENT TAMBÉM É USADO 

PARA __ DELETAR ROWS,


NAO HÁ PROBLEMA COM ISSO....

















-> É CLARO QUE PODEMOS USAR A STREAM 

DA MANEIRA QUE QUISERMOS (Rodar analytics, talvez),





PODEMOS ATÉ CRIAR 1 NOVA TABLE A PARTIR 

DELA (mas isso CONSUMIRIA ESSA DATA; 

AS STREAMS PODEM SER CONSUMIDAS/USADAS APENAS 
1 ÚNICA VEZ),







MAS __1  COISA _BOA A 

SE 

FAZER É 


IMPLEMENTAR_ _ ESSAS CHANGES 




EM 1 FINAL TABLE....























--> certo, mas é claro que nada nos 

impede de BAIXAR ESSA 

STREAM COMO CSV,

E ENTAO 


FAZER O INSERT DESSE CSV EM 1 TABLE, 

NA NOSSA DATABASE...











--> CONSUMIDA ESSA STREAM, ELA FICARÁ EMPTY.







EM 1 FINAL TABLE...




