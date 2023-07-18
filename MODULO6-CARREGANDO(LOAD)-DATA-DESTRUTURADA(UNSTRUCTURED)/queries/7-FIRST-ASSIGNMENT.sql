If you have not created the database 
EXERCISE_DB then you can do so - otherwise use this database for this exercise.



1. Query from the previously created JSON_RAW  table.

Note: This table was created in the previous assignment (assignment 7) 
where you had to create a stage
 object that is pointing to
  's3://snowflake-assignments-mc/unstructureddata/'. 
 We have called the table JSON_RAW.





SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; 





2. Select the attributes

first_name

last_name

skills

and query these columns.




SELECT RAW_FILE:first_name,
RAW_FILE:last_name,
RAW_FILE:Skills

FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; 



3. The skills column contains an array. 
Query the first two values in the 
skills attribute for every record in a separate column:

first_name

last_name

skills_1

skills_2




SELECT RAW_FILE:first_name,
RAW_FILE:last_name,
RAW_FILE:Skills[0] as skills_1,
RAW_FILE:Skills[1] as skills_2
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; 



3. Create a table and insert 
the data for these 4 columns in that table.


CREATE TABLE skills_table AS
SELECT RAW_FILE:first_name as first_name,
RAW_FILE:last_name as last_name,
RAW_FILE:Skills[0] as skills_1,
RAW_FILE:Skills[1] as skills_2
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; 



Perguntas dessa tarefa
What is the first skill of the person with first_name 'Florina'?