-- 🔹 Scalar Subqueries
-- 1. Get the employee with the highest salary
SELECT employee_id, name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- 2. Find the most expensive product
SELECT product_id, product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- 3. List customers who placed the latest order
SELECT customer_id, customer_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    ORDER BY order_date DESC
    LIMIT 1
);

-- 4. Show product(s) with price higher than the average product price
SELECT product_id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

--🔸 Correlated Subqueries
-- 5. List all customers who placed more than one order
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE (
    SELECT COUNT(*) 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
) > 1;

-- 6. Show products that are more expensive than all other products in their category
SELECT product_id, product_name, category_id, price
FROM products p1
WHERE price > ALL (
    SELECT price 
    FROM products p2 
    WHERE p2.category_id = p1.category_id AND p2.product_id <> p1.product_id
);

-- 7. Show employees who earn more than the average salary of their department
SELECT e.employee_id, e.name, e.salary, e.department_id
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- 🔻 Nested Subqueries
-- 8. Show categories that contain products priced above ₹5000
SELECT *
FROM categories
WHERE category_id IN (
    SELECT category_id
    FROM products
    WHERE price > 5000
);

-- 9. Find names of customers who ordered 'Laptop' products
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE oi.product_id IN (
        SELECT product_id FROM products WHERE product_name LIKE '%Laptop%'
    )
);

-- 10. Show employees who joined before the earliest hire date in the ‘HR’ department
SELECT *
FROM employees
WHERE hire_date < (
    SELECT MIN(hire_date)
    FROM employees
    WHERE department_id = (
        SELECT department_id FROM departments WHERE department_name = 'HR'
    )
);

