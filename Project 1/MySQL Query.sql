## Already set sales as default schema
	SHOW TABLES

## performing some queries on customers table
	SELECT * FROM customers
	SELECT COUNT(*) FROM customers
	SELECT CONCAT("The sale for ",custmer_name, " is ", SUM(sales_amount) , "$." ) AS "Sale belong to Customer" FROM customers JOIN transactions ON customers.customer_code = transactions.customer_code group by custmer_name

## Performing some queries on transactions tabel
	SELECT * FROM transactions
	SELECT COUNT(DISTINCT product_code) FROM transactions
	SELECT DISTINCT customer_code FROM transactions WHERE market_code = "mark004"
	select sum(sales_amount) from transactions where customer_code = "cus006"
	SELECT sales_qty, sales_amount FROM transactions ## some of the entries have >0 sales quantity but <0 sales amount, Needs to be filtered
	SELECT COUNT(sales_amount) FROM transactions WHERE sales_amount <= 0 ## TOTAL 1611 entries have <0 amount 
	SELECT custmer_name as "Customer Name", sum(sales_qty) as "Total Sold quantities", sum(sales_amount)  as "Total Sale by CX" from customers inner join transactions on customers.customer_code = transactions.customer_code group by customers.custmer_name order by sum(sales_amount) desc
	SELECT * FROM transactions WHERE currency = "USD" ## Need to convert this USD to INR including the amount in sales_amount
	SELECT DISTINCT currency from transactions ## this has 2 time each currency 'USD', 'USD ' and we do not need second one that is glitchtransactionstransactions

## Performing some queries on markets tabel
	SELECT * FROM markets  ## New York and Paris need to be filterd out (remove them)
	SELECT COUNT(DISTINCT markets_code) FROM markets

## Performing some queries on date tabel
	SELECT DISTINCT year FROM date
	SELECT * FROM date
	SELECT SUM(sales_amount) FROM transactions JOIN date ON transactions.order_date = date.date WHERE date.year = 2020
	SELECT SUM(sales_amount) FROM transactions JOIN date ON transactions.order_date = date.date WHERE date.year = 2020 AND date.month_name = "February"
	SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and date.month_name="February"

