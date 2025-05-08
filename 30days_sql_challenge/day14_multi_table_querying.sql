-- 📅 Day 14 – Real-Time SQL Project: Multi-Table Querying Session

-- 1. Customers who made a purchase with total amount > ₹5000 in a single order
SELECT c.customer_id, c.customer_name, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 5000;

-- 2. Products that have never been ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.product_id IS NULL;

-- 3. Employees with the maximum salary per department (ROW_NUMBER + Subquery)
SELECT *
FROM (
    SELECT e.employee_id, e.employee_name, e.department_id, e.salary,
           ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rn
    FROM employees e
) ranked
WHERE rn = 1;

-- 4. List all customers and any orders placed, including those who haven’t placed any
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. Get a list of repeat customers (placed more than 1 order)
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 6. Products that belong to ‘Active’ categories only (Correlated Subquery)
SELECT p.product_id, p.product_name
FROM products p
WHERE p.category_id IN (
    SELECT category_id
    FROM categories
    WHERE status = 'Active'
);

-- 7. List employees and their managers (Self Join)
SELECT e.employee_name AS employee, m.employee_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 8. Compare customers who placed orders vs who never did (Anti-Join + UNION)
-- Customers who placed orders
SELECT DISTINCT c.customer_id, c.customer_name, 'Placed Order' AS status
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id

UNION

-- Customers who never placed any order
SELECT c.customer_id, c.customer_name, 'No Order' AS status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 9. Latest order placed by each customer (Scalar Subquery)
SELECT c.customer_id, c.customer_name,
       (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) AS latest_order
FROM customers c;

-- 10. Get product names sold in each order along with customer name (Multi-Join)
SELECT o.order_id, c.customer_name, p.product_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

-- BONUS: Products that are in stock but never ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.product_id IS NULL AND p.stock_quantity > 0;
