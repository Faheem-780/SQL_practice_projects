-- SQL Retail Sales Analysis - P1
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,   
customer_id INT,
gender	VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLoAT,
cogs FLOAT,
total_sale FLOAT
);


SELECT * FROM retail_sales
LIMIT 10;

SELECT
COUNT(*)
FROM retail_sales;

SELECT * 
FROM retail_sales;

SELECT * FROM retail_sales
WHERE quantity IS NULL;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL 
OR
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL 
OR
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


-- Data Exploration

--How many sales we have? 

SELECT  COUNT(*) as total_sales
FROM retail_sales;

--How many  unique customers we have?
SELECT  COUNT(DISTINCT customer_id) 
FROM retail_sales;

SELECT  DISTINCT (category) 
FROM retail_sales;

--Main Data Analysis(Key Buisness Problems)

--My analysis and findings
  --Qs:01
    --Write a query to retrieve all the columns for sales made on 2022-11-05.
SELECT * 
FROM retail_sales
WHERE sale_date= '2022-11-05';

  --Qs:02
    /* Write a SQL query to retrieve all the transactions where category is clothing and quantity sold is more than 4
	in the month of November-2022.*/
SELECT
*
FROM  retail_sales
WHERE category = 'Clothing'
      AND 
	  TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
      AND
	  quantity >= 4;

   --Qs:03 
     --Write a query to calculate the total_sales for each cstegory.
SELECT 
  category,
  SUM(total_sale) AS net_sale,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

   --Qs:04
     --Write a query to find the average age of customers who purchased items from 'beauty' category.
SELECT 
  ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

   --Qs:05
     --Write a query to find all transactions where the total sales is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

   --Qs:06
     --Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT
 gender,
 category,
 COUNt(transactions_id) as total_trans
FROM retail_sales
GROUP BY 
category,
gender
ORDER BY 1;

   --Qs:07
     -- Write a SQL query to calculate the average sale for each month.Find out the best selling month in each year.
SELECT 
 year,
 month,
 avg_sale
FROM
(
	SELECT 
	 EXTRACT (YEAR FROM sale_date) as year,
	 EXTRACT (MONTH FROM sale_date) as month,
	 AVG(total_sale) as avg_sale,
	 RANK ()OVER(PARTITION BY  EXTRACT (YEAR from sale_date) ORDER BY AVG(total_sale)DESC) as rank 
	FROM retail_sales
	GROUP BY 1,2
	--ORDER BY 1,3 DESC;
) AS t1
WHERE rank = 1;

   --Qs:08
     --Write a query to find top 5 custumers based on the highest total sales.
SELECT 
 customer_id,
 SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

   --Qs:09
     --Write a query to find the number of unique custoomers who purchased items from each category.
SELECT
 category,
 COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;

   --Qs:10
     --Write a query to create each shift and number of orders(Example Morning <=12, Afternoon 12&17, Evening >17).
WITH hourly_sales
AS
(
SELECT *,
 CASE
     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AfterNoon'
	 ELSE 'Evening'
 END AS shift
FROM retail_sales
)
SELECT
 shift,
 COUNT(*) AS total_sales
FROM hourly_sales
GROUP BY shift

   --Qs:11
     --Write a query to calculate the overall total revenue, total quantity of items sold, and total number of transactions.
SELECT 
 COUNT(transactions_id) AS total_transactions,
 SUM(total_sale) AS total_sale,
 SUM(quantity) AS total_quantity
FROM retail_sales;
   --Qs:12
     --Retrieve all transactions in the 'Clothing' category where the quantity sold is at least 4 units during November 2022.
	 SELECT *
	 FROM retail_sales
	 WHERE
	  category = 'Clothing'
	  AND
	  quantity >= 4
	  AND
	  sale_date >= '2022-11-01'
	  AND
	  sale_date > '2022-12-01';

   --Qs:13
	  --Find the total net sales, total quantity sold, and total orders for each product category, ordered from highest to lowest revenue.
SELECT 
 category,
 COUNT(transactions_id) AS total_transactions,
 SUM(total_sale) AS total_sale,
 SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_sale ASC;

   --Qs:14
     --Calculate total profit (total_sale - cogs) and the gross profit margin percentage ((total_sale - cogs) / total_sale) * 100 for each category.
SELECT 
    category,
    ROUND(SUM(total_sale)) AS revenue,
    ROUND(SUM(cogs)) AS total_cogs,
    ROUND(SUM(total_sale - cogs)) AS total_profit,
    ROUND((SUM(total_sale - cogs) / NULLIF(SUM(total_sale), 0)) * 100) AS profit_margin_pct
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

   --Qs:15
     --Find the top-earning month for each year, along with the average transaction amount for that month.
WITH monthly_sales AS
(
SELECT 
 EXTRACT(YEAR FROM sale_date)  AS sale_year,
 EXTRACT(MONTH FROM sale_date) AS sale_month,
 SUM(total_sale) AS total_revenue,
 ROUND(AVG(total_sale)) AS avg_sale,
 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  SUM(total_sale)) AS rnk
FROM retail_sales
GROUP BY EXTRACT(YEAR FROM sale_date),
 EXTRACT(MONTH FROM sale_date)
)
SELECT
  sale_year,
  sale_month,
  total_revenue,
  avg_sale
FROM monthly_sales
WHERE rnk = 1;

