










OK... AGORA O PROFESSOR QUER QUE 

ESTUDEMOS MAIS ALGUNS REAL-LIFE EXAMPLES 


DE COMO APLICAR 1 POLICY...







------------------------




INCORPORAMOS O ROLE DE ACCOUNTADMIN,


E AÍ VAMOS RODANDO ESTES COMANDOS:









###### More Examples - 1 ########



USE ROLE ACCOUNTADMIN;

USE DEMO_DB;

CREATE OR REPLACE MASKING POLICY EMAIL_POLICY
AS
    (VAL VARCHAR) returns VARCHAR ->
    CASE 
        WHEN CURRENT_ROLE() IN ('ANALYST_FULL') THEN VAL 
        WHEN CURRENT_ROLE() IN ('ANALYST_MASKED') THEN regexp_replace(val, '.+\@', '*****@') -- VAI MASCARAR APENAS O NOME DA PESSOA, O DOMAIN (site do email) poderá ser visualizado....
        ELSE '*************' -- todos os outros roles, que nao sejam ANALYST_FULL ou ANALYST_MASKED, verao apenas asteriscos nessa column.
    END;






-----------------------------------








ISSO FEITO, VAMOS ASSIGNAR/ATRIBUIR ESSA MASKING POLICY DE "EMAIL_POLICY" 




A ALGUMA COLUMN DE 1 TABLE,

POR ISSO ESCREVEMOS:










ALTER TABLE customers MODIFY COLUMN EMAIL
SET MASKING POLICY EMAIL_POLICY;








---------------------------------









PARA CHECAR SE ESSA POLICY REALMENTE FOI APLICADA 


EM ALGUMA COLUMN,




ESCREVEMOS:







-- In column "ref_column_name", we find out TO WHICH COLUMN THIS MASKING POLICY IS ATTACHED (can be multiple columns, in entire database).
SELECT * FROM 
TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(POLICY_NAME => 'EMAIL_POLICY'));


















OK... AGORA RODAMOS SELECT, PARA 

VER COMO FICAM OS FORMATOS 
DESSES EMAILS MASCARADOS...











TROCAMOS PARA O ROLE 



DE ANALYST_MASKED,




e aí 



RODAMOS O SELECT:






USE ROLE ANALYST_MASKED;




SELECT * FROM CUSTOMERS;




















FUNCIONOU... OS EMAILS FICARAM ASSIM:






*****@un.org
*****@mayoclinic.com
*****@txnews.com
*****@patch.com
*****@globo.com
*****@rediff.com




-----------------------





COM ANALYST_FULL,





ESSES VALUES DEVEM SER TOTALMENTE VISÍVEIS,


POR ISSO TESTAMOS:









USE ROLE ANALYST_FULL;


SELECT * FROM CUSTOMERS;






------------------------------













COM ISSO, FICAMOS COM TOTAL CRIATIVIDADE 

ACERCA DE COMO PODEMOS IMPLEMENTAR NOSSAS MASKS...






--------------------------------









AGORA VEREMOS UM SEGUNDO EXEMPLO:








#### More examples - 2  - ####




USE ROLE ACCOUNTADMIN;





CREATE OR REPLACE MASKING POLICY SHA2_POLICY AS 
(VAL VARCHAR) RETURNS VARCHAR -> 
    CASE
        WHEN CURRENT_ROLE() IN ('ANALYST_FULL') THEN VAL
        ELSE SHA2(VAL) -- RETURNS HASH OF THE COLUMN VALUE 
    END;












--> COM ESSE CÓDIGO,


CRIAMOS UMA MASK 

QUE __ FAZ COM QUE _ OS VALUES APARECAM 

COMO _ HASHES __ SE O ROLE DO USER NAO 


FOR ANALYST_FULL OU SUPERIOR...





bem útil...















ISSO É ÚTIL PQ __ ESSES VALUES 

NESSA COLUM AINDA PODEM SERVIR COMO 

IDENTIFIERS,


PQ ELES AINDA SERAO ÚNICOS...










--> QUER DIZER QUE NOSSOS VALUES SAO 

"ANONIMIZADOS"...











--> USAMOS ESSE HASHING ALGORITHM,



BASTA USAR ESSE "SHA2",





ESSA SHA2() FUNCTION...
















SHA ---> SECURE HASH ALGORITHM...









---> OK... 





ISSO FEITO, VAMOS DEFINIR/VINCULAR ESSA MASKING POLICY 


A ALGUMA COLUMN,




TIPO ASSIM:







-- Apply masking policy to Column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN FULL_NAME
    SET MASKING POLICY SHA2_POLICY;






















PODEMOS VALIDAR/TESTAR ESSA MASKING POLICY,


BASTA RODARMOS:








USE ROLE ANALYST_MASKED;




SELECT * FROM CUSTOMERS;













--- COM ISSO,


OS VALUES EM FULL_NAME FICAM COMO 

HASHES ASSIM: DSAIHSDH1J=sfahsiifh12fafnn.











----------------------------------------













PERFEITO... ISSO É BEM ÚTIL...












MAS DEVEMOS NOS LEMBRAR 


QUE __ É POSSÍVEL TER APENAS 1 POLICY POR COLUMN...









--> PARA TIRAR ESSA POLICY DESSA COLUMN,

PRECISAMOS DO COMANDO UNSET,


TIPO ASSIM:







ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN FULL_NAME 
UNSET MASKING POLICY;











------------------------------------------------












ok... se usamos o role de ANALYST_MASKED,


NOSSOS VALUES SAO ANONIMIZADOS,

o que é bem legal...



----------------------------------

















CERTO... AGORA VEREMOS 1 TERCEIRO EXEMPLO...












VEJA:








### More examples - 3 ###



-- create masking policy 
CREATE OR REPLACE MASKING POLICY DATES_POLICY_2
AS 
(VAL DATE) RETURNS DATE -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('ANALYST_FULL') THEN VAL 
        ELSE DATE_FROM_PARTS(0001, 01, 01)::date  -- Returns 0001-01-01 000:00:00 000
    END;






-- Unset existing masking policies in a column
ALTER TABLE CUSTOMERS MODIFY COLUMN CREATE_DATE 
UNSET MASKING POLICY;




-- set masking policy on a column:
ALTER TABLE CUSTOMERS MODIFY COLUMN CREATE_DATE
SET MASKING POLICY DATES_POLICY_2;






-- Change to ANALYST_MASKED
USE ROLE ANALYST_MASKED;


-- Test if dates are masked:
SELECT  * FROM CUSTOMERS;


















ok.... funcionou.





