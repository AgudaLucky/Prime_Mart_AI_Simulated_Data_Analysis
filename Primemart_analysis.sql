create database primemart_analysis_db 

create view prime_mart_mall 
as  
select * from [dbo].[Prime_Mart_Ikeja (1)] 
union all 
select * from [dbo].[Prime_Mart_Lekki (2)]
union all 
select * from [dbo].[Prime_Mart_Yaba (3)]

select * from prime_mart_mall 

alter table prime_mart_mall
alter column prime_mart_mall decimal (10,3)
----Understanding the contribution of each store in total sales---
with storecontribution as (select Store_Location, sum(Sales) as Total_Sales
from prime_mart_mall
group by Store_Location)
select Store_Location, 
Total_Sales, 
cast (100.0 * Total_Sales / nullif (sum(Total_Sales)over(),0) as decimal (10,2)) as Store_Percentage
from storecontribution 
order by  Total_Sales  desc

---total sales for each year ----
select Transaction_Year, sum(Sales) As Total_Sales 
from prime_mart_mall 
group by Transaction_Year 
order by 1 Asc

---sales performance across all three stores in the last three years----

select Transaction_Year, Store_Location,  sum(Sales) as total_sales 
from prime_mart_mall 
group by Transaction_Year, Store_Location   
order by 1 asc, 3 Desc 

----Percentage Difference in revenue between within the last three years within each store----

WITH StoreSales AS (select Store_Location, Transaction_Year,  sum(Sales) as Total_Sales 
from prime_mart_mall 
group by Transaction_Year, Store_Location   
 )
SELECT Store_Location,Transaction_Year,  Total_Sales, 

 CAST (100.0 * (Total_Sales - LAG(Total_Sales) OVER (
 PARTITION BY Store_Location
 ORDER BY Transaction_Year) ) / NULLIF ( LAG(Total_Sales) OVER (
 PARTITION BY Store_Location
 ORDER BY Transaction_Year), 0) AS DECIMAL (10,2)) AS Percentage_Change,

 CAST(100.0 *  Total_Sales / SUM(Total_Sales) OVER (
 PARTITION BY Transaction_Year
  ) AS DECIMAL (10,2)) AS Store_Percentage 

FROM StoreSales 
ORDER BY  Transaction_Year, Total_Sales Desc;

----Sales Performance per Product By Year----
----2024----

select Product_Category, Transaction_Year, sum (Sales)  as Total_Sales 
from prime_mart_mall
where Transaction_Year = '2024'
group by Product_Category, Transaction_Year 
order by  3 Desc; 

---2025----

select Product_Category, Transaction_Year, sum(Sales) as Total_Sales
from prime_mart_mall
where Transaction_Year = '2025'
group by Product_Category, Transaction_Year 
order by 3 Desc;

----2026----

select Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Transaction_Year = '2026'
group by Product_Category, Transaction_Year 
Order by 3 Desc; 

----Yaba Sales Analysis----
----Sales by Year---
With Yabastoresales as (select Store_Name, Transaction_Year, sum(Sales) as  Total_Sales
from prime_mart_mall
where Store_Name = 'Prime Mart Yaba'
group by Store_Name, Transaction_Year )
select 
Store_Name, Transaction_Year, Total_Sales,

Cast(100.0 * (Total_Sales - lag(Total_Sales) over (
partition by Store_Name 
order by Transaction_Year)) / Nullif(lag(Total_Sales) over (
partition by Store_Name 
order by Transaction_Year),0) as decimal (10,2)) as Percentage_Change

from Yabastoresales
order by Transaction_Year asc;

----sales by Month----
----2024-----

with Yabastoresalesmonth as (
select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2024'
group by Store_Location, Transaction_Year, Traansaction_Month )
select 
Store_Location, Transaction_Year, Traansaction_Month, Total_Sales,

CAST( 100.0 * ( Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        )
    ) / NULLIF(
        LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        ), 0
    ) AS DECIMAL(10,2)
) AS Percentage_Change

from Yabastoresalesmonth
order by 
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc; 

----2025---

with Yabastoresalesmonth as (Select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Transaction_Year = '2025' and Store_Location = 'Yaba'
group by Store_Location, Transaction_Year, Traansaction_Month)
select 
Store_Location,
Transaction_Year,
Traansaction_Month,
Total_Sales, 

cast (100.0 * (Total_Sales - lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end)) / nullif ( lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end),0) as decimal (10,2)) as Percentage_Change 

from Yabastoresalesmonth 
order by 
Case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
     when 'December' then 12 
end asc;

----2026----

with Yabastoresalesmonth as (Select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Transaction_Year = '2026' and Store_Location = 'Yaba'
group by Store_Location, Transaction_Year, Traansaction_Month)
select 
Store_Location,
Transaction_Year,
Traansaction_Month, 
Total_Sales, 

cast (100.0 * (Total_Sales - lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end)) / nullif ( lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end),0) as decimal (10,2)) as Percentage_Change 

from Yabastoresalesmonth 
order by 
Case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
     when 'December' then 12 
end asc;

----Top 3 Highest selling Products at Yaba store per annum---- 
----2024----
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2024'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

----2025----
select Top 3 Store_Location, Product_Category, Transaction_Year, Sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2025'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

----2026----
select top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2026'
group by Store_Location, Product_Category, Transaction_Year
order by 4 Desc;

----Bottom 3 Products Yaba store ----
select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2024' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

----2025---
select top 3 Store_Location,Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2025'
group by Store_Location, Product_Category, Transaction_Year
order by 4 Desc;

----2026----

select top 3 Store_Location,Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Yaba' and Transaction_Year = '2026'
group by Store_Location, Product_Category, Transaction_Year
order by 4 Desc; 

----Ikeja Sales Analysis----
----Sales by Year---
With Yabastoresales as (select Store_Location, Transaction_Year, sum(Sales) as  Total_Sales
from prime_mart_mall
where Store_Location = 'Ikeja'
group by Store_Location, Transaction_Year )
select 
Store_Location, Transaction_Year, Total_Sales,

Cast(100.0 * (Total_Sales - lag(Total_Sales) over (
partition by Store_Location
order by Transaction_Year)) / Nullif(lag(Total_Sales) over (
partition by Store_Location 
order by Transaction_Year),0) as decimal (10,2)) as Percentage_Change

from Yabastoresales
order by Transaction_Year asc;

----sales by Month----
----2024-----

with Ikejastoresalesmonth as (
select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2024'
group by Store_Location, Transaction_Year, Traansaction_Month )
select 
Store_Location, Transaction_Year, Traansaction_Month, Total_Sales,

CAST( 100.0 * ( Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        )
    ) / NULLIF(
        LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        ), 0
    ) AS DECIMAL(10,2)
) AS Percentage_Change

from Ikejastoresalesmonth
order by 
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc; 

----2025---

with Ikejastoresalesmonth as (Select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Transaction_Year = '2025' and Store_Location = 'Ikeja'
group by Store_Location, Transaction_Year, Traansaction_Month)
select 
Store_Location,
Transaction_Year,
Traansaction_Month,
Total_Sales, 

cast (100.0 * (Total_Sales - lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end)) / nullif ( lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end),0) as decimal (10,2)) as Percentage_Change 

from Ikejastoresalesmonth 
order by 
Case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
     when 'December' then 12 
end asc;

----2026----

with Ikejastoresalesmonth as (Select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Transaction_Year = '2026' and Store_Location = ''
group by Store_Location, Transaction_Year, Traansaction_Month)
select 
Store_Location,
Transaction_Year,
Traansaction_Month, 
Total_Sales, 

cast (100.0 * (Total_Sales - lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end)) / nullif ( lag(Total_Sales) over (
order by 
case Traansaction_Month 
     when 'January' then 1
	 when 'February' then 2 
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10
	 when 'November' then 11 
	 when 'December' then 12 
end),0) as decimal (10,2)) as Percentage_Change 

from Ikejastoresalesmonth 
order by 
Case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
     when 'December' then 12 
end asc;

----Top 3 Highest selling Products----
---2024---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2024'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

---2025---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2025'
group by Store_Location, Product_Category, Transaction_Year
order by 4 Desc;

---2026---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2026'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

----Bottom 3 Products Ikeja store ----
---2024---
select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2024' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

---2025---

select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2024' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

---2026---

select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Ikeja' and Transaction_Year = '2024' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

----Lekki Sales Analysis----
----Sales by Year---
With Lekkistoresales as (select Store_Location, Transaction_Year, sum(Sales) as  Total_Sales
from prime_mart_mall
where Store_Location = 'Lekki'
group by Store_Location, Transaction_Year )
select 
Store_Location, Transaction_Year, Total_Sales,

Cast(100.0 * (Total_Sales - lag(Total_Sales) over (
partition by Store_Location
order by Transaction_Year)) / Nullif(lag(Total_Sales) over (
partition by Store_Location 
order by Transaction_Year),0) as decimal (10,2)) as Percentage_Change

from Lekkistoresales
order by Transaction_Year asc;

----sales by Month----
----2024-----

with Lekkistoresalesmonth as (
select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2024'
group by Store_Location, Transaction_Year, Traansaction_Month )
select 
Store_Location, Transaction_Year, Traansaction_Month, Total_Sales,

CAST( 100.0 * ( Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        )
    ) / NULLIF(
        LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        ), 0
    ) AS DECIMAL(10,2)
) AS Percentage_Change

from Lekkistoresalesmonth
order by 
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc; 

----2025----

with Lekkistoresalesmonth as (
select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2025'
group by Store_Location, Transaction_Year, Traansaction_Month )
select 
Store_Location, Transaction_Year, Traansaction_Month, Total_Sales,

CAST( 100.0 * ( Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        )
    ) / NULLIF(
        LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        ), 0
    ) AS DECIMAL(10,2)
) AS Percentage_Change

from Lekkistoresalesmonth
order by 
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc; 

----2026-----

with Lekkistoresalesmonth as (
select Store_Location, Transaction_Year, Traansaction_Month, sum(Sales) as Total_Sales
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2026'
group by Store_Location, Transaction_Year, Traansaction_Month )
select 
Store_Location, Transaction_Year, Traansaction_Month, Total_Sales,

CAST( 100.0 * ( Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        )
    ) / NULLIF(
        LAG(Total_Sales) OVER (
            ORDER BY CASE Traansaction_Month
                WHEN 'January' THEN 1
                WHEN 'February' THEN 2
                WHEN 'March' THEN 3
                WHEN 'April' THEN 4
                WHEN 'May' THEN 5
                WHEN 'June' THEN 6
                WHEN 'July' THEN 7
                WHEN 'August' THEN 8
                WHEN 'September' THEN 9
                WHEN 'October' THEN 10
                WHEN 'November' THEN 11
                WHEN 'December' THEN 12
            END
        ), 0
    ) AS DECIMAL(10,2)
) AS Percentage_Change

from Lekkistoresalesmonth
order by 
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2
	 when 'March' then 3
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc; 
----Top 3  Highest selling  products----
---2024---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2024'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

---2025---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2025'
group by Store_Location, Product_Category, Transaction_Year
order by 4 Desc;

---2026---
select Top 3 Store_Location, Product_Category, Transaction_Year, sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2026'
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Desc;

----Bottom 3 Products Ikeja store ----
---2024---
select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2024' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

---2025---

select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2025' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;

---2026---

select top 3 Store_Location, Product_Category, Transaction_Year,sum(Sales) as Total_Sales 
from prime_mart_mall
where Store_Location = 'Lekki' and Transaction_Year = '2026' 
group by Store_Location, Product_Category, Transaction_Year 
order by 4 Asc;













---Total Order---
select sum(Order_Quantity) as Total_Order 
from prime_mart_mall

----Total order quantity by year per store---- 

select Transaction_Year, Store_Location, sum(Order_Quantity) as Total_Order_Quantity 
from prime_mart_mall 
group by Transaction_Year, Store_Location
order by 1 asc, 3 Desc

-----Total order quantity by year per store and percentage change----

WITH StoreOrders AS (
    SELECT Store_Location,Transaction_Year, SUM(Order_Quantity) AS Total_Order_Quantity
    FROM prime_mart_mall
    GROUP BY Store_Location, Transaction_Year
	)
SELECT
    Store_Location,
    Transaction_Year,
    Total_Order_Quantity,

    CAST(100.0 * (
        Total_Order_Quantity - LAG(Total_Order_Quantity) OVER (
            PARTITION BY Store_Location
            ORDER BY Transaction_Year
        ) 
    ) / NULLIF(
        LAG(Total_Order_Quantity) OVER (
            PARTITION BY Store_Location
            ORDER BY Transaction_Year
        ), 0
    ) AS DECIMAL(10,2)) AS Percentage_Change

from StoreOrders
order by Transaction_Year Asc, Total_Order_Quantity Desc;

----Average unit price / Total order per month for each store by year ---- 
---2024---

select Store_Location, Transaction_Year, Traansaction_Month,  Avg(Unit_Price) as Average_Unit_Price, sum(Order_Quantity) as Total_Order_Quantity
from prime_mart_mall 
where Transaction_Year = '2024'
group by Store_Location, Transaction_Year, Traansaction_Month 
order by  2 asc,
case Traansaction_Month 
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July'then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc,  4 desc

---2025----

select Store_Location, Transaction_Year, Traansaction_Month, avg(Unit_Price) as Average_Unit_Price, sum(Order_Quantity) as Total_Order_Quantity
from prime_mart_mall
where Transaction_Year = '2025'
group by Store_Location, Transaction_Year, Traansaction_Month
order by  2 asc,
case Traansaction_Month
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July'then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc,  4 desc

---2026----

select Store_Location, Transaction_Year, Traansaction_Month, avg(Unit_Price) as Average_Unit_Price, sum(Order_Quantity) as Total_Order_Quantity
from prime_mart_mall
where Transaction_Year = '2026'
group by Store_Location, Transaction_Year, Traansaction_Month
order by  2 asc,
case Traansaction_Month
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July'then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
end asc,  4 desc

---Average Yearly selling price---

select Store_Location, Transaction_Year, Avg(Unit_Price) as Average_Unit_Price 
from prime_mart_mall
group by Store_Location, Transaction_Year 
order by 2 asc, 3 desc 

---Total yearly patronage within stores----

select Store_Location, Transaction_Year, count(Customer_ID)  as Total_Customer 
from prime_mart_mall
group by Store_Location, Transaction_Year 
order by 2 asc, 3 desc 


WITH StoreCustomers AS (
    SELECT
        Store_Location,
        Transaction_Year,
        COUNT(Customer_ID) AS Total_Customer
    FROM prime_mart_mall
    GROUP BY Store_Location, Transaction_Year
)
SELECT
    Store_Location,
    Transaction_Year,
    Total_Customer,

    CAST(100.0 * (
        Total_Customer - LAG(Total_Customer) OVER (
            PARTITION BY Store_Location
            ORDER BY Transaction_Year
        ) 
    ) / NULLIF(
        LAG(Total_Customer) OVER (
            PARTITION BY Store_Location
            ORDER BY Transaction_Year
        ), 0
    ) AS DECIMAL(10,2)) AS Percentage_Change,

    CAST(100.0 * Total_Customer /
        SUM(Total_Customer) OVER (
            PARTITION BY Transaction_Year
        ) AS DECIMAL(10,2)) AS Store_Percentage

FROM StoreCustomers
ORDER BY Transaction_Year, Total_Customer DESC; 

----Average Yearly Discount per store----

select Store_Location, Transaction_Year, Avg(Discount) as Average_Discount
from prime_mart_mall
group by Store_Location, Transaction_Year 
order by Transaction_Year Asc, Average_Discount Desc 
----Total Yearly Discount per store---
select Store_Location, Transaction_Year, sum(Discount) as Total_Discount 
from prime_mart_mall
group by Store_Location, Transaction_Year 
order by 2 Asc, 3 Desc

----To understand month distrubution per year---- 
select Transaction_Year, Traansaction_Month 
from Prime_mart_mall 
group by Transaction_Year, Traansaction_Month 
order by 1 asc, 
Case Traansaction_Month	
     when 'January' then 1
     when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5 
	 when 'June' then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11 
	 when 'December' then 12 
end asc;

---Yearly sales performance by store---
---2024---

select Transaction_Year, Store_Name, sum(Sales) as Total_2024_Sales 
from prime_mart_mall
where Transaction_Year = '2024'
group by Transaction_Year, Store_Name 
order by 3 Desc 

---2025---

select Transaction_Year, Store_Name, sum(sales) as Total_2025_Sales 
from prime_mart_mall
where Transaction_Year = '2025'
group by Transaction_Year, Store_Name
order by 3 Desc 

---2026---

select Transaction_Year, Store_Name, sum(Sales) as Total_2026_Sales 
from prime_mart_mall
where Transaction_Year = '2026'
group by Transaction_Year, Store_Name
order by 3 Desc 




---monthly sales performance per store----
---2024----

select Transaction_Year, Traansaction_Month, Store_Name, sum (Sales) as Total_Sales 
from prime_mart_mall 
where Transaction_Year = '2024'
group by Transaction_Year, Traansaction_Month, Store_Name
order by 
CASE Traansaction_Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END ASC;

---2025----
select Transaction_Year, Traansaction_Month, Store_Location, sum(Sales) as Total_Sales 
from prime_mart_mall
where Transaction_Year = '2025'
group by Transaction_Year, Traansaction_Month, Store_Location 
order by 
CASE  Traansaction_Month 
      When 'January' then 1
	  when 'February' then 2
	  when 'March' then 3
	  when 'April' then 4
	  when 'May' then 5
	  when 'June' then 6
	  when 'July' then 7 
	  when 'August' then 8 
	  when 'September' then 9
	  when 'October'then 10
	  when 'November' then 11
	  when 'December' then 12 
   End Asc; 

---2026---

select Transaction_Year, Traansaction_Month, Store_Name, sum(Sales) as Total_Sales 
from prime_mart_mall 
where Transaction_Year = '2026'
group by Transaction_Year, Traansaction_Month, Store_Name
order by 
CASE Traansaction_Month
     when 'January' then 1 
	 when 'February' then 2 
	 when 'March' then 3 
	 when 'April' then 4 
	 when 'May' then 5
	 when 'June'then 6 
	 when 'July' then 7 
	 when 'August' then 8 
	 when 'September' then 9 
	 when 'October' then 10 
	 when 'November' then 11
	 when 'December' then 12 
	End Asc; 

---Product category sales performance by store --- 

select Store_Name, Product_Category, sum(Sales) as Total_Sales 
from prime_mart_mall
group by Store_Name, Product_Category 
order by 2 Asc

----Profit analysis---

select Store_Location, Transaction_Year, sum(Sales) as Total_Sales, sum(Profit) as Total_Profit,
cast (100.0 * sum(Profit) / Nullif(sum(Sales),0) as decimal (10,2)) as Profit_Margin 
from prime_mart_mall
group by Store_Location, Transaction_Year 
order by Transaction_Year Asc;

----Total Profit Per store---

Select Store_Location, Sum(Profit) as Total_Profit
from prime_mart_mall
group by Store_Location 
order by 2 Desc;

-----Total Profit--- 

select sum(Profit) as Total_Profit
 from prime_mart_mall

-----Total Sales----
Select sum(Sales) as Overall_Sales
from prime_mart_mall

----Top 3 best selling products across all three stores in three years-----

select top 3 Product_Category, sum(Sales) as Total_Sales 
from prime_mart_mall 
group by Product_Category 
order by 2 Desc; 

---Bottom 3 selling products across all three stores in three years----

select top 3 Product_Category, sum(Sales) as Total_Sales 
from prime_mart_mall 
group by Product_Category 
order by 2 asc; 

---2025 sales Trend been the best selling year---- 

select Store_Location, Transation_Year, Traansaction_Month, Salw









