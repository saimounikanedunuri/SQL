-- 🔄 INNER JOINs

-- 1. Find all customers who have placed at least one order
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- 2. Retrieve order details along with customer names for all completed orders
SELECT o.order_id, o.order_date, c.first_name || ' ' || c.last_name AS full_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Completed';

-- 3. Show each order’s product details
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

-- 4. Get a list of employees and their assigned departments
SELECT e.employee_id, e.name AS employee_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;


-- 👈 LEFT JOINs

-- 5. List all customers, even if they haven’t placed any orders
SELECT c.customer_id, c.first_name, c.last_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 6. Show all products, along with their category names (include products without categories)
SELECT p.product_id, p.product_name, c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

-- 7. Get a list of employees and their manager names (show employees without managers too)
SELECT e.employee_id, e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 8. Find all orders and include any available delivery feedback, if present
SELECT o.order_id, o.order_date, f.feedback
FROM orders o
LEFT JOIN delivery_feedback f ON o.order_id = f.order_id;


-- 👉 RIGHT JOINs

-- 9. List all orders along with customer info, even if the customer data is missing
SELECT o.order_id, o.order_date, c.first_name, c.last_name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- 10. Show all categories and the products under them, including uncategorized products
SELECT c.category_name, p.product_name
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id;


-- 🔁 FULL OUTER JOINs

-- 11. Show a combined list of all customers and all orders, including those with no matches
SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- 12. List all products and categories — include products without categories and categories without products
SELECT p.product_name, c.category_name
FROM products p
FULL OUTER JOIN categories c ON p.category_id = c.category_id;

-- 13. Combine employee and department data, even if an employee is not assigned or a department has no employees
SELECT e.name AS employee_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;


-- 🔍 Real-Time Join Use-Cases

-- 14. Which products have never been ordered?
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 15. Which customers have never placed an order?
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 16. Which orders have no matching customer (e.g., due to data inconsistency)?
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 17. Which employees are not assigned a manager?
SELECT employee_id, name
FROM employees
WHERE manager_id IS NULL;

-- 18. Which categories currently have no products?
SELECT c.category_id, c.category_name
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.product_id IS NULL;

-- 19. Show customers who placed orders along with the total amount spent
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 20. List each order along with customer name and product names
SELECT o.order_id, c.first_name || ' ' || c.last_name AS full_name, p.product_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
