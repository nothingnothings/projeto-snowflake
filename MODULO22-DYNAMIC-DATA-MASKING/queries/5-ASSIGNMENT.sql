1. Prepare the table and two roles to test the masking policies (you can use the statement below)

USE DEMO_DB;
USE ROLE ACCOUNTADMIN;
 
-- Prepare table --
create or replace table customers(
  id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  spent number,
  create_date DATE DEFAULT CURRENT_DATE);
 
 
-- insert values in table --
insert into customers (id, full_name, email,phone,spent)
values
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);
 
 
-- set up roles
CREATE OR REPLACE ROLE ANALYST_MASKED;
CREATE OR REPLACE ROLE ANALYST_FULL;


-- grant usage on database to roles 

GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_MASKED;
GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_FULL;

 
-- grant select on table to roles
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_MASKED;
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_FULL;
 
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_MASKED;
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_FULL;
 
-- grant warehouse access to roles
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_MASKED;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_FULL;
 
-- assign roles to a user
GRANT ROLE ANALYST_MASKED TO USER NOTHINGNOTHINGS;
GRANT ROLE ANALYST_FULL TO USER NOTHINGNOTHINGS;


2. Create masking policy called name that is showing '***' instead of the original varchar value, except the role analyst_full is used in this case show the original value.


CREATE OR REPLACE MASKING POLICY NAME
AS 
(VAL VARCHAR) RETURNS VARCHAR -> 
    CASE 
        WHEN CURRENT_ROLE() IN ('ANALYST_FULL') THEN VAL
        ELSE '***'
    END;


3. Apply the masking policy on the column full_name


ALTER TABLE CUSTOMERS MODIFY COLUMN FULL_NAME 
SET MASKING POLICY NAME;

4. Unset the policy


ALTER TABLE CUSTOMERS MODIFY COLUMN FULL_NAME 
UNSET MASKING POLICY;



5. Validate the result using the role analyst_masked and analyst_full

-- validate masked
USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

-- validate full
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

-- set policy
USE ROLE ACCOUNTADMIN;
ALTER TABLE CUSTOMERS MODIFY COLUMN FULL_NAME 
SET MASKING POLICY NAME;

-- validate masked
USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

-- validate full
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;




6. Alter the policy so that the last two characters are shown and before that only '***' (example: ***er)

USE ROLE ACCOUNTADMIN;

ALTER MASKING POLICY NAME
SET BODY -> 
CASE
    WHEN CURRENT_ROLE() IN ('ANALYST_FULL') THEN VAL
    ELSE CONCAT('***', RIGHT(val, 2))
END;





7. Apply the policy again on the column full name and validate the policy



-- Unset policy.
ALTER TABLE CUSTOMERS MODIFY COLUMN FULL_NAME 
UNSET MASKING POLICY;

-- Set policy/apply policy
ALTER TABLE CUSTOMERS MODIFY COLUMN FULL_NAME 
SET MASKING POLICY NAME;



-- Validate policy -- 

-- validate masked
USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

-- validate full
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;


