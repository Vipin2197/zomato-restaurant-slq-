create database Zomato;

CREATE TABLE Main (
    RestaurantID INT,
    RestaurantName VARCHAR(255),
    CountryCode INT,
    City VARCHAR(255),
    Address VARCHAR(255),
    Locality VARCHAR(255),
    LocalityVerbose VARCHAR(255),
    Longitude FLOAT,
    Latitude FLOAT,
    Cuisines VARCHAR(255),
    Currency VARCHAR(255),
    Has_Table_booking VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range INT,
    Votes INT,
    Average_Cost_for_two INT,
    Rating FLOAT,
    Year_Opening INT,
    Month_Opening INT,
    Day_Opening INT
);

CREATE TABLE Currency (
    CurrencyName VARCHAR(100),
    USDRate DECIMAL(10, 6)
);

CREATE TABLE Country (
    CountryCode INT PRIMARY KEY,
    CountryName VARCHAR(100)
);


CREATE TABLE CalendarTable (
    DateKey DATE PRIMARY KEY,
    Year INT,
    MonthNo INT,
    MonthName VARCHAR(15),
    Quarter VARCHAR(2),
    YearMonth VARCHAR(10),
    WeekdayNo INT,
    WeekdayName VARCHAR(10),
    FinancialMonth VARCHAR(5),
    FinancialQuarter VARCHAR(5)
);

SELECT 
    CONCAT(Year_Opening, '-', LPAD(month_opening, 2, '0'), '-01') AS cal_date,
    year_opening,
    month_opening,
    MONTHNAME(STR_TO_DATE(month_opening, '%m')) AS month_name,
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(Year_Opening, '-', Month_Opening, '-01'), '%Y-%m-%d'))) AS quarter
FROM main;


ALTER TABLE main
ADD COLUMN datekey_opening DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE main
SET datekey_opening = STR_TO_DATE(CONCAT(year_opening, '-', LPAD(month_opening, 2, '0'), '-01'), '%Y-%m-%d');

SET SQL_SAFE_UPDATES = 1;  -- Turn it back on if needed

SELECT 
    MIN(datekey_opening) AS min_date,
    MAX(datekey_opening) AS max_date
FROM main;

WITH RECURSIVE calendar AS (
    SELECT DATE('2015-01-01') AS cal_date
    UNION ALL
    SELECT cal_date + INTERVAL 1 DAY
    FROM calendar
    WHERE cal_date + INTERVAL 1 DAY <= DATE('2024-12-31')
)
SELECT 
    cal_date,
    YEAR_opening(cal_date) AS year,
    MONTH_opening(cal_date) AS month,
    MONTHNAME(cal_date) AS month_name,
    CONCAT('Q', QUARTER(cal_date)) AS quarter,
    DAY_opening(cal_date) AS day
FROM calendartable;

-- Percentage of Restaurants based on Has_Online_delivery
SELECT 
    has_online_delivery,
    CONCAT(ROUND(COUNT(Has_Online_delivery) / (SELECT COUNT(*) FROM main) * 100, 1), '%') AS percentage 
FROM 
    main
GROUP BY 
    has_online_delivery;
    
/* 2 */
    select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) days ,
monthname(Datekey_Opening) monthname,Quarter(Datekey_Opening)as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='January' then 'FM11'
when monthname(datekey_opening)='February' then 'FM12'
when monthname(datekey_opening)='March' then 'FM1'
when monthname(datekey_opening)='April'then'FM2'
when monthname(datekey_opening)='May' then 'FM3'
when monthname(datekey_opening)='June' then 'FM4'
when monthname(datekey_opening)='July' then 'FM5'
when monthname(datekey_opening)='August' then 'FM6'
when monthname(datekey_opening)='September' then 'FM7'
when monthname(datekey_opening)='October' then 'FM8'
when monthname(datekey_opening)='November' then 'FM9'
when monthname(datekey_opening)='December'then 'FM10'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters
from main;


/* 3.Find the Numbers of Resturants based on City and Country. */
SELECT  
    Country.countryname, 
    main.city, 
    COUNT(main.restaurantname) AS no_of_restaurants
FROM  
    main
INNER JOIN  
    country ON main.countrycode = country.countrycode
GROUP BY  
    country.countryname, 
    main.city
ORDER BY  
    no_of_restaurants DESC;
    
/* 4.Numbers of Resturants opening based on Year , Quarter , Month. */

select year(datekey_opening)year,quarter(datekey_opening)quarter,monthname(datekey_opening)monthname,count(RestaurantName)as no_of_restaurants 
from main group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) ;

/* 5. Count of Resturants based on Average Ratings. */

select case when rating <=2 then "0-2" when rating <=3 
then "2-3" when rating <=4 then "3-4" when Rating<=5 then "4-5"
 end rating_range,count(RestaurantName) 
from main
group by rating_range 
order by rating_range;

/* #6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets */

select case when price_range=1 then "0-500" when price_range=2 then "500-3000" when Price_range=3 then "3000-10000" when Price_range=4 then ">10000" end price_range,count(RestaurantName)
from main 
group by price_range
order by Price_range;

/*  #7.Percentage of Resturants based on "Has_Table_booking" */

select has_online_delivery,concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from main
group by has_online_delivery;

/* #8.Percentage of Resturants based on "Has_Online_delivery" */
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage
 from main group by has_table_booking;
 
/* highest rating restaurants in each country */

SELECT  
    country.countryname, 
    main.restaurantname, 
    MAX(main.rating) AS highest_rating 
FROM  
    main
INNER JOIN  
    country ON main.countrycode = country.countrycode
GROUP BY  
    country.countryname, 
    main.restaurantname 
ORDER BY  
    highest_rating DESC;
    
/*  top 5 restaurants who has more number of votes */

SELECT  
   country.countryname, 
    main.restaurantname, 
    MAX(main.votes) AS max_votes, 
    AVG(main.Average_Cost_for_two) AS avg_cost_for_two 
FROM  
    main
INNER JOIN  
    country ON main.countrycode = country.countrycode 
GROUP BY  
    country.countryname, 
    main.restaurantname 
ORDER BY  
    max_votes DESC 
LIMIT 5;

/* top restaurant with highest rating and votes from each country */

SELECT  
    country.countryname, 
   main.restaurantname, 
    MAX(main.rating) AS highest_rating, 
    MAX(main.votes) AS max_votes
FROM  
    main
INNER JOIN  
    country ON main.countrycode = country.countrycode
GROUP BY  
   country.countryname, 
    main.restaurantname 
ORDER BY  
    max_votes DESC 
LIMIT 5;

SELECT 
  SUBSTRING_INDEX(cuisines, ',',1) AS split
FROM main;

SELECT restaurantname,
  cuisines,SUBSTRING_INDEX(cuisines, ',',1) AS split,SUBSTRING_INDEX(cuisines, ',',2) AS split,
  SUBSTRING_INDEX(cuisines, ',',1) 
FROM main;

SELECT 
  restaurantname, cuisines,
  SUBSTRING_INDEX(cuisines, ',', 1) AS cuisine1,
  SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 2), ',', -1) AS cuisine2,
SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 3), ',', -1) AS cuisine3
FROM main;

