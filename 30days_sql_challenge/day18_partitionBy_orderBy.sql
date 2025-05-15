-- ✅ Day 18: PARTITION BY, ORDER BY in Window Functions – Real-Time SQL Scenarios

-- 🧪 Scenario 1: Rank Employees by Salary Within Each Department
-- Use Case: HR wants to identify top earners department-wise.
SELECT 
    employee_id,
    first_name,
    department_id,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank_in_dept
FROM employees;

-- 🧪 Scenario 2: Track Product Sales Trend by Region
-- Use Case: Business wants to observe product performance trends region-wise over time.
SELECT 
    region,
    product_id,
    order_date,
    SUM(order_amount) AS daily_sales,
    SUM(SUM(order_amount)) OVER (PARTITION BY region, product_id ORDER BY order_date) AS cumulative_sales
FROM orders
GROUP BY region, product_id, order_date;

-- 🧪 Scenario 3: Get First and Last Purchase per Customer
-- Use Case: Marketing team wants to track customer lifecycle.
SELECT 
    customer_id,
    order_id,
    order_date,
    FIRST_VALUE(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_purchase_date,
    LAST_VALUE(order_date) OVER (PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_purchase_date
FROM orders;

-- 🧪 Scenario 4: Identify Top Performer per Project
-- Use Case: Project managers want to highlight the top contributors in each project.
SELECT 
    project_id,
    employee_id,
    contribution_score,
    DENSE_RANK() OVER (PARTITION BY project_id ORDER BY contribution_score DESC) AS performance_rank
FROM project_contributions;

-- 🧪 Scenario 5: Average Rating Over Time per Product
-- Use Case: Track average rating change for each product over months.
SELECT 
    product_id,
    review_date,
    rating,
    AVG(rating) OVER (PARTITION BY product_id ORDER BY review_date) AS running_avg_rating
FROM product_reviews;

-- 🧪 Scenario 6: Running Total of Orders per Customer
-- Use Case: Track how order value accumulates per customer.
SELECT 
    customer_id,
    order_id,
    order_date,
    order_amount,
    SUM(order_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_spend
FROM orders;
