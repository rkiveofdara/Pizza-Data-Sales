select * from pizza_sales

--Total Revenue
select sum(total_price) AS Total_Revenue from pizza_sales

--Average Order Value
SELECT SUM(Total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales

--Total Pizza Sold
SELECT SUM(quantity) AS Total_Pizza_Sold from pizza_sales

--Total Order
SELECT COUNT(DISTINCT order_id) AS Total_Order from pizza_sales

--Average Pizza Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizza_Per_Order FROM pizza_sales

--Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) AS order_daty, 
	   COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)
--DW : A day of a week, DATENAME: sunday monday etc

--Hourly Trend for Total Orders
SELECT DATEPART(HOUR, order_time) AS order_hours,
	   COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time)

--Percentage of Sales by Pizza Category
SELECT pizza_category, 
		SUM(total_price) AS Total_sales, 
		SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales WHERE MONTH(order_date) = 1) AS PCT
from pizza_sales 
WHERE MONTH(order_date) = 1			-- 1 = january, and the list goes on
GROUP BY pizza_category

--EXPLANATION OF THE QUERY ABOVE--
SELECT pizza_category, SUM(total_price) * 100 
from pizza_sales
WHERE pizza_category = 'Classic'
GROUP BY pizza_category

SELECT SUM(total_price)
from pizza_sale
--END EXPLANATION OF THE QUERY ABOVE--

--Percentage of Sales by Pizza Size
SELECT pizza_size, 
		CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_sales, 
		CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
from pizza_sales 
WHERE DATEPART(QUARTER, order_date) = 1			--QUARTER = the first 3 months ish
GROUP BY pizza_size
ORDER BY PCT DESC

--Total Pizza Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_category

--Top 5 Best Seller by Total Pizza Sold
SELECT TOP 5 pizza_name, sum(quantity) as Total_Pizza_Sold 
FROM pizza_sales
WHERE MONTH(order_date) = 2		-- 2 = february etc
GROUP BY pizza_name
ORDER BY sum(quantity) DESC

--The least fav pizza
SELECT TOP 5 pizza_name, sum(quantity) as Total_Pizza_Sold 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY sum(quantity) ASC