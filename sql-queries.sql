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

