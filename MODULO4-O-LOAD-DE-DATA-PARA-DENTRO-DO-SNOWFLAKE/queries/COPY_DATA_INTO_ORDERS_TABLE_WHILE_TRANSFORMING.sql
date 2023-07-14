
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
  ORDER_ID VARCHAR(30),
  AMOUNT INT,
  PROFIT INT,
  PROFITABLE_FLAG VARCHAR(30)
);



COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX

-- CASE e CAST sao SQL FUNCTIONS... -- os fields sao $1 -> order_id, $2 -> amount, $3 -> profit, $4 -> profitable_flag
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            CASE
                  WHEN CAST(s.$3 as int) < 0 THEN 'not profitable' 
                  ELSE 'profitable' 
            END //column 4, nesse result set.
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');
