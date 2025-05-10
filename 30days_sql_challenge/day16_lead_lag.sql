-- ✅ Day 16: LEAD(), LAG() – Real-Time SQL Scenarios

-- 🧪 Scenario 1: Daily Sales Difference
-- Use Case: Find how today's sales differ from yesterday’s.
SELECT 
    order_date,
    SUM(order_amount) AS daily_sales,
    LAG(SUM(order_amount)) OVER (ORDER BY order_date) AS prev_day_sales,
    SUM(order_amount) - LAG(SUM(order_amount)) OVER (ORDER BY order_date) AS daily_diff
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- 🧪 Scenario 2: Detect Salary Changes for Employees
-- Use Case: Identify when an employee got a salary hike or cut.
SELECT 
    employee_id,
    salary,
    effective_date,
    LAG(salary) OVER (PARTITION BY employee_id ORDER BY effective_date) AS previous_salary,
    salary - LAG(salary) OVER (PARTITION BY employee_id ORDER BY effective_date) AS salary_diff
FROM employee_salary_history;

-- 🧪 Scenario 3: Compare Product Price Fluctuation
-- Use Case: Monitor how product price changes over time.
SELECT 
    product_id,
    price,
    change_date,
    LAG(price) OVER (PARTITION BY product_id ORDER BY change_date) AS prev_price,
    price - LAG(price) OVER (PARTITION BY product_id ORDER BY change_date) AS price_change
FROM product_price_history;

-- 🧪 Scenario 4: Detect Consecutive Login Days
-- Use Case: Track if a user logged in two days in a row.
SELECT 
    user_id,
    login_date,
    LAG(login_date) OVER (PARTITION BY user_id ORDER BY login_date) AS prev_login_date
FROM user_logins;

-- 🧪 Scenario 5: Identify Sales Growth/Drop in 2-Month Window
-- Use Case: Compare current month sales to previous month.
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    SUM(order_amount) AS monthly_sales,
    LAG(SUM(order_amount)) OVER (ORDER BY TO_CHAR(order_date, 'YYYY-MM')) AS prev_month_sales,
    SUM(order_amount) - LAG(SUM(order_amount)) OVER (ORDER BY TO_CHAR(order_date, 'YYYY-MM')) AS change
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY order_month;
