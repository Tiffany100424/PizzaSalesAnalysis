USE PizzaDB;
SELECT *
FROM dbo.pizza_sales;

SELECT *
FROM dbo.pizza_sales
ORDER BY pizza_id
OFFSET 0 ROWS FETCH NEXT 1000 ROWS ONLY;

SELECT *
FROM dbo.pizza_sales
where pizza_id = 1 ;

-------------------------------------------------------------------EDA ---------------------------------------------------------------------------------------

-- How many unique pizza categories?
SELECT distinct pizza_category
FROM dbo.pizza_sales;

-- How many pizza names for each category?
SELECT pizza_category, pizza_name
FROM dbo.pizza_sales
GROUP BY pizza_category, pizza_name
ORDER BY pizza_category ;

-- How many types of pizzas?
SELECT pizza_name,pizza_ingredients
FROM dbo.pizza_sales
GROUP BY pizza_name,pizza_ingredients ;

-- How many sizes of pizzas:
SELECT distinct pizza_size
FROM dbo.pizza_sales;
--------------------------------------------------------------------

-- TOTAL REVENUE:
SELECT sum(total_price) AS total_revenue
FROM dbo.pizza_sales;

-- TOTAL PIZZA ORDERS:
SELECT COUNT(distinct order_id) AS order_count
FROM dbo.pizza_sales;

-- TOTAL PIZZA SOLD (QUANTITY):
SELECT sum(quantity) AS total_quantity
FROM dbo.pizza_sales;

SELECT pizza_category, COUNT(distinct pizza_name)
FROM dbo.pizza_sales
GROUP BY pizza_category;

-- AVG SALES PER ORDER:
SELECT
    sum(total_price)/COUNT(distinct order_id)
FROM dbo.pizza_sales;

-- CACULATE THE NUM OF PIZZAS BY PIZZA_CATEGORY:
SELECT
    pizza_category,
	SUM(quantity) AS pizza_sold
FROM dbo.pizza_sales
GROUP BY pizza_category;

-- BEST SELLER (based on Revenue )
SELECT 
    TOP 1 pizza_name,
    SUM(total_price) AS revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY sum(total_price)  DESC;

-- BEST SELLER (based on Quantity)
SELECT 
    TOP 1 pizza_name,
    SUM(quantity)  AS quantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY quantity DESC;

-- FIND THE QUARTER WITH THE MOST REVENUE: (Quarter 2 had the highest revenue)
SELECT
    DATEPART(QUARTER, order_date) as quarter_name,
	SUM(total_price) AS total_revenue
FROM dbo.pizza_sales
GROUP BY  DATEPART(QUARTER, order_date)
ORDER BY total_revenue DESC ;

-- FIND THE QUARTER WITH THE HIGHEST ORDERS: (Quarter 3 had the highest orders)
SELECT
    DATEPART(QUARTER, order_date) as quarter_name,
	COUNT(distinct order_id) AS total_orders
FROM dbo.pizza_sales
GROUP BY  DATEPART(QUARTER, order_date)
ORDER BY total_orders DESC ;

-- AVG SALES PER MONTH:
SELECT AVG(avg_months)
FROM(SELECT 
    DATEPART(MONTH, order_date) AS month, 
    SUM(total_price)/COUNT(distinct MONTH(order_date)) AS avg_months
FROM dbo.pizza_sales
GROUP BY DATEPART(MONTH, order_date)) AS t;

-- AVG MONTHLY SALES :
SELECT 
    SUM(total_price)/COUNT(distinct MONTH(order_date))
FROM dbo.pizza_sales;

-- AVG ORDER VALUE:
SELECT  
   SUM(total_price)/COUNT(distinct order_id) AS avg_per_order
FROM dbo.pizza_sales;

-- CALCULATE SALES OF WEEKDAYS (Sunday = 1)
SELECT 
    DATEPART(WEEKDAY, order_date) AS day_of_week,
    SUM(total_price) AS total_sales
FROM 
    pizza_sales
GROUP BY 
    DATEPART(WEEKDAY, order_date)
ORDER BY 
    day_of_week;

-- THE NUMBER/REVENUE OF PIZZAS SOLD FOR EACH MONTH:
SELECT 
    MONTH(order_date) AS month,
	SUM(quantity) AS total_quantity,
	ROUND(SUM(total_price),2) AS revenue
FROM dbo.pizza_sales
GROUP BY MONTH(order_date) 
ORDER BY MONTH(order_date) ;

-- DAILY SALES TREND:
SELECT
    DATENAME(dw, order_date) AS day_name,
	ROUND(SUM(total_price),2) AS total_sales,
	COUNT(distinct order_id) AS total_order
FROM dbo.pizza_sales
GROUP BY DATENAME(dw, order_date)
ORDER BY ROUND(SUM(total_price),2) DESC ;

-- MONTHLY ORDER TREND :
SELECT
    DATENAME(MONTH,order_date) AS month_name,
	COUNT(distinct order_id) AS total_order
FROM dbo.pizza_sales
GROUP BY DATENAME(MONTH, order_date)
--ORDER BY ROUND(SUM(total_price),2) DESC ;


-- SALES PERCENTAGE OF EACH PIZZA_CATEGORY:
SELECT
pizza_category,
CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_sales,
CAST((SUM(total_price) * 100) / (SELECT SUM(total_price) FROM dbo.pizza_sales) AS DECIMAL(10,2)) AS sales_percentage
FROM dbo.pizza_sales
GROUP BY pizza_category
ORDER BY sales_percentage DESC;

-- SALES PERCENTAGE OF EACH PIZZA_SIZE:
SELECT
pizza_size,
CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_sales,
CAST((SUM(total_price) * 100) / (SELECT SUM(total_price) FROM dbo.pizza_sales) AS DECIMAL(10,2)) AS sales_percentage
FROM dbo.pizza_sales
GROUP BY pizza_size
ORDER BY sales_percentage DESC;

--
SELECT
pizza_size,
CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_sales,
CAST((SUM(total_price) * 100) / (SELECT SUM(total_price) FROM dbo.pizza_sales) AS DECIMAL(10,2)) AS sales_percentage
FROM dbo.pizza_sales
WHERE DATEPART(QUARTER, order_date) = 4 -- change here tho see sales of the other quarters
GROUP BY pizza_size
ORDER BY sales_percentage DESC;

-- This query filters data for a specific year (e.g., 2023) and calculates total sales for each month. 
-- It helps identify seasonal peaks and troughs in sales. Can use Month(), Quater() functions in WHERE clause
SELECT 
    DATEPART( MONTH, order_date) AS sales_month,
    SUM(total_price) AS total_sales
FROM 
    dbo.pizza_sales
--WHERE YEAR(order_date) = 2023  -- Adjust year as needed--
GROUP BY 
    DATEPART( MONTH, order_date)
ORDER BY 
    sales_month;
	
-- TOP 5 PIZZAS ORDERED THE MOST BASED ON QUANTITY:
SELECT TOP 5 pizza_name, SUM(quantity) AS total_quantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC;

-- TOP 5 PIZZAS BRING HIGHEST REVENUE:
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_sales
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC;

-- TOP 3 PIZZAS WITH THE LOWEST ORDERS:
SELECT TOP 3 pizza_name, COUNT (order_id)AS order_count
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY order_count ASC;

-- TOP 3 PIZZAS WITH THE LOWEST QUANTITY:
SELECT TOP 3 pizza_name, sum(quantity) AS quantity
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY sum(quantity) ASC;

-- TOP 3 PIZZAS BRING THE LOWEST REVENUE:
SELECT TOP 3 pizza_name, sum(total_price) AS revenue
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY sum(total_price) ASC;

-- HOURLY SALES TREND
SELECT
    DATEPART(HOUR, order_time) AS time_of_the_day,
	COUNT(distinct order_time) AS num_of_order
FROM dbo.pizza_sales
GROUP BY  DATEPART(HOUR, order_time)
ORDER BY time_of_the_day;

-- DETERMINE TOP 1 THE MOST PIZZA_NAME ORDERED BASED ON QUANTITY FOR EACH PIZZA_CATEGOR:
SELECT pizza_category, pizza_name, total_quantity
FROM (SELECT
    pizza_category,
	pizza_name,
    SUM(quantity) AS total_quantity,
	RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(quantity) DESC) AS rnk
FROM dbo.pizza_sales
GROUP BY pizza_category, pizza_name) as t
WHERE rnk = 1;

-- DETERMINE THE LOWEST PIZZA_NAME ORDERED BASED ON QUANTITY FOR EACH PIZZA_CATEGOR:
SELECT pizza_category, pizza_name, total_quantity
FROM (SELECT
    pizza_category,
	pizza_name,
    SUM(quantity) AS total_quantity,
	RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(quantity) ASC) AS rnk
FROM dbo.pizza_sales
GROUP BY pizza_category, pizza_name) as t
WHERE rnk = 1;

-- DETERMINE THE MOST PIZZA_NAME WITH HIGHEST REVENUE FOR EACH PIZZA_CATEGOR:
SELECT pizza_category, pizza_name, total_sales
FROM (SELECT
    pizza_category,
	pizza_name,
    SUM(total_price) AS total_sales,
	RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(total_price) DESC) AS rnk
FROM dbo.pizza_sales
GROUP BY pizza_category, pizza_name) as t
WHERE rnk IN(1,2);

 -- DETERMINE THE MOST PIZZA_NAME WITH LOWEST REVENUE FOR EACH PIZZA_CATEGOR:
 SELECT pizza_category, pizza_name, total_sales
FROM (SELECT
    pizza_category,
	pizza_name,
    SUM(total_price) AS total_sales,
	RANK() OVER (PARTITION BY pizza_category ORDER BY SUM(total_price) ASC) AS rnk
FROM dbo.pizza_sales
GROUP BY pizza_category, pizza_name) as t
WHERE rnk IN (1,2);

SELECT pizza_name, COUNT(distinct order_id) as total_orders
FROM pizza_sales
WHERE pizza_name IN('The Mediterranean Pizza')
GROUP BY pizza_name;












