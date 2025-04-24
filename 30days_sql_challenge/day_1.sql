1. SELECT and WHERE Clause
✅ Scenario 1:
Q: In the customers table, retrieve details of all customers who live in New York and have made more than 3 orders in the last year. List the customer's name, email, and total_orders.
A:
SELECT c.customer_name, c.email, COUNT(o.order_id) AS total_orders
FROM application.customers c
JOIN application.orders o ON c.customer_id = o.order_customer_id
WHERE c.city = 'New York'
  AND o.order_date >= current_date - interval '1 year'
GROUP BY c.customer_id, c.customer_name, c.email
HAVING COUNT(o.order_id) > 3;
  
✅ Scenario 2:
Q: From the orders table, get all orders where the order_status is 'Completed' and the order_date is between 2023-01-01 and 2023-12-31.
A:
SELECT * 
FROM application.orders 
WHERE order_status = 'Completed' 
  AND order_date BETWEEN '2023-01-01' AND '2023-12-31';
  
✅ Scenario 3:
Q: In the products table, retrieve all product details for products with a price greater than $100 and belonging to the category Electronics.
A:
SELECT * 
FROM application.products 
WHERE price > 100 
  AND category = 'Electronics';
  
✅ Scenario 4:
Q: Fetch all employees who have been with the company for more than 5 years and work in the department Sales. Retrieve their employee_id, name, and hire_date.
A:
SELECT employee_id, name, hire_date
FROM application.employees 
WHERE department = 'Sales' 
  AND hire_date <= current_date - interval '5 years';
  
✅ Scenario 5:
Q: Retrieve all transactions where the transaction_type is 'Debit' and the transaction_date is between 2023-01-01 and 2023-06-30.
A:
SELECT * 
FROM application.transactions 
WHERE transaction_type = 'Debit' 
  AND transaction_date BETWEEN '2023-01-01' AND '2023-06-30';
  -------------------------------------------------------------
2. DISTINCT Keyword
✅ Scenario 1:
Q: Find all distinct cities from the customers table where the customer has made a purchase in the last 6 months.
A:
SELECT DISTINCT city 
FROM application.customers c
JOIN application.orders o ON c.customer_id = o.order_customer_id
WHERE o.order_date >= current_date - interval '6 months';
  
✅ Scenario 2:
Q: List all distinct product_category values from the products table where the price is greater than $50.
A:
SELECT DISTINCT product_category 
FROM application.products 
WHERE price > 50;
  
✅ Scenario 3:
Q: In the orders table, fetch all distinct order_status values for orders placed between 2022-01-01 and 2022-12-31.
A:
SELECT DISTINCT order_status 
FROM application.orders 
WHERE order_date BETWEEN '2022-01-01' AND '2022-12-31';
  
✅ Scenario 4:
Q: Retrieve all distinct payment_methods used by customers in the payments table, where the payment status is Completed.
A:
SELECT DISTINCT payment_method 
FROM application.payments 
WHERE payment_status = 'Completed';
  
✅ Scenario 5:
Q: In the sales table, retrieve all distinct regions where sales have been made, and show only the regions with sales above $10,000 in the last quarter.
A:
SELECT DISTINCT region 
FROM application.sales 
WHERE sale_date >= current_date - interval '3 months'
GROUP BY region
HAVING SUM(sales_amount) > 10000;
  ------------------------------------------------------------------------------------
3. ORDER BY Clause
✅ Scenario 1:
Q: List the top 5 highest-paying customers based on the total spent in the last year.
A:
SELECT customer_id, customer_name, SUM(order_total) AS total_spent
FROM application.orders
WHERE order_date >= current_date - interval '1 year'
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;
  
✅ Scenario 2:
Q: Retrieve all orders ordered by order_date in ascending order.
A:
SELECT * 
FROM application.orders 
ORDER BY order_date ASC;
  
✅ Scenario 3:
Q: List all employees by their hire_date in descending order, and display the first 10 rows.
A:
SELECT * 
FROM application.employees 
ORDER BY hire_date DESC 
LIMIT 10;
  
✅ Scenario 4:
Q: List the top 10 products based on the quantity_sold from the sales table.
A:
SELECT product_id, product_name, SUM(quantity_sold) AS total_quantity 
FROM application.sales 
GROUP BY product_id, product_name
ORDER BY total_quantity DESC 
LIMIT 10;
  
✅ Scenario 5:
Q: Fetch all transactions ordered by transaction_amount DESC and transaction_date ASC.
A:
SELECT * 
FROM application.transactions 
ORDER BY transaction_amount DESC, transaction_date ASC;
  -----------------------------------------------------------------------
4. LIMIT Clause
✅ Scenario 1:
Q: Retrieve the top 10 most recent orders.
A:
SELECT * 
FROM application.orders 
ORDER BY order_date DESC 
LIMIT 10;
  
✅ Scenario 2:
Q: Fetch the first 5 employees ordered by salary in descending order.
A:
SELECT * 
FROM application.employees 
ORDER BY salary DESC 
LIMIT 5;
  
✅ Scenario 3:
Q: Fetch the top 3 highest-grossing products based on total sales.
A:
SELECT product_id, product_name, SUM(total_sales) AS revenue 
FROM application.sales 
GROUP BY product_id, product_name
ORDER BY revenue DESC 
LIMIT 3;
  
✅ Scenario 4:
Q: Display the first 5 customers who made the most purchases.
A:
SELECT * 
FROM application.customers 
ORDER BY total_orders DESC 
LIMIT 5;
  
✅ Scenario 5:
Q: Fetch the last 5 transactions based on transaction_date.
A:
SELECT * 
FROM application.transactions 
ORDER BY transaction_date DESC 
LIMIT 5;
  ----------------------------------------------
5. Combination of SELECT, WHERE, DISTINCT, ORDER BY, and LIMIT
✅ Scenario 1:
Q: Find the top 5 distinct order_status values for orders placed in the last quarter, ordered by number of occurrences.
A:
SELECT order_status, COUNT(*) AS count
FROM application.orders 
WHERE order_date >= date_trunc('quarter', current_date) - interval '1 quarter'
GROUP BY order_status
ORDER BY count DESC
LIMIT 5;
  
✅ Scenario 2:
Q: List the top 5 most recent orders with total_amount > $500, showing only distinct order_ids.
A:
SELECT DISTINCT order_id, total_amount, order_date 
FROM application.orders 
WHERE total_amount > 500 
ORDER BY order_date DESC 
LIMIT 5;
  
✅ Scenario 3:
Q: Fetch distinct product_name where price > $100, ordered by price ascending. Display only 10.
A:
SELECT DISTINCT product_name 
FROM application.products 
WHERE price > 100 
ORDER BY price ASC 
LIMIT 10;
  
✅ Scenario 4:
Q: Retrieve the first 10 employees who joined in 2022, ordered by hire_date, showing distinct departments.
A:
SELECT DISTINCT department 
FROM application.employees 
WHERE EXTRACT(YEAR FROM hire_date) = 2022 
ORDER BY hire_date ASC 
LIMIT 10;
  
✅ Scenario 5:
Q: Fetch all distinct product categories where products were sold more than 500 times, ordered by total_sales. Limit 5.
A:
SELECT product_category, SUM(quantity_sold) AS total_sold
FROM application.sales 
GROUP BY product_category
HAVING SUM(quantity_sold) > 500
ORDER BY total_sold DESC 
LIMIT 5;
