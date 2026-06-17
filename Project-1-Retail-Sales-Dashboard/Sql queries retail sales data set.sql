--this gives error because sales datatype is in varchar
select Sum(sales) as Total_sales from Raw_Sales_Import;
--  we used cast to change the datatype of sales to decimal.
select sum(cast(sales as decimal(18,2))) as total_sales from Raw_Sales_Import;
--select min(sales) as min_sales from Raw_Sales_Import;
--select max(sales) as max_sales from Raw_Sales_Import;
--select avg(Cast(sales as decimal(18,2))) as avg_sales from Raw_Sales_Import;

--for knowing the data type
--select column_name,Data_type from INFORMATION_SCHEMA.columns where TABLE_NAME = 'raw_sales_import'

-- for checking null values
select sum(case when sales is null then 1 else 0 end) as null_sales,
sum(case when discount is null then 1 else 0 end) as null_discount,
sum(case when profit is null then 1 else 0 end)as null_profit
from Raw_Sales_Import;

-- check for duplicate rows
select count(*) as rows,
count(distinct row_id) as unique_rowids
from Raw_Sales_Import;

--understand the date range (when the sale history starts, when it ends)

select min(order_date) as first_order_date,
max(order_date) as last_order_date
from Raw_Sales_Import;

--gives us quick profile of the business
select count(distinct customer_id) as total_customers,
count(distinct product_id) as total_products
from Raw_Sales_Import


--create a clean table 
--before that we have to see how values look
select top 5 sales,profit,discount from Raw_Sales_Import
--we can safely convert them
--create a clean table
Select * into clean_sales from Raw_Sales_Import where 1 = 0;
--verify if table is created
select table_name from INFORMATION_SCHEMA.tables;
--check the structure of clean sales table
select column_name,Data_type from INFORMATION_SCHEMA.columns where TABLE_NAME = 'clean_sales'
--delete the empty clean sales table(datatypes it copied same na)
drop table clean_sales;
select table_name from INFORMATION_SCHEMA.tables;

--create proper clean sales table with altered data types
CREATE TABLE Clean_Sales
(
    Row_ID SMALLINT,
    Order_ID NVARCHAR(60),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode NVARCHAR(50),
    Customer_ID NVARCHAR(50),
    Customer_Name NVARCHAR(100),
    Segment NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Postal_Code INT,
    Region NVARCHAR(50),
    Product_ID NVARCHAR(50),
    Category NVARCHAR(50),
    Sub_Category NVARCHAR(50),
    Product_Name NVARCHAR(150),
    Sales DECIMAL(18,2),
    Quantity TINYINT,
    Discount DECIMAL(18,4),
    Profit DECIMAL(18,2)
);
--check again 
select column_name,Data_type from INFORMATION_SCHEMA.columns where TABLE_NAME = 'clean_sales'
--datatypes changed to decimal (sales,profit,discount)
--load the data into clean sales with proper data types
INSERT INTO Clean_Sales
(
    Row_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country,
    City,
    State,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    Sales,
    Quantity,
    Discount,
    Profit
)
SELECT
    Row_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country,
    City,
    State,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    CAST(Sales AS DECIMAL(18,2)),
    Quantity,
    CAST(Discount AS DECIMAL(18,4)),
    CAST(Profit AS DECIMAL(18,2))
FROM Raw_Sales_Import;

--We can start Business Analysis
--first KPI Query
--Sales and Profit are DECIMAL, SUM will work directly without CAST.
SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Clean_Sales;

--Sales by category
select distinct category from Clean_Sales -- to know how many categories
select category,
Sum(sales) As Total_sales,
sum(profit) as total_profit from Clean_Sales group by Category 
order by Total_sales desc;
--sales by region
select region,
Sum(sales) As Total_sales,
sum(profit) as total_profit from Clean_Sales group by region
order by Total_sales desc;
--sales by segment
select segment,
Sum(sales) As Total_sales,
sum(profit) as total_profit from Clean_Sales group by segment
order by Total_sales desc;


























