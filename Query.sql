-- Create table   ( Ctrl / )
CREATE TABLE pizza_sales (
    pizza_id INTEGER PRIMARY KEY,
    order_id INTEGER ,
    pizza_name_id TEXT ,
    quantity INTEGER ,
    order_date DATE ,
    order_time TIME ,
    unit_price NUMERIC(10,2),
    total_price NUMERIC(10,2) ,
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name TEXT
);

-- Import data with the help of import export option
copy pizza_sales FROM 'E:/Pizza/pizza_sales.csv' WITH (FORMAT csv, HEADER true);

-- show the entire data
select * from pizza_sales;

-- Delete table
drop table pizza_sales;

-- KPI

-- 1. Total Revenue:
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;

-- 2. Average Order Value
SELECT CAST(CAST(SUM(total_price) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
AS DECIMAL(10,2)) AS Avg_order_Value 
FROM pizza_sales;

-- 3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales;

-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- 5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales;

--Visuals
-- 1. Daily Trend for Total Orders
SELECT TO_CHAR( Order_date, 'DAY') AS order_day, 
COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY TO_CHAR( Order_date, 'DAY');

-- 2. Monthly Trend for Orders
SELECT TO_CHAR( Order_date, 'MONTH') AS order_day, 
COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY TO_CHAR( Order_date, 'MONTH');

-- 3. % of Sales by Pizza Category
SELECT pizza_category, 
CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

-- 4. % of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- 5. Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

-- 6. Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 7. Bottom 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

-- 8. Top 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- 9. Bottom 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

-- 10. Top 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

-- 11. Bottom 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
Limit 5;

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic'
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;
