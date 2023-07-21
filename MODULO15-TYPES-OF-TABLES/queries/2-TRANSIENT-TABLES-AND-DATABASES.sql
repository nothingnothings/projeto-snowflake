-- Create permanent database 
CREATE OR REPLACE DATABASE TDB;





-- Create transient table 
CREATE OR REPLACE TRANSIENT TABLE TDB.public.customers_transient (
        ID INT,
        FIRST_NAME STRING,
        LAST_NAME STRING,
        EMAIL STRING,
        GENDER STRING,
        JOB STRING,
        PHONE STRING
);


TRUNCATE TABLE customers_transient;


INSERT INTO OUR_FIRST_DB.public.customers (ID, FIRST_NAME, LAST_NAME, EMAIL, GENDER, JOB, PHONE) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'Male', 'Software Engineer', '(123) 456-7890'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'Female', 'Data Analyst', '(987) 654-3210'),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', 'Male', 'Project Manager', '(555) 123-4567'),
(4, 'Emily', 'Williams', 'emily.williams@example.com', 'Female', 'Graphic Designer', '(111) 222-3333'),
(5, 'James', 'Brown', 'james.brown@example.com', 'Male', 'Marketing Specialist', '(444) 555-6666'),
(6, 'Susan', 'Anderson', 'susan.anderson@example.com', 'Female', 'HR Manager', '(777) 888-9999'),
(7, 'Robert', 'Miller', 'robert.miller@example.com', 'Male', 'Accountant', '(222) 333-4444'),
(8, 'Linda', 'Thomas', 'linda.thomas@example.com', 'Female', 'Sales Representative', '(666) 777-8888'),
(9, 'William', 'Jackson', 'william.jackson@example.com', 'Male', 'UX Designer', '(999) 888-7777'),
(10, 'Sarah', 'White', 'sarah.white@example.com', 'Female', 'Product Manager', '(555) 444-3333'),
(11, 'Michael', 'Clark', 'michael.clark@example.com', 'Male', 'Data Scientist', '(111) 222-3333'),
(12, 'Elizabeth', 'Hall', 'elizabeth.hall@example.com', 'Female', 'Software Developer', '(444) 555-6666'),
(13, 'David', 'Allen', 'david.allen@example.com', 'Male', 'Marketing Manager', '(777) 888-9999'),
(14, 'Mary', 'Lee', 'mary.lee@example.com', 'Female', 'Financial Analyst', '(222) 333-4444'),
(15, 'Christopher', 'Scott', 'christopher.scott@example.com', 'Male', 'Operations Manager', '(666) 777-8888'),
(16, 'Karen', 'Adams', 'karen.adams@example.com', 'Female', 'Content Writer', '(999) 888-7777'),
(17, 'Matthew', 'Campbell', 'matthew.campbell@example.com', 'Male', 'Graphic Designer', '(555) 444-3333'),
(18, 'Jennifer', 'Evans', 'jennifer.evans@example.com', 'Female', 'HR Coordinator', '(111) 222-3333'),
(19, 'Joshua', 'Morris', 'joshua.morris@example.com', 'Male', 'Account Manager', '(444) 555-6666'),
(20, 'Michelle', 'Rogers', 'michelle.rogers@example.com', 'Female', 'Web Developer', '(777) 888-9999'),
(21, 'Andrew', 'Reed', 'andrew.reed@example.com', 'Male', 'UX/UI Designer', '(222) 333-4444'),
(22, 'Amy', 'Baker', 'amy.baker@example.com', 'Female', 'Software Engineer', '(555) 123-4567'),
(23, 'Thomas', 'Cook', 'thomas.cook@example.com', 'Male', 'Data Analyst', '(987) 654-3210'),
(24, 'Jessica', 'Murphy', 'jessica.murphy@example.com', 'Female', 'Project Manager', '(555) 987-6543'),
(25, 'Matthew', 'Bell', 'matthew.bell@example.com', 'Male', 'Graphic Designer', '(111) 222-3333'),
(26, 'Lauren', 'Bailey', 'lauren.bailey@example.com', 'Female', 'Marketing Specialist', '(444) 555-6666'),
(27, 'Steven', 'Sanders', 'steven.sanders@example.com', 'Male', 'HR Manager', '(777) 888-9999'),
(28, 'Emily', 'Russell', 'emily.russell@example.com', 'Female', 'Accountant', '(222) 333-4444'),
(29, 'Kevin', 'Parker', 'kevin.parker@example.com', 'Male', 'Sales Representative', '(666) 777-8888'),
(30, 'Laura', 'Ward', 'laura.ward@example.com', 'Female', 'UX Designer', '(999) 888-7777'),
(31, 'Jonathan', 'Morris', 'jonathan.morris@example.com', 'Male', 'Product Manager', '(555) 444-3333'),
(32, 'Stephanie', 'Allen', 'stephanie.allen@example.com', 'Female', 'Data Scientist', '(111) 222-3333'),
(33, 'Ryan', 'Perry', 'ryan.perry@example.com', 'Male', 'Software Developer', '(444) 555-6666'),
(34, 'Heather', 'Roberts', 'heather.roberts@example.com', 'Female', 'Marketing Manager', '(777) 888-9999'),
(35, 'Jason', 'Howard', 'jason.howard@example.com', 'Male', 'Financial Analyst', '(222) 333-4444'),
(36, 'Amanda', 'Flores', 'amanda.flores@example.com', 'Female', 'Operations Manager', '(666) 777-8888'),
(37, 'Charles', 'Mitchell', 'charles.mitchell@example.com', 'Male', 'Content Writer', '(999) 888-7777'),
(38, 'Kelly', 'Bailey', 'kelly.bailey@example.com', 'Female', 'Graphic Designer', '(555) 444-3333'),
(39, 'Nicholas', 'Garcia', 'nicholas.garcia@example.com', 'Male', 'HR Coordinator', '(111) 222-3333'),
(40, 'Erica', 'Cox', 'erica.cox@example.com', 'Female', 'Account Manager', '(444) 555-6666'),
(41, 'Daniel', 'Stewart', 'daniel.stewart@example.com', 'Male', 'Web Developer', '(777) 888-9999'),
(42, 'Megan', 'Kelly', 'megan.kelly@example.com', 'Female', 'UX/UI Designer', '(222) 333-4444'),
(43, 'Justin', 'Rogers', 'justin.rogers@example.com', 'Male', 'Software Engineer', '(555) 123-4567');





INSERT INTO TDB.public.customers_transient
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1
CROSS JOIN(SELECT * FROM OUR_FIRST_DB.public.customers) t2; --1849 rows







SHOW TABLES; -- shows new, transient table








-- Query Storage 


SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;











-- --> O PROFESSOR ENTAO EXECUTA 




-- SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;






-- ok... mas essa table NAO ESTÁ MOSTRANDO O NOME DE NOSSA NOVA TABLE, POR ALGUMA RAZAO.. (
--     customers_transient..
-- )


-- --> O PROFESSOR DIZ QUE DEMORA UM POUCO PARA ESSA TABLE SER UPDATADA (
--     é por isso que nao enxerguei essa table... (a de transient)
-- )





-- OK... MAS O QUE INTERESSA É QUE, EM TRANSIENT TABLES,

-- OS FAILSAFE BYTES 



-- FICAM COMO 0... --> NAO EXISTE FAILSAFE STORAGE AREA PARA ESSAS TRANSIENT TABLES..


-- --> É ISSO QUE PRECISAMOS SABER...










-- ADICIONALMENTE,

-- SE RODARMOS ESTE COMANDO:


-- Set retention time to 0 
ALTER TABLE TDB.public.customers_transient
SET DATA_RETENTION_TIME_IN_DAYS = 0;




-- DESABILITAMOS O RECURSO DE ""TIME TRAVEL"" 

-- DESSA TRANSIENT TABLE (
--     fazendo com que a data 

--     ALTERADA/APAGADA DESSA TABLE, E A TABLE EM SI,

--     SEJAM UNRECOVERABLE EM CASO 

--     DE ACIDENTES... --> pq ficamos sem nenhum dia para ""voltar atrás"",
--     e também ficamos sem o failsafe....
-- )





-- SEM FAILSAFE, SEM TIMETRAVEL, se rodarmos esse comando de alter table...











-- OUTRO DETALHE.... --> VOCE NAO TEM A POSSIBILIDADE DE 



-- DEFINIR UM VALUE ENTRE 0 e 1, DENTRO DE 



-- DATA_RETENTION_TIME_IN_DAYS.... ------> PQ APENAS TEMOS A POSSIBILIDADE 

-- DE DEFINIR ESSES  VALUES 


-- COMO 1 OU 0... (

--     e essa restricao existe em todas as transient tables...
-- )