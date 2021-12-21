# SQL Questions - Classification

#(Use sub queries or views wherever necessary)

-- 1. Create a database called `credit_card_classification`.
CREATE DATABASE IF NOT EXISTS credit_card_classification;
USE credit_card_classification;

-- 2. Create a table `credit_card_data` with the same columns as given in the csv file. You can find the names of the headers for the table in the `creditcardmarketing.xlsx` file. 
-- Use the same column names as the names in the excel file. Please make sure you use the correct data types for each of the columns.
DROP TABLE IF EXISTS credit_card_data;

CREATE TABLE credit_card_data (
  `Customer Number` int UNIQUE NOT NULL, -- AS PRIMARY KEY
  `Offer Accepted` char(7) DEFAULT NULL,
  `Reward` varchar(20) DEFAULT NULL, -- char() , varchar(255)
  `Mailer Type` varchar(20) DEFAULT NULL,
  `Income Level` varchar(20) DEFAULT NULL,
  `# Bank Accounts Open` int DEFAULT NULL,
  `Overdraft Protection` char(7) DEFAULT NULL,
  `Credit Rating` varchar(7) DEFAULT NULL,
  `# Credit Cards Held` int DEFAULT NULL,
  `# Homes Owned` int DEFAULT NULL,
  `Household Size` int DEFAULT NULL,
  `Own Your Home` char(7) DEFAULT NULL,
  `Average Balance` float DEFAULT NULL,
  `Q1 Balance` float DEFAULT NULL,
  `Q2 Balance` float DEFAULT NULL,
  `Q3 Balance` float DEFAULT NULL,
  `Q4 Balance` float DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (`Customer Number`)  -- constraint keyword is optional but its a good practice
);

SELECT * FROM credit_card_data;

-- 3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. 
-- (in this case we have already deleted the header names from the csv files). To not modify the original data, if you want you can create a copy of the csv file as well. 
-- Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
-- Step 2
SHOW VARIABLES LIKE 'secure_file_priv'; -- this gives you the path you need to save the .csv to
-- Step 3
SET sql_safe_updates = 0;

LOAD DATA INFILE 'creditcardmarketing_no_headers.csv' 
INTO TABLE credit_card_classification.credit_card_data
FIELDS TERMINATED BY ',';

/*```sql
SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go

SET GLOBAL local_infile = 1;
```*/

SELECT COUNT(`Customer Number`) FROM credit_card_classification.credit_card_data;

-- 4.  Select all the data from table `credit_card_data` to check if the data was imported correctly.
SELECT * FROM credit_card_data;
/* I noticed that 17976 rows were imported from the .csv file, whereas in the excel I can see 18000 rows.
I am not sure where these 24 rows are; perhaps the rows with NaNs were not imported.*/

-- 5.  Use the _alter table_ command to drop the column `q4_balance` from the database, as we would not use it in the analysis with SQL. 
-- Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_classification.credit_card_data
DROP COLUMN `Q4 Balance`;

SELECT * FROM credit_card_classification.credit_card_data
LIMIT 10;

-- 6.  Use sql query to find how many rows of data you have.
SELECT COUNT(`Customer Number`) FROM credit_card_classification.credit_card_data;

-- 7.  Now we will try to find the unique values in some of the categorical columns:
	-- What are the unique values in the column `Offer_accepted`?
SELECT DISTINCT `Offer Accepted` FROM credit_card_classification.credit_card_data;

	-- What are the unique values in the column `Reward`?
SELECT DISTINCT `Reward` FROM credit_card_classification.credit_card_data;

    -- What are the unique values in the column `mailer_type`?
SELECT DISTINCT `Mailer Type` FROM credit_card_classification.credit_card_data;

    -- What are the unique values in the column `credit_cards_held`?
SELECT DISTINCT `# Credit Cards Held` FROM credit_card_classification.credit_card_data;

    -- What are the unique values in the column `household_size`?
SELECT DISTINCT `Household Size` FROM credit_card_classification.credit_card_data;

-- 8.  Arrange the data in a decreasing order by the `average_balance` of the house. 
-- Return only the `customer_number` of the top 10 customers with the highest `average_balances` in your data.
SELECT `Customer Number` FROM credit_card_classification.credit_card_data
ORDER BY `Average Balance` DESC
LIMIT 10;

-- 9.  What is the average balance of all the customers in your data?
SELECT AVG(`Average Balance`) FROM credit_card_classification.credit_card_data;

-- 10. In this exercise we will use  `group by` to check the properties of some of the categorical variables in our data.

-- Note wherever `average_balance` is asked in the questions below, please take the average of the column `average_balance`: 
    -- What is the average balance of the customers grouped by `Income Level`? The returned result should have only two columns, 
    -- income level and `Average balance` of the customers. Use an alias to change the name of the second column.
SELECT `Income Level`, ROUND(AVG(`Average Balance`),2) AS avg_balance FROM credit_card_classification.credit_card_data
GROUP BY `Income Level`;

    -- What is the average balance of the customers grouped by `number_of_bank_accounts_open`? 
    -- The returned result should have only two columns, `number_of_bank_accounts_open` and `Average balance` of the customers. 
    -- Use an alias to change the name of the second column.
SELECT * FROM credit_card_classification.credit_card_data;
SELECT `# Bank Accounts Open`, ROUND(AVG(`Average Balance`),2) AS avg_balance FROM credit_card_classification.credit_card_data
GROUP BY `# Bank Accounts Open`;

    -- What is the average number of credit cards held by customers for each of the credit card ratings? 
    -- The returned result should have only two columns, rating and average number of credit cards held. 
    -- Use an alias to change the name of the second column.
SELECT * FROM credit_card_classification.credit_card_data;
SELECT `Credit Rating`, ROUND(AVG(`# Credit Cards Held`),1) AS avg_cards_held 
FROM credit_card_classification.credit_card_data
GROUP BY `Credit Rating`;

    -- Is there any correlation between the columns `credit_cards_held` and `number_of_bank_accounts_open`? 
    -- You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 
    -- Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
    -- You might also have to check the number of customers in each category (ie number of credit cards held) to assess 
    -- if that category is well represented in the dataset to include it in your analysis. For eg. If the category is 
    -- under-represented as compared to other categories, ignore that category in this analysis.
    
SELECT `# Credit Cards Held`, 
ROUND(SUM(`# Bank Accounts Open`),1) AS total_accounts_open, 
ROUND(AVG(`# Bank Accounts Open`),1) AS avg_accounts_open
FROM credit_card_classification.credit_card_data
GROUP BY `# Credit Cards Held`
ORDER BY `# Credit Cards Held`;

SELECT `# Bank Accounts Open`, 
ROUND(SUM(`# Credit Cards Held`),1) AS total_cards_held,
ROUND(AVG(`# Credit Cards Held`),1) AS avg_cards_held 
FROM credit_card_classification.credit_card_data
GROUP BY `# Bank Accounts Open`
ORDER BY `# Bank Accounts Open`;

/*There is an apparent negative correlation between bank_accounts_open and total_cards_held: the more accounts open,
the lower the sum of cards held.*/

-- 11. Your managers are only interested in the customers with the following properties:

    -- Credit rating medium or high
    -- Credit cards held 2 or less
    -- Owns their own home
    -- Household size 3 or more

-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? 
-- Can you filter the customers who accepted the offers here?

# Query for the managers' request
SELECT *
FROM credit_card_classification.credit_card_data
WHERE (`Credit Rating` <> 'Low' 
AND `# Credit Cards Held` <= 2 
AND `Own Your Home` = 'Yes' 
AND `Household Size` >=3
);

# Query with Offer Accepted as 'Yes'
WITH cte_manager_request AS (
SELECT *
FROM credit_card_classification.credit_card_data
WHERE (`Credit Rating` <> 'Low' 
AND `# Credit Cards Held` <= 2 
AND `Own Your Home` = 'Yes' 
AND `Household Size` >=3
))
SELECT * FROM cte_manager_request
WHERE `Offer Accepted` = 'Yes';

-- 12. Your managers want to find out the list of customers whose average balance is less than the average balance of 
-- all the customers in the database. Write a query to show them the list of such customers. 
-- You might need to use a subquery for this problem.

SELECT `Customer Number`, `Average Balance`, 
AVG(`Average Balance`) OVER() AS global_avg_balance
FROM credit_card_classification.credit_card_data
WHERE `Average Balance`< (
SELECT ROUND(AVG(`Average Balance`),2) 
FROM credit_card_classification.credit_card_data
);

-- 13. Since this is something that the senior management is regularly interested in, 
-- create a view called `Customers__Balance_View1` of the same query.

CREATE VIEW Customers__Balance_View1 AS
SELECT `Customer Number`, `Average Balance`
FROM credit_card_classification.credit_card_data
WHERE `Average Balance`< (
SELECT ROUND(AVG(`Average Balance`),2) 
FROM credit_card_classification.credit_card_data
);

-- 14. What is the number of people who accepted the offer vs number of people who did not?
SELECT `Offer Accepted` as offer_accepted, COUNT(*) as count
FROM credit_card_classification.credit_card_data 
GROUP BY `Offer Accepted` 
ORDER BY count;

-- 15. Your managers are more interested in customers with a credit rating of high or medium. 
-- What is the difference in average balances of the customers with high credit card rating and low credit card rating?
WITH cte AS (
SELECT `Credit Rating`, ROUND(AVG(`Average Balance`),2) AS avg_bal_per_rating
FROM  credit_card_classification.credit_card_data
WHERE `Credit Rating` <> 'Low'
GROUP BY `Credit Rating`
ORDER BY `Credit Rating` DESC
)
SELECT ROUND(MAX(avg_bal_per_rating)-MIN(avg_bal_per_rating),2) 
AS high_minus_medium_rating
FROM cte;

-- 16. In the database, which all types of communication (`mailer_type`) were used and with how many customers?
SELECT `Mailer Type`, COUNT(`Customer Number`) AS count_customers
FROM credit_card_classification.credit_card_data
GROUP BY `Mailer Type`;

-- 17. Provide the details of the customer that is the 11th least `Q1_balance` in your database.
WITH cte AS (
SELECT * FROM credit_card_classification.credit_card_data
ORDER BY `Q1 Balance`
LIMIT 11
)
SELECT * FROM cte
ORDER BY `Q1 Balance` DESC
LIMIT 1;