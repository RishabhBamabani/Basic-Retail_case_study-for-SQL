

-------------------------DATA PREPARATION AND UNDERSTANDING--------------------------------------------------
--1.What is the total number of rows in each of the 3 tables in the database?

SELECT COUNT(*) FROM CUSTOMER
SELECT COUNT(*) FROM prod_cat_info
SELECT COUNT(*) FROM Transactions

--2.What is the total number of transactions that have a return?

SELECT COUNT(TOTAL_AMT) FROM Transactions
WHERE TOTAL_AMT LIKE '-%'


select count(TOTAL_AMT) from transactions
where  TOTAL_AMT  < 0

select * from Transactions


--3.As you would have noticed, the dates provided across the 
----datasets are not in a correct format. As first steps, pls 
----convert the date variables into valid date formats before proceeding ahead.

SELECT CONVERT(DATE, DOB, 105) AS DATES FROM CUSTOMER 
SELECT CONVERT(DATE, TRAN_DatE, 105) FROM Transactions

SELECT CONVERT(DATE , DOB , 103) AS dates from Customer

--4.What is the time range of the transaction data available for analysis? 
	---Show the output in number of days, months and years simultaneously
	---in different columns.
	
SELECT DATEDIFF(DAY, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))), 
DATEDIFF(MONTH, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))),  
DATEDIFF(YEAR, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))) 
FROM Transactions

  


--5.Which product category does the sub-category “DIY” belong to?

SELECT PROD_CAT
FROM prod_cat_info
WHERE PROD_SUBCAT LIKE 'DIY'


select prod_cat
from prod_cat_info
where prod_subcat = 'DIY'


-------------------------------DATA ANALYSIS---------------------------------------------------------------
--1.Which channel is most frequently used for transactions?
--###ANS.==e-Shop

SELECT TOP 1 
STORE_TYPE, COUNT(TRANSACTION_ID) as count_transactions
FROM TRANSACTIONS
GROUP BY STORE_TYPE
ORDER BY COUNT(TRANSACTION_ID) DESC

SELECT * FROM Transactions
------------------- OR--------------
SELECT TOP 1 
COUNT(TRANSACTION_ID) AS COUNT_TRANS , Store_type
FROM Transactions
GROUP BY STORE_TYPE
ORDER BY COUNT(transaction_id) DESC

--2.What is the count of Male and Female customers in the database?
---ANS. FEMLES = 2753, MALES = 2892

SELECT GENDER, COUNT(CUSTOMER_ID) AS COUNT_Gender 
FROM CUSTOMER
WHERE GENDER IN ('M' , 'F')
GROUP BY GENDER

----------OR-------------

SELECT * FROM Customer

SELECT COUNT(CUSTOMER_ID) as count_gender, GENDer
from Customer
where gender in ('m' , 'f')
group by Gender


--3.From which city do we have the maximum number of customers and how many?
---ANS. 595 CUSTOMER FROM CITY CODE 3

SELECT top 1
CITY_CODE, COUNT(CUSTOMER_ID) CUST_CNT
FROM CUSTOMER
GROUP BY CITY_CODE
ORDER BY CUST_CNT DESC

---------------OR----------
SELECT * FROM Customer

select top 1
count(customer_id) as cust_count , city_code
from Customer
group by city_code
order by count(customer_Id) desc



--4.How many sub-categories are there under the Books category?
--ANS. =6.

SELECT COUNT(PROD_SUBCAT) AS SUBCAT_CNT
FROM prod_cat_info
WHERE PROD_CAT = 'BOOKS'
GROUP BY PROD_CAT

select* from prod_cat_info

----------OR--------------

select count(prod_subcat) as subcat_count 
from prod_cat_info
where prod_cat = 'books'

--5.What is the maximum quantity of products ever ordered?
---ANS.5

SELECT TOP 1 QTY 
FROM Transactions
ORDER BY QTY DESC

	--------------OR------------
select * from Transactions

 select top 1
 qty from Transactions
 order by qty desc



--6.What is the net total revenue generated in categories Electronics and Books?
---ANS.23545157.675

select *from  transactions
select *from prod_cat_info


SELECT prod_cat, sum(total_amt) as revenue
FROM prod_cat_info as x
RIGHT JOIN Transactions as y
on x.prod_cat_code = y.prod_cat_code
where prod_cat = 'electronics'
or prod_cat = 'books'
group by prod_cat

-----------OR----------

select *from  transactions
select *from prod_cat_info

select prod_cat , sum(total_amt) as REVENUES	
from prod_cat_info as P
 join  Transactions as T
on T.prod_cat_code = p.prod_cat_code
where prod_cat = 'electronics' 
or prod_cat = 'books'
group by prod_cat

--7.How many customers have >10 transactions with us, excluding returns?
----ANS. 6 CUSTOMERS

SELECT COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT
FROM CUSTOMER WHERE CUSTOMER_ID IN 
(
SELECT CUST_ID
FROM Transactions
LEFT JOIN CUSTOMER ON CUSTOMER_ID = CUST_ID
WHERE TOTAL_AMT NOT LIKE '-%'
GROUP BY
CUST_ID
HAVING COUNT(TRANSACTION_ID) > 10
)

-------------OR--------------

select * from Customer
select * from Transactions

select count(customer_id) as count_custo
from customer where customer_id IN
(
select cust_id
from Transactions as t
left join Customer as c
on t.cust_id = c.customer_Id
where total_amt not like '-%'
group by cust_Id
having count(cust_id)> 10
)


--8.What is the combined revenue earned from the “Electronics” & “Clothing”
---categories, from “Flagship stores”?
 ---ANS - 57184876

select sum(revenue) from 
   ( 
    SELECT prod_cat, sum(total_amt) as revenue
    FROM prod_cat_info as x
    RIGHT JOIN Transactions as y
    on x.prod_cat_code = y.prod_cat_code
    where prod_cat = 'electronics'
    or prod_cat = 'clothing'
    and Store_type = 'flagship store'
    group by prod_cat
  ) as x
  



--9.What is the total revenue generated from “Male” customers 
	---in “Electronics” category? Output should display total revenue by 
  	--prod sub-cat.
	select * from prod_cat_info
	select * from Transactions
	select * from Customer

SELECT PROD_SUBCAT,SUM(TOTAL_AMT) REVENUE
FROM Transactions as t
LEFT JOIN CUSTOMER as c ON t.CUST_ID= c.customer_Id
LEFT JOIN Prod_cat_info as p
on t.prod_subcat_code =  p.prod_sub_cat_code and t.prod_cat_code = p.prod_cat_code
WHERE prod_cat = 'electronics' AND GENDER = 'M'
GROUP BY PROD_SUBCAT_CODE, PROD_SUBCAT


--10.What is percentage of sales and returns by product sub category; 
  ---  display only top 5 sub categories in terms of sales?


  select * from Transactions
  select * from prod_cat_info


select top 5
prod_subcat , (SUM(TOTAL_AMT)/(SELECT SUM(TOTAL_AMT) FROM Transactions))*100 AS PERCANTAGE_OF_SALES, 
(COUNT(CASE WHEN QTY< 0 THEN QTY ELSE NULL END)/SUM(QTY))*100 AS PERCENTAGE_OF_RETURN
from Transactions as t
inner join prod_cat_info as p 
on t.prod_cat_code = p.prod_cat_code
group by prod_subcat
order by sum(total_amt) desc



--11.For all customers aged between 25 to 35 years find what is the 
	--net total revenue generated by these consumers in last 30 days of transactions
	--from max transaction date available in the data?
	select * from Customer
	select * from Transactions

SELECT CUST_ID,SUM(TOTAL_AMT) AS REVENUE FROM Transactions
WHERE CUST_ID IN 
	(SELECT CUSTOMER_ID
	 FROM CUSTOMER
     WHERE DATEDIFF(YEAR,CONVERT(DATE,DOB,103),GETDATE()) BETWEEN 25 AND 35)
     AND CONVERT(DATE,TRAN_DATE,103) BETWEEN DATEADD(DAY,-30,(SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM Transactions)) 
	 AND (SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM Transactions)
GROUP BY CUST_ID



--12.Which product category has seen the max value of returns in the last 3 
	--months of transactions?
	--ANS.Bags= -28657.0701293945

SELECT TOP 1 PROD_CAT, SUM(TOTAL_AMT) FROM Transactions as  T
INNER JOIN prod_cat_info  p
ON t.PROD_CAT_CODE = p.PROD_CAT_CODE  
and T.PROD_SUBCAT_CODE = p.PROD_SUB_CAT_CODE
WHERE TOTAL_AMT < 0 AND 
CONVERT(date, TRAN_DATE, 103) BETWEEN DATEADD(MONTH,-3,(SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM Transactions)) 
	 AND (SELECT MAX(CONVERT(DATE,TRAN_DATE,103)) FROM TRANSACTIONs)
GROUP BY PROD_CAT
ORDER BY 2 DESC

--13.Which store-type sells the maximum products; by value of sales amount and
	--by quantity sold?

	--ANS.E-shop = 19861723.0530701

SELECT  STORE_TYPE, SUM(TOTAL_AMT) TOT_SALES, SUM(QTY) TOT_QUAN
FROM Transactions
GROUP BY STORE_TYPE
HAVING SUM(TOTAL_AMT) >=ALL (SELECT SUM(TOTAL_AMT) FROM Transactions GROUP BY STORE_TYPE)
AND SUM(QTY) >=ALL (SELECT SUM(QTY) FROM TRANSACTIONs GROUP BY STORE_TYPE)
 

--14.What are the categories for which average revenue is above the overall average.

SELECT PROD_CAT, AVG(TOTAL_AMT) AS AVERAGE
FROM TRANSACTIONs t 
INNER JOIN prod_cat_info p 
ON t.prod_cat_code = p.prod_cat_code AND PROD_SUB_CAT_CODE=PROD_SUBCAT_CODE
GROUP BY PROD_CAT
HAVING AVG(TOTAL_AMT)> (SELECT AVG(TOTAL_AMT) FROM Transactions) 

--15.Find the average and total revenue by each subcategory for the categories 
	--which are among top 5 categories in terms of quantity sold.


SELECT PROD_CAT, PROD_SUBCAT, AVG(TOTAL_AMT) AS AVERAGE_REV, SUM(TOTAL_AMT) AS REVENUE
FROM Transactions as t
INNER JOIN prod_cat_info as p  
ON t.prod_cat_code = p.PROD_CAT_CODE AND PROD_SUB_CAT_CODE=PROD_SUBCAT_CODE
WHERE PROD_CAT IN
(
SELECT TOP 5 
PROD_CAT
FROM Transactions as t
INNER JOIN prod_cat_info as p 
ON t.prod_cat_code = p.prod_cat_code AND PROD_SUB_CAT_CODE = PROD_SUBCAT_CODE
GROUP BY PROD_CAT
ORDER BY SUM(QTY) DESC
)
GROUP BY PROD_CAT, PROD_SUBCAT 