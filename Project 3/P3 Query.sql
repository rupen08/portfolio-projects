CREATE DATABASE videogame;

USE videogame;

## create table same as csv file

CREATE TABLE games(
rank_number INT Primary Key,
game_name VARCHAR(150),
Platform VARCHAR(5),
year_realse INT,
Genre VARCHAR(50),
Publisher VARCHAR(50),
NA_Sales DECIMAL(5,2),
EU_Sales DECIMAL(5,2),
JP_Sales DECIMAL(5,2),
Other_Sales DECIMAL(5,2),
Global_Sales DECIMAL(5,2)
)

## load data from csv file via "Table data import wizard"

SELECT * FROM games;

## How many varities of games are there?
SELECT COUNT(DISTINCT game_name) FROM games;

## Which and How many total platforms are there?
SELECT DISTINCT Platform FROM games;
SELECT COUNT(DISTINCT Platform) FROM games;

## How many total Genre are there in game list?
SELECT DISTINCT Genre FROM games;

## What are the various Publishers?
SELECT DISTINCT Publisher FROM games;
SELECT COUNT(DISTINCT Publisher) FROM games;

## Total sale in North America? Answer will be in Million USD!!
SELECT SUM(NA_Sales) FROM games;
 
## Total sale in Europe? Answer will be in Million USD!!
SELECT SUM(EU_Sales) FROM games;

## TOtal sale in Japan? Answer will be in USD!!
SELECT SUM(JP_Sales) FROM games;

## Some advanced query
SELECT Publisher, SUM(NA_Sales) as " Total NA Sales", SUM(EU_Sales) as "Total EU Sales", SUM(JP_Sales) as "Total JP Sales" FROM games GROUP BY Publisher ;
SELECT year_realse, SUM(NA_Sales) as " Total NA Sales", SUM(EU_Sales) as "Total EU Sales", SUM(JP_Sales) as "Total JP Sales" FROM games GROUP BY year_realse ORDER BY year_realse;

## Give Latest 5 years total sale of NA, EU and Japan produced by Nintendo
SELECT
  year_realse,
  Publisher,
  CONCAT(SUM(NA_Sales), " Million Dollar") AS " Total NA Sales",
  CONCAT(SUM(EU_Sales), " Million Dollar") AS "Total EU Sales",
  CONCAT(SUM(JP_Sales), " Million Dollar") AS "Total JP Sales"
FROM games
WHERE Publisher = "Nintendo"
GROUP BY year_realse
ORDER BY year_realse DESC 
LIMIT 5;

SELECT
  Publisher,
  CONCAT(SUM(NA_Sales), " Million Dollar") AS " Total NA Sales",
  CONCAT(SUM(EU_Sales), " Million Dollar") AS "Total EU Sales",
  CONCAT(SUM(JP_Sales), " Million Dollar") AS "Total JP Sales"
FROM games
GROUP BY Publisher
ORDER BY Publisher ASC;

SELECT * FROM games WHERE genre = "Action" AND year_realse = 2016;
SELECT Genre, year_realse, CONCAT(SUM(NA_Sales), " Million Dollar") AS " Total NA Sales" FROM games WHERE year_realse = 2016 GROUP BY Genre 