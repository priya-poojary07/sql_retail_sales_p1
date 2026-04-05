-- display the table with all rows and columns
select * from retail_sales;

-- displays only first 10 records from the table
select * from retail_sales limit 10;

-- displays total number of records present in the table
select count(*) from retail_sales;

-- displays null values present in each of the columns
select * from retail_sales 
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- to remove null values present in each of the columns
delete from retail_sales where
transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- data exploration

-- how many sales we have?
select count(*) as total_sale from retail_sales

-- how many customers we have?
select count(customer_id) from retail_sales

-- how many unique customers we have?
select count(distinct customer_id) from retail_sales

-- how many unique category we have?
select distinct category from retail_sales


-- data analysis and business key problems and asnwers

-- Q1.write a query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date ='2022-11-05';

--Q2. write a query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of nov-2022

select * from retail_sales where category='Clothing' and quantiy>=4 and To_char(sale_date,'yyyy-mm')='2022-11';

-- Q3. write a sql query to calculate the total sales(total_sale) for each category
select category, sum(total_sale) from retail_sales group by category;

-- Q4. write a sql query to find the average age of customers who purchased items from the 'beauty' category.
select  Round(avg(age),2) from retail_sales where category='Beauty';

--Q5.write a query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;  


--Q6.Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category.
select gender,category,count(*) as total_tansactions from retail_sales group by gender,category; 

-- second method 
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1

--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q8.Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) from retail_sales group by category;


--Q9.write a sql query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
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



