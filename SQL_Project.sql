/*
Created by: Bhavishya Sharma
Created date: 21/07/2025
Description: This project uses SQL queries on WSDA Music to extract actionable insights from customer and sales data, spanning basic to advanced levels.
*/

												Basic Questions 
                                                
-- 1. List the names of all customers along with the country they belong to.

SELECT
firstname ||' '|| lastname as Customer_Name,
country
FROM
Customer

-- 2. How many total invoices were generated in each country?

SELECT
billingcountry AS Country,
Count(invoiceid) AS	Total_Invoices
FROM
Invoice
GROUP BY
billingcountry
ORDER BY
Total_Invoices DESC

-- 3. List all playlists along with how many tracks each contains.

SELECT
p.Name,
COUNT(pt.TrackId) as Tracks
FROM
Playlist as p
JOIN
PlaylistTrack as pt
ON
p.PlaylistId = pt.PlaylistId
GROUP by
p.Name
ORDER by
Tracks desc

												Moderate Questions 
                                                
-- 4. Retrieve all invoice records where the total amount is greater than 1.98 and the billing city starts with either 'P' or 'D'.

SELECT
billingaddress,
billingcity,
billingcountry,
total
FROM
Invoice
WHERE
total > 1.98 and (billingcity like 'P%' or billingcity like 'D%')

-- 5. Find the top 5 customers who spent the most money.

SELECT
c.firstname ||' '|| c.lastname as Customer_Name,
sum(I.total) as Total_Spent
FROM
Customer as C
JOIN
Invoice as I
ON
c.CustomerId = I.CustomerId
GROUP BY
c.CustomerId
ORDER BY 
Total_Spent DESC
limit 5

-- 6. Find the average invoice total per customer.

SELECT
c.FirstName ||' '||c.LastName AS Customer_Name,
Round(Avg(i.Total),2) as Average_Invoice
FROM
Customer as c
JOIN 
Invoice as I
on
c.CustomerId = I.CustomerId
GROUP BY
c.CustomerId
ORDER BY
Average_Invoice DESC

-- 7. Which employee has supported the most customers?

SELECT
e.FirstName ||' '|| e.LastName as Employee_Name,
COUNT(c.CustomerId) as Customer_Handled
FROM
Customer as C
JOIN
Employee as E
ON
c.SupportRepId = e.EmployeeId
GROUP BY
e.EmployeeId

 
 												Advanced Questions 
                                                
/* 8. Write a SQL query that selects track names, composers, and unit prices, and categorizes each track based on its price.
Price Categories:
Budget: Tracks priced at $0.99 or less
Regular: Tracks priced between $1.00 and $1.49
Premium: Tracks priced between $1.50 and $1.99
Exclusive: Tracks priced above $1.99 */

SELECT
name as Track_Name,
composer,
unitprice as Price,
CASE
WHEN unitprice <=.99 THEN 'Budget'
WHEN unitprice BETWEEN 1 and 1.49 THEN 'Regular'
WHEN unitprice BETWEEN 1.50 and 1.99 THEN 'Premium'
Else 'Exclusive'
END as Price_Category
FROM
Track
ORDER BY
Price DESC
                                                
-- 9. Customers who spent more than the average invoice amount.

SELECT
c.FirstName ||' '|| c.LastName as Customer_Name,
sum(i.total) as Total_Spent
FROM
Customer as c
JOIN
Invoice as i
ON
c.CustomerId = i.CustomerId
GROUP by
c.CustomerId
HAVING 
sum(i.total) >
(SELECT avg(total) from Invoice)
ORDER BY
Total_Spent DESC

-- 10. Total revenue generated each month (Month-Year format).

SELECT
strftime('%Y-%m', invoicedate) as Year_Month,
sum(total) as Total_Revenue
FROM
Invoice
GROUP BY
strftime('%Y-%m', invoicedate)
ORDER BY
Year_Month
