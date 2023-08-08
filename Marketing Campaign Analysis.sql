# Analyze Seasonality with SQL

# Sales Volume & Website Traffic Trends

select month(date) as month
, sum(sales) as sales
, sum(sessions) as sessions
from site_data where client = 'A' group by 1

--date_trunc('year', date) as week in mysql


# Related Keywords Search Volume

select date
, sum(search_volume) as searches from keyword_data
where lower(keyword) in (select distinct keyword from keyword_data)
    group by 1

# Campaign Effectiveness by Channel

select channel
,sum(attributed_sales) as revenue 
,sum(conversions)/sum(impressions) as conv_rate 
,sum(attributed_sales)/sum(spend) as ROAS 
,sum(attributed_sales)-sum(spend) as net_profit
from campaign_performance where client = 'A'
and date between '2022-01-01' and '2022-12-31' group by 1

 # Behavioral Targeting
 # Most Purchased Categories

select
category,
sum(sales) as sales from user_level_sales
where
age_group = '35-39'
and region = 'NY'
and gender = 'F'
and brand = 'A'
and date between '2022-01-01'
and '2022-12-31' group by 1

#Average Purchase Frequency
#The average number of transactions per customer per period

select
    count (distinct order_id) / count(distinct customer_id) as frequency 
from user_level_sales
where date between '2022-01-01' and '2022-12-31'
and age_group = '35-39'
and region = 'NY'
and gender = 'F'
and brand = 'A'
and sales > 0


# Average Days Since Last Purchase

with previous_date as
(select
date,
lag(date) over (partition by customer_id order by date) as previous_date
from user_level_sales
where brand = 'A' and sales > 0 and age_group = '35-39'
and date between '2022-01-01' and '2022-12-31' and region = 'NY' and gender = 'F')
select
avg(datediff('day', previous_date, date)) as days_since_last_purchase
from previous_date
where previous_date not null
