-- Assume we want to create a share from the database CUSTOMER_DB and share the table CUSTOMERS.

-- Database: CUSTOMER_DB

-- Schema: PUBLIC

-- Table: CUSTOMERS

-- Provider account: asd163257

-- Consumer account: sdw135733



-- 1. How can we create a share object called CUSTOMER_SHARE and grant sufficient grant privileges (use sql commands)?



CREATE OR REPLACE SHARE CUSTOMER_SHARE;

GRANT USAGE ON DATABASE CUSTOMER_DB TO SHARE CUSTOMER_SHARE;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO SHARE CUSTOMER_SHARE;

GRANT SELECT ON TABLE CUSTOMER_DB.PUBLIC.CUSTOMERS TO SHARE CUSTOMER_SHARE;




-- 2. How can we add the consumer account (sql commands)?


ALTER SHARE CUSTOMER_SHARE
ADD ACCOUNT = sdw135733;



Perguntas dessa tarefa
How can we create a share object called CUSTOMER_SHARE and grant sufficient grant privileges (provide sql commands)?

How can we add the consumer account (provide sql commands)?