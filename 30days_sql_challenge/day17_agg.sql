-- ✅ Day 17: SUM() OVER(), AVG() OVER(), Running Totals – Real-Time SQL Scenarios

-- 🧪 Scenario 1: Daily Cumulative Sales
-- Use Case: Show running total of sales day-by-day for business trend tracking.
SELECT 
    order_date,
    SUM(order_amount) AS daily_sales,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS running_total
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- 🧪 Scenario 2: Monthly Cumulative Sales per Region
-- Use Case: Track how each region is performing month over month.
SELECT 
    region,
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    SUM(order_amount) AS monthly_sales,
    SUM(SUM(order_amount)) OVER (PARTITION BY region ORDER BY TO_CHAR(order_date, 'YYYY-MM')) AS cumulative_sales
FROM orders
GROUP BY region, TO_CHAR(order_date, 'YYYY-MM')
ORDER BY region, order_month;

-- 🧪 Scenario 3: Employee Salary Trend – Cumulative & Average
-- Use Case: HR wants to analyze total and average salary growth over time.
SELECT 
    employee_id,
    effective_date,
    salary,
    SUM(salary) OVER (PARTITION BY employee_id ORDER BY effective_date) AS salary_growth,
    AVG(salary) OVER (PARTITION BY employee_id ORDER BY effective_date) AS avg_salary_so_far
FROM employee_salary_history;

-- 🧪 Scenario 4: Cumulative Product Sales by Category
-- Use Case: Track total units sold in each category cumulatively.
SELECT 
    c.category_name,
    p.product_name,
    oi.order_date,
    oi.quantity,
    SUM(oi.quantity) OVER (PARTITION BY c.category_name ORDER BY oi.order_date) AS cumulative_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id;

-- 🧪 Scenario 5: Rolling Average Order Amount (Last 3 Days)
-- Use Case: Monitor recent performance trends using a moving window.
SELECT 
    order_id,
    order_date,
    order_amount,
    AVG(order_amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_3days
FROM orders;
