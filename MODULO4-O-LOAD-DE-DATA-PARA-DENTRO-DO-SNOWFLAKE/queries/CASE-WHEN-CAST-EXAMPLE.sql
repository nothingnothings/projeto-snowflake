







SELECT 
    customer_id, //column 1
    order_date, //column 2
    CASE
        WHEN CAST(order_total AS DECIMAL) >= 1000 THEN 'High'
        WHEN CAST(order_total AS DECIMAL) >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS order_category //column 3 (era para ser "order_total", mas manipulamos e criamos uma column de "order_category" com base nela).
FROM
    orders;




-- O FORMATO DO RESULT SET FICARIA ASSIM:

-- customer_id | order_date  | order_category
-- -----------------------------------------
-- 1           | 2023-06-15  | Medium
-- 2           | 2023-07-02  | High
-- 3           | 2023-06-29  | Low
-- 4           | 2023-07-05  | High
-- 5           | 2023-06-18  | Medium
