
-- sql retail database analysis
create database sql_project_p2;

-- create table
drop table if exists retail_sales;
create table retail_sales
	(
		transactions_id int primary key ,
		sale_date date,
		-- yy-mm-dd
		sale_time time,
		-- hh-mm-ss
		customer_id int,
		gender varchar(15),
		age int,
		category varchar(15),
		quantiy int,
		price_per_unit float,
		cogs float,
		total_sale float

	);

-- Renaming the column
ALTER TABLE retail_sales 
RENAME COLUMN quantiy TO quantity ;

select * from retail_sales;


	

-- data cleaning
	Select * from retail_sales
	Where transactions_id is null
	or sale_date is null 
	or sale_time is null 
	or customer_id is null 
	or gender is null or 
	age is null or
	Category is null or 
	quantity is null or 
	price_per_unit is null or 
	cogs is null or 
	total_sale is null;

	Delete from retail_sales where
transactions_id is null or 
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or
age is null or
category is null or
quantity is null or
price_per_unit is null or
cogs is null or
total_sale is null ;


select count(*)
from retail_sales;

-- Data Exploration

-- Q1. How many sales do we have?
select count(*) from retail_sales;

-- Q2. How many customers are there?
select count(distinct customer_id) from retail_sales;



-- Data analysis and business key problems and answers
--Q3.  Write an SQL query to retrieve All columns for sales made on '2022-11-05'
select * from retail_sales 
where sale_date = '2022-11-05'

-- Q4. Write an SQL query to retrieve all columns where category is clothing and quantity sold is 10 
-- more than ten in the month of Nov 2022 . 
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantity >= 4 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q5. Write an SQL query to find the total sale for each category. 
select category, sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales
group by category

-- Q6 Write an SQL query to find the average age of the customer Who purchases an item from the beauty category? 
select round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- Q7: Write an SQL query to find all the transactions where total sale is greater than 1,000 
select * from retail_sales
where total_sale > 1000

-- Q8 Write an SQL query to find Total number of transactions (transaction ID) 
-- made by each gender In each category 
select category,gender,  count(transactions_id) as cnt
from retail_sales
group by category, gender
order by 1


-- Q9 Write an SQL query to calculate average sale of each month find out the best-selling month in each year. 
select * from (select
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
from retail_sales
group by 1,2) t1 
where rnk =1

-- Q10. write an sql query to find the top 5 customers based on the highest total_sales
select customer_id, sum(total_sale)
from retail_sales 
group by customer_id
order by sum(total_sale) desc
limit 5

-- Q11. Write an sql query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id)
from retail_sales
group by 1

select * from retail_sales

-- Q12. Write a sql query to create each shift and number of 
-- orders(eg: Morning <=12, afternoon between 12 and 17 , evening >17)
with hourly_sales as 
(select *,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'Evening'end as shift
		from retail_sales
		
)
select count(transactions_id), shift
from hourly_sales
group by shift ;

-- END