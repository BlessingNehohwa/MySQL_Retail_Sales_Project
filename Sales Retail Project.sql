CREATE DATABASE Retail_sales;
 
 
CREATE TABLE retail_sales_analysis
			(	transaction_id INT ,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR (15),
				age   INT,
				category  VARCHAR(15),
				quantity  INT,
				price_per_unit  FLOAT,
				cogs    FLOAT,
				total_sales FLOAT
);

SELECT 
		COUNT(*)
FROM retail_sales_analysis;

SELECT *
FROM retail_sales_analysis;

-- CHECKING FOR DUPLICATES
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY transaction_id, sale_date,sale_time, customer_id,gender,age,category,quantity, price_per_unit,cogs,total_sales) AS row_num
FROM retail_sales_analysis;  -- If there are no duplicates it means there is duplicates



-- Checking for Null values in the dataset
SELECT *
FROM retail_sales_analysis
WHERE 	transaction_id IS NULL
		OR   
        sale_time IS NULL
        OR   
        sale_date IS NULL
        OR   
        customer_id IS NULL
        OR   
        gender IS NULL
        OR   
        age IS NULL
        OR   
        category IS NULL
        OR   
        quantity IS NULL
        OR   
        price_per_unit IS NULL
        OR   
        cogs IS NULL
        OR   
        total_sales IS NULL;
        

SELECT *
FROM retail_sales_analysis;


-- EXPLORATORY DATA ANALYSIS (EDA) 

-- Checking how many total transcations we had for the period.
SELECT COUNT(*)
AS total_sales 
FROM retail_sales_analysis;    -- we  have 1987 total transactions


-- How many unique customers do we have in the dataset
SELECT  COUNT(DISTINCT customer_id)
FROM retail_sales_analysis; -- we had 155 customers buying from our shop.

-- checking number of different product categories
SELECT COUNT(DISTINCT category)
FROM retail_sales_analysis; -- we have 3 different product categories


-- DATA ANALYSIS (Business problems)
-- 1. Retrieving sales on the 2022-11-05

SELECT *
FROM retail_sales_analysis
WHERE sale_date='2022-11-05';

-- Retrieving all transactions where the category  is clothing and quantity is more than 10 in the month of November 2022

SELECT  *
FROM retail_sales_analysis
WHERE category='Clothing' 
	AND quantity>=4  
	AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
;

-- Total sales for each category
SELECT category,SUM(total_sales) categorical_total_sales
FROM retail_sales_analysis
GROUP BY category;

-- Average age of customers who purchased beaty items
SELECT ROUND( AVG(age),2) Average_Buyer_Age_Beauty -- used round function to round off the age decimals
FROM retail_sales_analysis
WHERE category='beauty';    -- 40.42 years 

-- Total sales is  greater than 1000
SELECT *
FROM retail_sales_analysis
WHERE total_sales>1000;

-- Transactions made by each gender in each category
SELECT
	category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales_analysis
GROUP 
	BY 
    category,
    gender
ORDER by 1;

SELECT *
FROM retail_sales_analysis;

-- The average sale for each month and finding out the best selling month in each year

SELECT 
	YEAR (sale_date)  year,
	MONTH(sale_date)  month,
	ROUND(AVG (total_sales),2) as avg_sales
FROM retail_sales_analysis
GROUP BY 1,2
ORDER BY 1,3 DESC; -- This shows the month with the highest average sales in each year in descending order


SELECT 
	YEAR (sale_date)  year, 
	MONTH(sale_date)  month,
	ROUND(AVG (total_sales),2) as avg_sales,
    RANK() OVER( PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sales) DESC) r_ank
FROM retail_sales_analysis
GROUP BY 1,2;    -- Created average sales ranking order per year

SELECT *
FROM       -- Creating a CTE
(
	SELECT 
		YEAR (sale_date)  year, 
		MONTH(sale_date)  month,
		ROUND(AVG (total_sales),2) as avg_sales,
		RANK() OVER( PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sales) DESC) r_ank
	FROM retail_sales_analysis
	GROUP BY 1,2
) as t1
WHERE r_ank < 6;


-- Top 5 customers based on the highest total sales
 SELECT 
	customer_id,
	SUM(total_sales) total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Number of unique customers who purchased items form each category
SELECT  
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales_analysis count_of_unique_customer
GROUP BY 
    category;


-- Create shifts Morning <= 12:00 ,afternoon between 12:00 & 17:00 evening >17:00
-- I create a logical condition and created another column SHIFT

SELECT *,
	CASE 
		WHEN HOUR(sale_time) <12  THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM retail_sales_analysis;


-- Create a CTE

WITH hourly_sales
AS
(
SELECT *,
	CASE 
		WHEN HOUR(sale_time) <12  THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM retail_sales_analysis
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift ;


-- END OF PROJECT




        


	
-- 


