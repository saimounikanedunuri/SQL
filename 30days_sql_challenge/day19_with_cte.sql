-- ✅ Day 19: WITH (CTE), Recursive CTE – Step-Wise Queries and Real-Time Scenarios

-- 🧪 Scenario 1: Break Complex Query into Steps Using CTE
-- Use Case: Finance wants total orders and average amount per customer.
WITH customer_orders AS (
    SELECT customer_id, COUNT(*) AS total_orders, AVG(order_amount) AS avg_order_amount
    FROM orders
    GROUP BY customer_id
)
SELECT * FROM customer_orders;

-- 🧪 Scenario 2: Get Top 3 Products by Sales in Each Category
-- Use Case: E-commerce team wants to list bestsellers category-wise.
WITH product_sales AS (
    SELECT p.product_id, p.product_name, c.category_name, SUM(oi.quantity) AS total_quantity,
           RANK() OVER (PARTITION BY c.category_name ORDER BY SUM(oi.quantity) DESC) AS rnk
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY p.product_id, p.product_name, c.category_name
)
SELECT * FROM product_sales WHERE rnk <= 3;

-- 🧪 Scenario 3: Recursive CTE to Generate Date Series
-- Use Case: Generate calendar dates for missing data analysis.
WITH RECURSIVE date_series AS (
    SELECT DATE('2024-01-01') AS dt
    UNION ALL
    SELECT dt + INTERVAL '1 day'
    FROM date_series
    WHERE dt + INTERVAL '1 day' <= DATE('2024-01-10')
)
SELECT * FROM date_series;

-- 🧪 Scenario 4: Find Employee Hierarchy
-- Use Case: HR wants to view reporting structure in the org.
WITH RECURSIVE emp_hierarchy AS (
    SELECT employee_id, manager_id, first_name, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.manager_id, e.first_name, eh.level + 1
    FROM employees e
    JOIN emp_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM emp_hierarchy ORDER BY level;

-- 🧪 Scenario 5: Recursive CTE to Calculate Factorial (Fun/Interview Use Case)
-- Use Case: Showcase recursion logic in SQL.
WITH RECURSIVE factorial(n, fact) AS (
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, (n + 1) * fact
    FROM factorial
    WHERE n < 5
)
SELECT * FROM factorial;

-- 🧪 Scenario 6: Track Sales Growth over Months Step-by-Step
-- Use Case: Business wants to calculate month-over-month sales change.
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS sales_month, SUM(order_amount) AS total_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
sales_with_lag AS (
    SELECT sales_month, total_sales,
           LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales,
           total_sales - LAG(total_sales) OVER (ORDER BY sales_month) AS sales_growth
    FROM monthly_sales
)
SELECT * FROM sales_with_lag;
