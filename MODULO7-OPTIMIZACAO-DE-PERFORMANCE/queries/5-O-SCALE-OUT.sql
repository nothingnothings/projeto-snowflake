-- query complexa (milhoes de rows, operacoes de multiplicacao de rows) 
-- rodamos 5 vezes, em 5 worksheets, em paralelo (test de scale-out, autoscaling):




SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T1 -- 96 *
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T2  -- 96 *
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T3 -- 96 *
CROSS JOIN (SELECT TOP 50 * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE) T4; -- 50 = milhoes de rows.

