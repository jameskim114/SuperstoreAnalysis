-- Renaming Columns  
ALTER TABLE superstore.sales
RENAME COLUMN `Row ID` TO row_id; 

ALTER TABLE superstore.sales
RENAME COLUMN `Order ID` TO order_id;

ALTER TABLE superstore.sales
RENAME COLUMN `ship date` TO ship_date;

ALTER TABLE superstore.sales
RENAME COLUMN `ship mode` TO ship_mode;

ALTER TABLE superstore.sales
RENAME COLUMN `Customer ID` TO customer_id;

ALTER TABLE superstore.sales
RENAME COLUMN `Customer Name` TO customer_name;

ALTER TABLE superstore.sales
RENAME COLUMN `postal code` TO postal_code;

ALTER TABLE superstore.sales
RENAME COLUMN `sub-category` TO sub_category;

ALTER TABLE superstore.sales
RENAME COLUMN `product name` TO product_name;


-- Part 1) Exploratory Data Analysis: Getting To Know the Data

-- States with Highest Sales
SELECT 
	state,
    COUNT(DISTINCT order_id) AS Orders,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit
FROM sales
GROUP BY state
ORDER BY Total_Sales DESC;

-- States with Highest Profits
SELECT 
	state,
    COUNT(DISTINCT order_id) AS Orders,
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit
FROM sales
GROUP BY state
ORDER BY Total_Profit DESC;

-- Customer Segment with Highest Sales
SELECT segment, SUM(sales) AS sales, SUM(profit) AS profit
FROM sales
GROUP BY segment 
ORDER BY sales DESC;

-- Customer Segment with Highest Profit
SELECT segment, SUM(sales) AS sales, SUM(profit) AS profit
FROM sales
GROUP BY segment 
ORDER BY profit DESC;
	
    
-- Part 2) Shipping Analysis

-- Shipping Mode Patterns of the Top 5 States (By Sales) 
SELECT state, ship_mode, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'California' OR state = 'New York' OR state = 'Texas' OR state = 'Washington' OR state = 'Pennsylvania'
GROUP BY ship_mode, state
ORDER BY total_sales DESC;


-- Part 3) Geographical Analysis: California vs. New York

-- Cities in California with Highest # of Orders
SELECT state, city, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'California'
GROUP BY state, city
ORDER BY num_of_orders DESC;

-- Cities in California with Highest Total Profit
SELECT state, city, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'California'
GROUP BY state, city
ORDER BY total_profit DESC;

-- Cities in New York with Highest # of Orders
SELECT state, city, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'New York' 
GROUP BY state, city
ORDER BY num_of_orders DESC;

-- Cities in New York with Highest Profit
SELECT state, city, postal_code, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'New York' 
GROUP BY state, city, postal_code
ORDER BY total_profit DESC;


-- Part 4) Geographical Analysis: Cities and Neighbourhoods Within CA

-- Neighbourhoods in California with Highest # of Orders
SELECT state, city, postal_code, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'California'
GROUP BY state, city, postal_code
ORDER BY num_of_orders DESC;

-- Neighbourhoods in California with Highest Profit
SELECT state, city, postal_code, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE state = 'California'
GROUP BY state, city, postal_code
ORDER BY total_profit DESC;

-- # of Orders, Sales, and Profit of Neighbourhoods in LA and SF
SELECT city, postal_code, COUNT(DISTINCT order_ID) AS num_of_orders, SUM(Sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
WHERE city = 'San Francisco' OR city = 'Los Angeles'
GROUP BY city, postal_code
ORDER BY total_profit DESC;


-- Part 5) Sales Analysis: Los Angeles

-- Customer Segments in LA 
SELECT segment, SUM(sales) AS sales, SUM(profit) AS profit
FROM sales
WHERE city = 'Los Angeles'
GROUP BY segment 
ORDER BY profit DESC;

-- Most Profitable Product Categories in LA 
SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit, (SUM(profit)/SUM(sales)*100) AS profit_margin
FROM sales
WHERE city = 'Los Angeles'
GROUP BY category
ORDER BY total_profit DESC;


-- Part 6) Finding Top Customers in LA for Pre-Launch Survey
SELECT 
	DISTINCT (order_id),
    customer_name,
    segment,
    SUM(sales) AS sales, 
    SUM(quantity) AS num_of_items, 
    SUM(profit) AS profit
FROM sales
WHERE city = 'Los Angeles'
GROUP BY customer_name, segment, order_id
ORDER BY sales DESC
LIMIT 100;


-- (Extra) Part 7) Trying to Find Why 10 States Have Profit Losses

-- States with Negative Profit Margins
SELECT state, SUM(profit) AS profit
FROM sales
WHERE profit < 0
GROUP BY state
ORDER BY profit ASC

-- Does ratio of product categories sold affect profit (furniture is least profitable)?
-- No correlation found 
SELECT state, category, count(category) AS num_of_items, SUM(sales) AS total_sales
FROM sales
WHERE state = 'Texas' OR state = 'Ohio' OR state = 'Pennsylvania'
GROUP BY category, state
ORDER BY state, count(category) DESC;

SELECT state, category, count(category) AS num_of_items, SUM(sales) AS total_sales
FROM sales
WHERE state = 'California' OR state = 'New York'
GROUP BY category, state
ORDER BY state, count(category) DESC;

-- Does shipping mode affect profit? 
-- No correlation found
SELECT ship_mode, SUM(sales) AS sales, SUM(profit) AS profit, SUM(profit)/SUM(sales)*100 AS profitability_correlation_to_shipping_mode
FROM sales
GROUP BY ship_mode
ORDER BY sales DESC


-- Noticed very high losses on sales with high discounts. Do discounts affect profit? 
-- Correlation between high discounts (40-80%) and profit loss found. Noted in 'Next Steps' for more exploration. 
SELECT *
FROM sales
WHERE state = 'Texas'
ORDER BY discount DESC;

SELECT *
FROM sales
WHERE state = 'Ohio'
ORDER BY discount DESC;

SELECT *
FROM sales
WHERE state = 'Pennsylvania'
ORDER BY discount DESC;

SELECT *
FROM sales
WHERE state = 'California'
ORDER BY discount DESC;

SELECT *
FROM sales
WHERE state = 'New York'
ORDER BY discount DESC;




