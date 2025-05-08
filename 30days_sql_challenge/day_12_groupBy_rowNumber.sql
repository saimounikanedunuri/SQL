-- group by real time scenarios
-- 1. Total number of orders per customer
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- 2. Total quantity sold per product
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM order_items
GROUP BY product_id;

-- 3. Total revenue generated per product
SELECT product_id, SUM(quantity * unit_price) AS revenue
FROM order_items
GROUP BY product_id;

-- 4. Number of employees per department
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- 5. Total number of orders per order status
SELECT status, COUNT(*) AS status_count
FROM orders
GROUP BY status;

-- 6. Total amount spent per customer
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- 7. Monthly sales revenue
SELECT strftime('%Y-%m', order_date) AS month, SUM(total_amount) AS revenue
FROM orders
GROUP BY strftime('%Y-%m', order_date);

-- 8. Product count per category
SELECT category_id, COUNT(*) AS product_count
FROM products
GROUP BY category_id;

-- row_number real time scenarios
-- 9. Get the first order placed by each customer
SELECT *
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
  FROM orders
) t
WHERE rn = 1;

-- 10. Rank products by total quantity sold (most sold = 1)
SELECT *
FROM (
  SELECT product_id, SUM(quantity) AS total_sold,
         ROW_NUMBER() OVER (ORDER BY SUM(quantity) DESC) AS rn
  FROM order_items
  GROUP BY product_id
) t;

-- 11. Top 2 most expensive products per category
SELECT *
FROM (
  SELECT product_id, category_id, product_name, price,
         ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
  FROM products
) t
WHERE rn <= 2;

-- 12. Latest order per customer
SELECT *
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
  FROM orders
) t
WHERE rn = 1;

-- 13. Highest earning employee in each department
SELECT *
FROM (
  SELECT employee_id, name, department_id, salary,
         ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
  FROM employees
) t
WHERE rn = 1;
