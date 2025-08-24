select * from retail_sales
create table retail_sales(
transactions_id int primary key,	
sale_date date,
sale_time time,
customer_id	int,
gender varchar(10),
age	int,
category varchar(15),	
quantiy	int,
price_per_unit float,
cogs float,
total_sale float
);
--data cleaning--
delete from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
category is null
or
quantiy is null
or 
gender is null
or 
cogs is null
or
total_sale is null;
--how many sales we have?
select count(total_sale) as total_sales from retail_sales
--how many unique customer we have?
select count(distinct customer_id) as total_customer from retail_sales
--how many unique category we have?
select distinct category from retail_sales
--data analysis
--q.1 write a sql query to retrieve all columns for sales made on '2022-11-05'
select * 
from retail_sales 
where sale_date = '2022-11-05';
--q.2 write a sql query to retrieve all transaction where the category is cloting and the quantity sold is more than 4 in the month of nov-2022
select * 
from retail_sales
where category = 'Clothing'
and
to_char(sale_date, 'yyyy-mm') = '2022-11'
and 
quantiy >= 4
--q.3 write a sql query to calculate the total sales (total_sale) for each category.
select 
category, 
sum(total_sale) as net_sale
from retail_sales
group by 1
--q.4 write a sql to find the average age of customer who purchased items from the 'beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'
--q.5 write a sql query to find all transaction where the total_sale is greater than 1000
select transactions_id, total_sale
from retail_sales
where total_sale > 1000
--q.6 write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category,
gender,
count(*) as total_trans
from retail_sales
group by gender,category
order by 1
--q.7 write a sql query to calculate the average sale for each month. find out best selling month in each year
select year,month,avg_sale from (
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date)order by avg(total_sale)desc) as rank 
from retail_sales
group by 1,2
) as t1
where rank = 1
--q.8 write a sql query to find the top 5 customers based on the highest total sales.
select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5
--q.9 write a sql query to find the number of unique customers who purchased items from each category.
select
count(distinct customer_id) as unique_customer,
category
from retail_sales
group by 2
order by 1
--q.10 write a sql query t create each shift and number of orders (example morning <=12, afternoon between 12&17, evening >17)
with hourly_sale
as
(
select *,
 case 
   when extract(hour from sale_time) < 12 then 'morning'
   when extract(hour from sale_time) between 12 and 17 then 'afternoon'
   else 'evening'
 end as shift
from retail_sales
)
select 
  shift,
  count(*) as total_orders
from hourly_sale
group by shift
--end of project