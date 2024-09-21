--SQL Retail Sales Analysis -P1
CREATE DATABASE sql_project_p2;

--Create Table
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR (15),
	age INT,
	category VARCHAR (15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);

-- 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

-- Cleaning Data
SELECT* FROM retail_sales
WHERE sale_date IS NULL
OR
sale_time IS NULL
OR 
gender IS NULL
OR 
transactions_id IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL 
OR 
total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE sale_date IS NULL
OR
sale_time IS NULL
OR 
gender IS NULL
OR 
transactions_id IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL 
OR 
total_sale IS NULL;

-- Data exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

--How many unique costumers?
SELECT COUNT (DISTINCT customer_id) as number_customers
FROM retail_sales;

--Data Analyst problems

--Sales where on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Sales where the category is clothing and  and the quanitity sold is more than 4 for the month Nov-2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing' AND 
TO_CHAR (sale_date,'YYYY-MM')= '2022-11' AND 
quantiy >=4; 

--Total Sales for each category
SELECT 
	SUM(total_sale) as net_sales,
	Count (*) as total_orders,
	category
FROM retail_sales
Group by category;

-- AVG age of customers who bought beauty products
SELECT
	ROUND(AVG (age),2) as avg_age
FROM
	retail_sales
WHERE category= 'Beauty';

--Transactions where the total sales is greater than 1000
SELECT *
FROM retail_sales
WHERE
total_sale > 1000;

--Total number of transactions made by each gender in each category

SELECT 
	Count (DISTINCT transactions_id) as number_transactions,
	gender,
	category
FROM
retail_sales
Group by category,
	gender
Order by 
	number_transactions DESC

-- Average sale for each month. Find the best-selling month in each year.
SELECT 
	year,
	month,
	average_sales
FROM
		( 
SELECT 
		Extract (MONTH from sale_date) as month,
		Extract (Year from sale_date) as year,
		AVG (total_sale) as average_sales,
		RANK()OVER (PARTITION BY EXTRACT (year FROM sale_date)ORDER BY AVG (total_sale) DESC) as rank
	FROM retail_sales
	Group by month, year
	)
WHERE rank=1;

-- Top 5 customers with highest sales
SELECT 
	customer_id,
	SUM (total_sale) AS total_sales
FROM retail_sales
Group by customer_id
Order by total_sales DESC
LIMIT 5;

-- Number of unique costumers who purchased items from each category.
SELECT 
	category,
	COUNT (DISTINCT customer_id) as number_of_customers
FROM retail_sales
Group by category

--Number of orders for each shift.
WITH hourly_sale 
AS
	(
	SELECT 
		CASE 
		WHEN EXTRACT (HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as shift
	FROM retail_sales
	)
SELECT shift,
COUNT (*) as total_orders 
FROM hourly_sale
GROUP BY shift

--End of project

	

	