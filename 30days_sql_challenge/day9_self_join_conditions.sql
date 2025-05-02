# 📅 Day 9 – SQL SELF JOIN & Conditional Joins

Real-time business case scenarios using common datasets (`customers`, `orders`, `products`, `categories`, `employees`, `departments`, `transactions`, `order_items`)

---

## 🔁 Combined SQL Queries

```sql
-- 1. Employees reporting to the same manager
SELECT e1.employee_id AS emp1, e2.employee_id AS emp2, e1.manager_id
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id AND e1.employee_id <> e2.employee_id;

-- 2. Customers in the same city
SELECT c1.customer_id, c2.customer_id, c1.city
FROM customers c1
JOIN customers c2 ON c1.city = c2.city AND c1.customer_id <> c2.customer_id;

-- 3. Products in the same category
SELECT p1.product_id, p2.product_id, p1.category_id
FROM products p1
JOIN products p2 ON p1.category_id = p2.category_id AND p1.product_id <> p2.product_id;

-- 4. Orders by same customer on same date
SELECT o1.order_id, o2.order_id, o1.customer_id, o1.order_date
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.order_date = o2.order_date AND o1.order_id <> o2.order_id;

-- 5. Employees with same job title
SELECT e1.employee_id, e2.employee_id, e1.job_title
FROM employees e1
JOIN employees e2 ON e1.job_title = e2.job_title AND e1.employee_id <> e2.employee_id;

-- 6. Orders > ₹5000 with customer names
SELECT o.order_id, o.total_amount, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 5000;

-- 7. Active category products
SELECT p.product_id, p.product_name, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.status = 'Active';

-- 8. Employees in Mumbai departments
SELECT e.employee_id, e.name, d.department_name, d.location
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'Mumbai';

-- 9. Orders with products > ₹1000
SELECT DISTINCT o.order_id, p.product_name, p.price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.price > 1000;

-- 10. Customers with >2 orders
SELECT o.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id
HAVING COUNT(o.order_id) > 2;

-- 11. Senior-Junior employee pairs
SELECT e1.employee_id AS senior, e2.employee_id AS junior, e1.hire_date, e2.hire_date
FROM employees e1
JOIN employees e2 ON e1.hire_date < e2.hire_date AND e1.employee_id <> e2.employee_id;

-- 12. Same-day multiple orders by same customer
SELECT o1.order_id AS order1, o2.order_id AS order2, o1.customer_id, o1.order_date
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.order_date = o2.order_date AND o1.order_id <> o2.order_id;

-- 13. Similar product names
SELECT p1.product_name, p2.product_name
FROM products p1
JOIN products p2 ON p1.product_name LIKE '%' || SUBSTR(p2.product_name, 1, INSTR(p2.product_name, ' ') - 1) || '%'
AND p1.product_id <> p2.product_id;

-- 14. Duplicate transactions (same amount/date, different IDs)
SELECT t1.transaction_id, t2.transaction_id, t1.amount, t1.transaction_date
FROM transactions t1
JOIN transactions t2 ON t1.amount = t2.amount AND t1.transaction_date = t2.transaction_date AND t1.transaction_id <> t2.transaction_id;
