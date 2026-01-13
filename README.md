# MySQL_Retail_Sales_Project

## Project Overview
**Project Title**: Retail Sales Analysis  
This project is designed to demonstrate MySQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through MySQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in MySQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use MySQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_sales`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

SELECT 
		COUNT(*)
FROM retail_sales_analysis;

SELECT *
FROM retail_sales_analysis;

-- CHECKING FOR DUPLICATES

SELECT *,
ROW_NUMBER () OVER(
PARTITION BY transaction_id, sale_date,sale_time, customer_id,gender,age,category,quantity, price_per_unit,cogs,total_sales) AS row_num
FROM retail_sales_analysis;

-- If there are no duplicates it means there is duplicates

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

```

### 3. Data Analysis & Findings (Business problems)

The following SQL queries were developed to answer specific business questions:

 **Checking how many total transcations we had for the period**
```
SELECT COUNT(*)
AS total_sales 
FROM retail_sales_analysis;

-- we  have 1987 total transactions

```
 **How many unique customers do we have in the dataset**
```
SELECT  COUNT(DISTINCT customer_id)
FROM retail_sales_analysis;

-- we had 155 customers buying from our shop.

```
 **Checking number of different product categories**
```
SELECT COUNT(DISTINCT category)
FROM retail_sales_analysis;
-- we have 3 different product categories

```

1. **Retrieving sales on the 2022-11-05**:
```
SELECT *
FROM retail_sales_analysis
WHERE sale_date = '2022-11-05';
```

2. **Retrieving all transactions where the category  is clothing and quantity is more than 10 in the month of November 2022**:
```
SELECT  *
FROM retail_sales_analysis
WHERE category='Clothing' 
	AND quantity>=4  
	AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
;

```

3. **Total sales for each category.**:
```
SELECT category,SUM(total_sales) categorical_total_sales
FROM retail_sales_analysis
GROUP BY category;

```

4. **Average age of customers who purchased beaty items**:
```
SELECT ROUND( AVG(age),2) Average_Buyer_Age_Beauty -- used round function to round off the age decimals
FROM retail_sales_analysis
WHERE category='beauty';
--40.42 years
```

5. **Total sales is  greater than 1000**:
```
SELECT *
FROM retail_sales_analysis
WHERE total_sales>1000;

```

6. **Transactions made by each gender in each category.**:
```
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

```

7. **The average sale for each month and finding out the best selling month in each year**:
```
SELECT 
	YEAR (sale_date)  year,
	MONTH(sale_date)  month,
	ROUND(AVG (total_sales),2) as avg_sales
FROM retail_sales_analysis
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- This shows the month with the highest average sales in each year in descending order

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



8. **Top 5 customers based on the highest total sales **:
```
SELECT 
	customer_id,
	SUM(total_sales) total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

