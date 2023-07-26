










QUANDO DEVEMOS USAR MATERIALIZED VIEWS,


EIS A QUESTAO...











AGORA QUE VIMOS QUE EXISTEM MAINTENANCE COSTS,


JUNTO COM OS BENEFÍCIOS DAS MATERIALIZED VIEWS,





QUEREMOS DAR 1 OLHADA NAS CONSIDERACOES QUE DEVEMOS TER,


ANTES DE CRIARMOS 1 MATERIALIZED VIEW....
















--> NESSA LECTURE, VEREMOS:





1) OS USE-CASES EM QUE 

CRIAR 1 MATERIALIZED VIEW FAZ SENTIDO...



2) QUAIS SAO ALGUMAS ALTERNATIVAS 
ÀS MATERIALIZED VIEWS...


















USE-CASES (quando deve ser usada 1 materialized view):








1) SABEMOS QUE 1 VIEW MUITAS VEZES 

DEMORA MT TEMPO PARA SER PROCESSADA... --> E ESSA É UMA SITUACAO/USE-CASE 
POSSÍVEL,

ISSO SE ESSA QUERY/VIEW  FOR/É USADA COM MT FREQUENCIA NO SEU APP...




NESSES CASOS, USARÍAMOS UMA MATERIALIZED VIEW, criaríamos uma...














QUANDO NAO DEVEMOS USAR:





1) QUANDO __sABEMOS_ QUE A UNDERLYING DATA __ VAI 

MUDAR COM MT FREQUENCIA, E EM UMA REGULAR-BASIS....

(
    aí nao vale a pena, nem um pouco...
)

















QUER DIZER QUE DEVEMOS CRIAR 1 MV SE:






1) temos uma view/query que é processada muitas e muitas vezes 
no nosso app, e que demora bastante para ser processada 




2) SE TEMOS DATA QUE NAO É UPDATADA FREQUENTEMENTE,

POUQUÍSSIMAS CHANGES AO LONGO DO MES/ANO... (bem menos do que 1 vez 
por semana)



















OUTRO DETALHE --> SE A TABLE FOR MUITO LARGA,



ISSO SE TORNA OUTRO PROBLEMA...


PQ SE A DATA MUDAR CONSTANTEMENTE,
 TEREMOS AINDA MAIS CUSTOS....

















 IDEAL USE-CASE:







 1) A UNDERLYING DATA NAO É MUDADA COM FREQUENCIA...


 2) A UNDERLYING DATA É _ GRANDE 



 3) A UNDERLYING DATA DEMORA _PARA SER QUERIADA (TANTO 1 TABLE COMO VIEW)...





-----------------------------------------------













SE A DATA __ É ALTERADA__ EM 1 VERY REGULAR BASIS, COM FREQUENCIA,

TEMOS OUTRAS ALTERNATIVAS BOAS PARA ELA, PARA DIMINUIR O QUERY TIME..




TEMOS:








1) TASKS E STREAMS... -> ESSA PODE SER UMA ALTERNATIVA
___bEM MELHOR...


** PODEMOS ACTUALLY __ rEBUILD__ ALGO __ PARECIDO __ 
COM A MATERIALIZED VIEW... ---------_> OU SEJA,

PODEMOS 

CRIAR 

1 

TABLE QUE CONTENHA __ APENAS __ A DATA DAQUELE SELECT STATEMENT
NECESSÁRIO (daquela ""materialized view""),




MAS 1 TABLE QUE SERIA ATUALIZADA COM EMPREGO 

DE _ _tASKS__ E STREAMS___...



---------------------------------












POR EXEMPLO, SE TIVERMOS 1 UNDERLYING TABLE,



e se o statement (Select/view) FOR RODADO A PARTIR 


DESSA TABLE,


em vez de armazenarmos essa query em 1 materialized view,







PODEMOS CRIAR 1 __ TASK__ COM 1 COMANDO SQL DE MERGE,



EXATAMENTE COMO VIMOS NOS MÓDULOS ANTERIORES,





um comando de MERGE QUE SERIA EXECUTADO "ON A REGULAR BASIS",




TALVEZ 1 VEZ POR SEMANA, POR EXEMPLO,


colocaríamos 1 schedule 


nessa task,





QUE ENTAO FARIA O MERGE DESSAS CHANGES NA NOSSA TABLE...





-----------------------------







E É CLARO QUE PODERÍAMOS COMBINAR ESSA TASK DE MERGE 


COM __ 1 STREAM OBJECT,



COLOCAR 1 STREAM OBJECT EM CIMA 

__ DA ORIGINAL TABLE/SOURCE TABLE,




E AÍ __ MONITORAR ___ SE EXISTEM QUAISQUER CHANGES....







SE OCORREREM QUAISQUER CHANGES,

EXECUTAMOS 1 COMANDO SQL NA TASK DE MERGE QUE CRIAMOS,

PARA FAZER

MERGE 

DAS CHANGES 


DO STREAM OBJECT DIRETAMENTE NA "FINAL TABLE" (que 
será praticamente uma ""materialized view"" de camelô)...

















-> com isso, podemos REALMENTE CONSTRUIR UMA 

ALTERNATIVA QUE 



ESSENCIALMENTE FARÁ A MESMA COISA QUE 

UMA MATERIALIZED VIEW,



MAS COM BEM MENOS CUSTOS, E COM UM FUNCIONAMENTO DIFERENTE.









-> PODE SER MAIS BARATO, E PODEMOS TER MAIS CONTROLE 

SOBRE TODA A OPERACAO (colocar diferentes schedules, etc)...





-------------------------------------------------------


ok, mas e quanto à velocidade?



ela ainda será lenta,


com esse esquema de tasks com stream objects...



---------------------------














OK, MAS QUAIS SAO OS USE-CASES PARA 1 MATERIALIZED VIEW:







1) NAO USE MATERIALIZED VIEWS SE SUAS DATA CHANGES 
SAO MT FREQUENTES, E SE A UNDERLYING TABLE TEM UMA QUANTIDADE 
MT GRANDE DE DATA...







2) SEMPRE DEVEMOS TER O MAINTENANCE COST NA MENTE....




3) SE TIVERMOS OUTRAS ALTERNATIVAS,

PODEMOS 

LEVERAGE OUTRAS FEATURES BUILT-IN DO SNOWFLAKE,

COMO STREAMS E TASKS,

PARA 

CONSTRUIR 1 SOLUCAO NÓS MESMOS...








SOBRE ISSO, O CHATGPT NOS EXPLICA:







https://chat.openai.com/share/947d376a-0546-409f-8bf9-79686444f98b



















VISTO TUDO ISSO,



DEVEMOS VER ALGUMAS DAS LIMITACOES QUE PODEMOS 

ENFRENTAR, QUANDO CRIAMOS 

MATERIALIZED VIEWS....



















Arthur:
In snowflake SQL, how to have fast query times using a view, streams and Tasks











To achieve fast query times in Snowflake SQL using a combination of views, streams, and tasks, you can take advantage of Snowflake's data processing capabilities and automation features. Here's a step-by-step guide on how to approach this:

Create a Materialized View:
A materialized view is a precomputed
 snapshot of data that can significantly
  improve query performance by reducing 
  the need to process complex joins and aggregations
   in real-time. You can
    create a materialized view on top
     of your base tables using your desired
      query logic. Materialized views are
       automatically maintained by Snowflake,
        so you don't need to worry about updating 
        them manually.



CREATE MATERIALIZED VIEW my_materialized_view AS
SELECT
    col1,
    col2,
    SUM(col3) AS sum_col3
FROM
    my_table
GROUP BY
    col1, col2;













Use a Stream to Capture Changes:
Snowflake streams capture changes
 made to a table in real-time. Streams
  can be useful when you want to track modifications 
  to the base tables and apply those changes
   to the materialized view efficiently.





CREATE STREAM my_stream ON TABLE my_table;

Create a Task to Refresh the Materialized View:
Snowflake tasks allow you
 to schedule actions to be performed
  at specific intervals. In this case,
   you can create a task that runs at 
   regular intervals to refresh the materialized
    view using the changes captured in the stream.






CREATE TASK my_refresh_task
WAREHOUSE = my_warehouse
SCHEDULE = '5 MINUTE'
WHEN
    SYSTEM$STREAM_HAS_DATA('my_stream')
AS
BEGIN
    REFRESH MATERIALIZED VIEW my_materialized_view;
END;






In this example, the task is 
scheduled to run every 5 minutes
 (adjust the schedule according to your needs).
  The task checks whether there are any new 
  changes in the stream using the
   SYSTEM$STREAM_HAS_DATA function, and if so,
    it triggers the refresh of the materialized view.






Query the Materialized View:
Now, you can query the materialized
 view just like any other table, and 
 Snowflake will use the precomputed results
  to provide faster query responses.







SELECT * FROM my_materialized_view WHERE col1 = 'some_value';





With this setup, 
Snowflake will automatically maintain 
the materialized view and keep it up to date with 
the changes from the base table, resulting in 
faster query times for your analyses. Note
 that the actual performance gains may depend 
 on the complexity of your underlying data 
 and the frequency of updates. Always test
  and optimize your approach based on your 
  specific use case.











Arthur:


But the costs of materialized
 views are too high, and my database updates
  are frequent; I need an approach
   that does not use materialized views













If materialized
 views are not suitable for your use case due
  to the cost and frequency of updates,
   you can still improve query performance using a
    combination of views, streams, and tasks
     without creating materialized views.
      Instead, you can use the stream data 
      directly to enhance the efficiency of 
      your queries. Here's an alternative approach:






Create a Stream:
As mentioned before, streams
 in Snowflake capture changes made 
 to a table in real-time.





CREATE STREAM my_stream ON TABLE my_table;


Create a View to Process Stream Data:
Instead of materializing the data, you can 
create a view that processes the data directly
 from the stream. The view will read data from 
 the stream and apply any necessary 
 transformations or aggregations on-the-fly.











CREATE OR REPLACE VIEW my_stream_view AS
SELECT
    col1,
    col2,
    SUM(col3) AS sum_col3
FROM
    my_stream
GROUP BY
    col1, col2;






Create a Task to Schedule View Refresh:
Now, you can create a
 task to refresh the view at regular 
 intervals, just like in the previous approach.






 CREATE TASK my_refresh_task
WAREHOUSE = my_warehouse
SCHEDULE = '5 MINUTE'
WHEN
    SYSTEM$STREAM_HAS_DATA('my_stream')
AS
BEGIN
    CREATE OR REPLACE VIEW my_stream_view AS
    SELECT
        col1,
        col2,
        SUM(col3) AS sum_col3
    FROM
        my_stream
    GROUP BY
        col1, col2;
END;





Query the View:





With the view now refreshing 
periodically using the stream data, 
you can query it just like any other table.
 The view will always reflect the most 
 up-to-date information from the stream.












By using this approach, you're not materializing the 
data, which may help reduce costs and accommodate
 frequent updates. The view will process the stream
  data in real-time, providing relatively fast query
   times. As before, remember to optimize the view's 
   query logic and test the performance to ensure it 
   meets your requirements.







But won't the query be slower than
 a materialized view? Answer in a few words



Yes, querying a live view with 
real-time processing can be slower than querying 
a precomputed materialized view.












