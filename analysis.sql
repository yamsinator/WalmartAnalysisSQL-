-- Creating the table to start project --
CREATE TABLE IF NOT EXISTS sales (
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Check to see if data has imported successfully --
SELECT * FROM sales;

-- Add new column called time_of_day -- 
SELECT time, (CASE	
				WHEN time BETWEEN "00:00:00" AND "11:59:59" THEN "Morning"
                WHEN time BETWEEN "12:00:00" AND "16:59:59" THEN "Afternoon"
                ELSE "Evening"
			  END) AS time_of_day
              FROM sales;

-- Check to see if time_of_day column has been added --
SELECT * FROM sales;

-- Updating sales table to include info from time_of_day --
UPDATE sales 
SET time_of_day = 
			 (CASE	
				WHEN time BETWEEN "00:00:00" AND "11:59:59" THEN "Morning"
                WHEN time BETWEEN "12:00:00" AND "16:59:59" THEN "Afternoon"
                ELSE "Evening"
			  END);

-- Setting day_name based on date of transaction --
SELECT date, DAYNAME(date) 
FROM sales;

-- Update sales table with day_name --
UPDATE sales
SET day_name = DAYNAME(date);

-- Add column called month_name -- 
ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

-- Set month names to month_name column --
SELECT date, MONTHNAME(date) 
FROM sales;

-- Update table --
UPDATE sales
SET month_name = MONTHNAME(date);

----------------------- GENERIC QUESTIONS -----------------------
-- How many unique cities does the data have? --
SELECT DISTINCT city
FROM sales; -- There are 3 unique cities

SELECT COUNT(DISTINCT city) as total_cities
FROM sales;
                
-- Which city is each branch? --
SELECT DISTINCT city, branch
FROM sales
ORDER BY branch;

----------------------- Product -----------------------
-- How many unique product lines does the data have? --
SELECT product_line, COUNT(*) AS products
FROM sales
GROUP BY product_line
ORDER BY products ASC;
                
-- What is the most common payment method? --
SELECT DISTINCT payment, COUNT(*) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC;

-- What is the most selling produt line? --
SELECT product_line, SUM(quantity) as qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month? --
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue ASC;

-- What month had the largest COGS? --
SELECT month_name as month, SUM(cogs) as total_cogs
FROM sales
GROUP BY month
ORDER BY total_cogs;

-- Which product line has the largest revenue? --
SELECT product_line, SUM(total) as total
FROM sales
GROUP BY product_line
ORDER BY total DESC;

-- What product line had the largets VAT? --
SELECT product_line, AVG(tax_pct) as VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product lines showing "Good," "Bad " --
/* Where a product is good if sales are greater than average sales **/
SELECT AVG(quantity) AS qty
FROM sales;

/*
* Selects the product_line and uses CASE to check if the average quantity for that product line is greater than the
* average of all sales and determines if it is "good" or "bad" and sets that column as its rating.
**/
SELECT product_line, CASE
						WHEN AVG(quantity) > (SELECT AVG(quantity) FROM sales) THEN "GOOD"
						ELSE "BAD"
						END AS rating
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold? --
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > AVG(quantity);

-- What is the most common product line by gender? --
SELECT gender, product_line, SUM(quantity) as qty
FROM sales
GROUP BY gender, product_line
ORDER BY qty DESC;

SELECT * FROM sales;


