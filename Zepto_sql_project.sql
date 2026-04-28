DROP TABLE  IF EXIST zepto;

CREATE TABLE zepto (
 sku_id SERIAL PRIMARY KEY,
 category VARCHAR (120),
 name VARCHAR (150) NOT NULL,
 mrp NUMERIC (8,2),disscount_percent NUMERIC (5,2),
 available_Quantity INTEGER,
 discounted_selling_price NUMERIC (8,2),
 weight_In_Gms INTEGER,
 out_Of_Stock BOOLEAN,
 quantity INTEGER
 
 );

-- data exploration

-- count of rows
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto 
WHERE name IS NULL
OR
 category IS NULL
OR
 mrp IS NULL
OR
 disscount_percent IS NULL
OR
 available_quantity IS NULL
OR
 discounted_selling_price IS NULL
OR
 weight_in_gms IS NULL
OR
 out_of_stock IS NULL
OR
 quantity IS NULL;


-- Different product categories

SELECT Distinct category FROM zepto
ORDER BY category;

-- Products in stock vs out of stock
SELECT  out_of_stock , COUNT(sku_id)
FROM zepto
GROUP BY out_of_stock;

-- Products names present multiple time
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

-- Data cleaning

-- product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discounted_selling_price = 0;

DELETE FROM zepto
WHERE mrp = 0

-- Converted paise into rupees
UPDATE zepto
SET mrp = mrp/100.0,
discounted_selling_price = discounted_selling_price/100.0;

SELECT mrp ,discounted_selling_price FROM zepto;



--1. Find the top 10 best value product based on discount percentage.

SELECT DISTINCT name, mrp, disscount_percent 
FROM zepto
ORDER BY disscount_percent DESC
LIMIT 10;

--2. What is the products with high mrp but out of stock.

SELECT name ,mrp FROM zepto
WHERE out_of_stock = True AND mrp > 300
ORDER BY mrp DESC;

--3. Calculate estimated revenue for each category.
SELECT  category,
SUM(discounted_selling_price * available_quantity) AS Total_revenue
FROM zepto
GROUP BY category
ORDER BY Total_revenue;


 --4. Find all the products where mrp is greater than ₹500 and discont is 
 -- less than 10%.

 SELECT DISTINCT name, mrp, disscount_percent
 FROM zepto
 WHERE mrp > 500  AND disscount_percent < 10
 ORDER BY mrp DESC, disscount_percent DESC;

--5. Identify the top 5 categories offering the highest average discount percentage.

SELECT  category, ROUND(AVG(disscount_percent),2) AS Avg_discount
FROM zepto
GROUP BY category
ORDER BY  AVG(disscount_percent) DESC
LIMIT 5;

--6. Find the price per gram for products above 100gm and short by best value.

SELECT DISTINCT name, weight_in_gms, discounted_selling_price,
ROUND(discounted_selling_price/weight_in_gms,2) AS price_per_gram
FROM zepto
WHERE weight_in_gms >= 100
ORDER BY price_per_gram;

--7. Group the product into categories like low , medium and bulk.

SELECT DISTINCT name, weight_in_gms,
CASE WHEN weight_in_gms < 1000 THEN 'Low'
	WHEN weight_in_gms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--8. What is the total inventory weight per category.

SELECT category , SUM(weight_in_gms * available_quantity)  AS Total_weight
FROM zepto 
GROUP BY category 
ORDER BY Total_weight;

-- END OF PROJECT.