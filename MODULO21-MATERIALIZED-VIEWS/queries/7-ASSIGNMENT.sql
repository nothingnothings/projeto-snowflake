

-- CREATE A MATERIALIZED VIEW:




-- Create a materialized view called PARTS in the database DEMO_DB from the following statement:

 -- SELECT 
 -- AVG(PS_SUPPLYCOST) as PS_SUPPLYCOST_AVG,
 -- AVG(PS_AVAILQTY) as PS_AVAILQTY_AVG,
 -- MAX(PS_COMMENT) as PS_COMMENT_MAX
 -- FROM"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."PARTSUPP";




 -- Materialized view: --
    CREATE OR REPLACE MATERIALIZED VIEW PARTS 
    AS
    SELECT 
        AVG(PS_SUPPLYCOST) as PS_SUPPLYCOST_AVG,
        AVG(PS_AVAILQTY) as PS_AVAILQTY_AVG,
        MAX(PS_COMMENT) as PS_COMMENT_MAX
        FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."PARTSUPP";




--  Execute the SELECT before creating the materialized view and note down the time until the query is executed.


     SELECT 
 AVG(PS_SUPPLYCOST) as PS_SUPPLYCOST_AVG,
 AVG(PS_AVAILQTY) as PS_AVAILQTY_AVG,
 MAX(PS_COMMENT) as PS_COMMENT_MAX
 FROM"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."PARTSUPP";


SELECT * FROM PARTS;
    -- common select:  5.3s
    -- materialized view:  589ms




Perguntas dessa tarefa
How long did the SELECT statement take initially? 5.3s

How long did the execution of the materialized view take? 589ms