SQL Retail Sales Analysis - P1Author DetailsName: Muhammad Faheem  Email: mhrfaheem780@gmail.com  Project OverviewThis project demonstrates SQL skills and techniques used for retail sales data analysis. The provided SQL script sets up a retail sales database table, handles data cleaning, and solves core business problem statements.  Database Setup & Data CleaningThe database table is created and cleaned using the following schema and queries:  SQL-- SQL Retail Sales Analysis - P1
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

-- Delete records with NULL values
DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL 
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
Key Business Problems & SQL Solutions1. Sales on a Specific DateQuestion: Write a query to retrieve all the columns for sales made on 2022-11-05.  SQL Code:  SQLSELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
2. Filtered Clothing TransactionsQuestion: Write a SQL query to retrieve all transactions where the category is clothing and quantity sold is more than or equal to 4 in November 2022.  SQL Code:  SQLSELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
3. Category-wise Sales SummaryQuestion: Write a query to calculate the total sales and total orders for each category.  SQL Code:  SQLSELECT 
  category,
  SUM(total_sale) AS net_sale,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
4. Average Customer Age in Beauty CategoryQuestion: Write a query to find the average age of customers who purchased items from the 'Beauty' category.  SQL Code:  SQLSELECT 
  ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
5. High-Value TransactionsQuestion: Write a query to find all transactions where the total sale is greater than 1000.  SQL Code:  SQLSELECT * 
FROM retail_sales
WHERE total_sale > 1000;
6. Transactions by Gender and CategoryQuestion: Write a SQL query to find the total number of transactions made by each gender in each category.  SQL Code:  SQLSELECT
  gender,
  category,
  COUNT(transactions_id) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
7. Best-Selling Month in Each YearQuestion: Write a SQL query to calculate the average sale for each month and find out the best-selling month in each year.  SQL Code:  SQLSELECT 
  year,
  month,
  avg_sale
FROM (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank 
  FROM retail_sales
  GROUP BY 1, 2
) AS t1
WHERE rank = 1;
8. Top 5 CustomersQuestion: Write a query to find the top 5 customers based on the highest total sales.  SQL Code:  SQLSELECT 
  customer_id,
  SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
9. Unique Customers per CategoryQuestion: Write a query to find the number of unique customers who purchased items from each category.  SQL Code:  SQLSELECT
  category,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;
10. Shift-Based Order AnalysisQuestion: Write a query to create shifts and count the number of orders (Morning < 12, Afternoon between 12 and 17, Evening > 17).  SQL Code:  SQLWITH hourly_sales AS (
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
GROUP BY shift;
11. Overall Business MetricsQuestion: Write a query to calculate the overall total revenue, total quantity of items sold, and total number of transactions.  SQL Code:  SQLSELECT 
  COUNT(transactions_id) AS total_transactions,
  SUM(total_sale) AS total_sale,
  SUM(quantity) AS total_quantity
FROM retail_sales;
12. Product Category Revenue SortingQuestion: Find the total net sales, total quantity sold, and total orders for each product category, ordered by revenue.  SQL Code:  SQLSELECT 
  category,
  COUNT(transactions_id) AS total_transactions,
  SUM(total_sale) AS total_sale,
  SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_sale ASC;
13. Profit and Gross Margin PercentageQuestion: Calculate total profit and gross profit margin percentage for each category.  SQL Code:  SQLSELECT 
  category,
  ROUND(SUM(total_sale)) AS revenue,
  ROUND(SUM(cogs)) AS total_cogs,
  ROUND(SUM(total_sale - cogs)) AS total_profit,
  ROUND((SUM(total_sale - cogs) / NULLIF(SUM(total_sale), 0)) * 100) AS profit_margin_pct
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
14. Top-Earning Month per YearQuestion: Find the top-earning month for each year, along with the average transaction amount for that month.  SQL Code:  SQLWITH monthly_sales AS (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS sale_year,
    EXTRACT(MONTH FROM sale_date) AS sale_month,
    SUM(total_sale) AS total_revenue,
    ROUND(AVG(total_sale)) AS avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC) AS rnk
  FROM retail_sales
  GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)
SELECT
  sale_year,
  sale_month,
  total_revenue,
  avg_sale
FROM monthly_sales
WHERE rnk = 1;
  For any queries or further collaborations, please contact Muhammad Faheem at mhrfaheem780@gmail.com.  
