







AGORA QUE VIMOS COMO PODEMOS IMPLEMENTAR 

___TODAS___ AS CHANGES __ CAPTURADAS 


POR 1 STREAM/NOSSA STREAM 



LÁ NA TABLE FINAL, TUDO DE UMA SÓ VEZ,


COM ESSE STATEMENT (aplica updates, deletes e inserts):








MERGE INTO SALES_FINAL_TABLE F  -- "SALES_FINAL_TABLE" --> TARGET TABLE to merge changes from source table.
USING (
    SELECT S_STREAM.*, ST.LOCATION, ST.employees
    FROM SALES_STREAM_EXAMPLE S_STREAM -- OUR STREAM and an alias for it (S_STREAM)
    JOIN STORE_TABLE ST
    ON S_STREAM.STORE_ID = ST.STORE_ID -- we get also "location" and "employees" fields.
) S 
ON F.ID = S.ID
WHEN MATCHED -- DELETE CONDITION
    AND S.METADATA$ACTION = 'DELETE'
    AND S.METADATA$ISUPDATE = 'FALSE'
THEN DELETE 
WHEN MATCHED -- UPDATE CONDITION
    AND S.METADATA$ACTION = 'INSERT'
    AND S.METADATA$ISUPDATE = 'TRUE'
THEN UPDATE 
        SET F.PRODUCT = S.PRODUCT,
            F.PRICE = S.PRICE,
            F.AMOUNT = S.AMOUNT, 
            F.STORE_ID = S.STORE_ID
WHEN NOT MATCHED -- INSERT CONDITION
    AND S.METADATA$ACTION = 'INSERT'
THEN INSERT (id, product, price, store_id, amount, employees, location)
    VALUES (S.ID, S.product, S.price, S.store_id, S.amount, s.employees, s.location);



,











DEVEMOS ESTUDAR 





COMO É FEITA A INTEGRACAO DESSAS STREAMS COM TASKS...




-----------------------------------














PARA ISSO, O PROFESSOR COMECA PELA CRIACAO DE 1 TASK:







--------------- Automate the apply of changes to final table, using tasks -----------


CREATE OR REPLACE TASK ALL_DATA_CHANGES_APPLIER
    WAREHOUSE = COMPUTE_WH
    SCHEDULE='1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM_EXAMPLE')
    AS ...













------- COMECAMOS COM ESSE COMANDO, SIM,
---- MAS DEPOIS INSERIMOS O COMANDO SUPER-TRUNFO,
----- TIPO ASSIM:







CREATE OR REPLACE TASK ALL_DATA_CHANGES_APPLIER
    WAREHOUSE = COMPUTE_WH
    SCHEDULE='1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM_EXAMPLE')
    AS
    MERGE INTO SALES_FINAL_TABLE F  -- "SALES_FINAL_TABLE" --> TARGET TABLE to merge changes from source table.
    USING (
        SELECT S_STREAM.*, ST.LOCATION, ST.employees
        FROM SALES_STREAM_EXAMPLE S_STREAM -- OUR STREAM and an alias for it (S_STREAM)
        JOIN STORE_TABLE ST
        ON S_STREAM.STORE_ID = ST.STORE_ID -- we get also "location" and "employees" fields.
    ) S 
    ON F.ID = S.ID
    WHEN MATCHED -- DELETE CONDITION
        AND S.METADATA$ACTION = 'DELETE'
        AND S.METADATA$ISUPDATE = 'FALSE'
    THEN DELETE 
    WHEN MATCHED -- UPDATE CONDITION
        AND S.METADATA$ACTION = 'INSERT'
        AND S.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE 
            SET F.PRODUCT = S.PRODUCT,
                F.PRICE = S.PRICE,
                F.AMOUNT = S.AMOUNT, 
                F.STORE_ID = S.STORE_ID
    WHEN NOT MATCHED -- INSERT CONDITION
        AND S.METADATA$ACTION = 'INSERT'
    THEN INSERT (id, product, price, store_id, amount, employees, location)
        VALUES (S.ID, S.product, S.price, S.store_id, S.amount, s.employees, s.location);




--------------------------------------














COM ISSO, É CRIADA 1 TASK, RODADA DE 1 EM 1 MINUTO (
    MENOR INTERVALO POSSÍVEL
) QUE 


CHECA PELA EXISTENCIA DE DATA NO INTERIOR DA 

STREAM...


SE 

É IDENTIFICADA DATA DENTRO DAQUELA STREAM,


É EXECUTADO AQUELE SQL STATEMENT IMENSO,

QUE VAI APLICAR AS CHANGES OCORRIDAS EM 
"SALES_RAW_STAGING" (se ocorrerem)


LÁ NA TABLE FINAL DE "SALES_FINAL_TABLE"...













OU SEJA, A PARTE MAIS IMPORTANTE 


DESSA TASK 



É A CONDICAO



"WHEN SELECT SYSTEM$STREAM_HAS_DATA('SALES_STREAM_EXAMPLE');"








QUE TEM 1 FORMATO DE 



SYSTEM$STREAM_HAS_DATA(<nome_da_stream>)



























WHEN --> É O SET DE CONDITIONS, EM 1 TASK...



A TASK SOMENTE SERÁ EXECUTADA 


SE ESSA CONDITION RESULTAR EM TRUE...

















-->essa task somente será executada 


se existir data na stream, por conta daquela 

condicao.




->> isso pq esse 


é um cenário mt comum,

querer que a final table seja updatada 



sempre que 


a stream receber data/capturar changes em 1

das tables originárias.


















OK... POR ISSO CRIAMOS ESSA TASK,
E DEPOIS FAZEMOS O RESUME DA MESMA (

    pq, caso contrário, ela vai comecar 


    no state de SUSPENDED...
)










TIPO ASSIM:
















CREATE OR REPLACE TASK ALL_DATA_CHANGES_APPLIER
    WAREHOUSE = COMPUTE_WH
    SCHEDULE='1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM_EXAMPLE')
    AS
    MERGE INTO SALES_FINAL_TABLE F  -- "SALES_FINAL_TABLE" --> TARGET TABLE to merge changes from source table.
    USING (
        SELECT S_STREAM.*, ST.LOCATION, ST.employees
        FROM SALES_STREAM_EXAMPLE S_STREAM -- OUR STREAM and an alias for it (S_STREAM)
        JOIN STORE_TABLE ST
        ON S_STREAM.STORE_ID = ST.STORE_ID -- we get also "location" and "employees" fields.
    ) S 
    ON F.ID = S.ID
    WHEN MATCHED -- DELETE CONDITION
        AND S.METADATA$ACTION = 'DELETE'
        AND S.METADATA$ISUPDATE = 'FALSE'
    THEN DELETE 
    WHEN MATCHED -- UPDATE CONDITION
        AND S.METADATA$ACTION = 'INSERT'
        AND S.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE 
            SET F.PRODUCT = S.PRODUCT,
                F.PRICE = S.PRICE,
                F.AMOUNT = S.AMOUNT, 
                F.STORE_ID = S.STORE_ID
    WHEN NOT MATCHED -- INSERT CONDITION
        AND S.METADATA$ACTION = 'INSERT'
    THEN INSERT (id, product, price, store_id, amount, employees, location)
        VALUES (S.ID, S.product, S.price, S.store_id, S.amount, s.employees, s.location);




ALTER TASK ALL_DATA_CHANGES_APPLIER RESUME;











--> OK... RESUMIDA ESSA TASK,


VAMOS 


RODAR:








-- Show state of task:
SHOW TASKS;







-- Change Data in SALES_RAW_STAGING table (to have the data captured in the SALES_STREAM_EXAMPLE)...

INSERT INTO SALES_RAW_STAGING VALUES (11, 'Milk', 1.25, 3, 2);
INSERT INTO SALES_RAW_STAGING VALUES (25, 'Choco', 1.05, 1, 5);
INSERT INTO SALES_RAW_STAGING VALUES (12, 'Tea', 1.75, 1, 8);




-- Check Data in Stream table (Captured changes)
SELECT * FROM SALES_STREAM_EXAMPLE;














---> É CLARO QUE ESSA DATA, DOS INSERTS,

VAI FICAR NO STREAM OBJECT POR 1 MINUTO, E DEPOIS VAI 

SUMIR,



JUSTAMENTE POR CONTA DA NOSSA TASK,

QUE FAZ O APPLY AUTOMÁTICO 

DAS CHANGES (capturadas e armazenada no stream object)


NA NOSSA FINAL TABLE.








PODEMOS TESTAR COM DELETES E UPDATES, TAMBÉM:








-- Change data again, now delete.
DELETE FROM SALES_RAW_STAGING 
WHERE Product = 'Choco';


-- Check Data in Stream table (Captured changes)
SELECT * FROM SALES_STREAM_EXAMPLE;




-- Check Data in final table:
SELECT * FROM SALES_FINAL_TABLE;














ok, mas alguma coisa está errada...









--> eu re-rodei as queries que 

inserem "tea" e "choco",


e essa data realmente SUMIU DA STREAM,




mas ela nao apareceu lá na final table, por alguma 

razao...













MELHOR VER A HISTORY DA MINHA TASK, COM ESTE COMANDO:











-- See results for a SPECIFIC TASK, IN A GIVEN TIME.
SELECT * 
FROM TABLE (information_schema.task_history(

    scheduled_time_range_start => dateadd('hour', -4, CURRENT_TIMESTAMP()),
    result_limit => 5,
    task_name => 'CUSTOMER_INSERT_TASK_2'

))


















entendi... foi culpa minha, os 

ids das stores estavam completamente errados (

    só podem ser 1 ou 2, para o join funcionar.
)












AGORA VAMOS RODAR UPDATE DE DATA, SÓ PARA TESTAR...







TAMBÉM DELETES...





SELECT * FROM SALES_RAW_STAGING;


-- basic row update
UPDATE SALES_RAW_STAGING
SET Product = 'Donuts'
WHERE Product = 'Tea';




-- basic row delete 
DELETE FROM SALES_RAW_STAGING
WHERE Product = 'Milk';



-- check STREAM OBJECT data capture
SELECT * FROM SALES_STREAM_EXAMPLE;





-- check FINAL TABLE (check if changes were applied):
SELECT * FROM SALES_FINAL_TABLE;











OK... FUNCIONOU.






E nossa stream também ficou empty, como resultado 
disso...







PODEMOS VERIFICAR NA HISTORY:




-- See results for a SPECIFIC TASK, IN A GIVEN TIME.
SELECT * 
FROM TABLE (information_schema.task_history(

    scheduled_time_range_start => dateadd('hour', -4, CURRENT_TIMESTAMP()),
    result_limit => 5,
    task_name => 'CUSTOMER_INSERT_TASK_2'

))








O ÚLTIMO RUN DA TASK FOI SKIPPED,





PQ PASSAMOS A TER NENHUMA DATA DENTRO 

DA STREAM....









--> NAS VEZES ANTERIORES, FICAMOS COM "SUCCEEDED",


PQ NESSAS OCASIOES 



O SYSTEM$STREAM_HAS_DATA() FICOU COMO TRUE, O QUE 
FEZ A TASK SER 

EXECUTADA.








OK... ACABAMOS COM ESTA AULA.