-- ✅ Day 20: Complex CASE WHEN + CTE + Aggregation – Build Categorization Logic

-- 🧪 Scenario 1: Categorize Customers Based on Purchase Amount
-- Use Case: Marketing team wants to segment customers into tiers.

WITH customer_total AS (
    SELECT customer_id, SUM(order_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
customer_segmented AS (
    SELECT customer_id, total_spent,
           CASE 
               WHEN total_spent >= 10000 THEN 'Platinum'
               WHEN total_spent >= 5000 THEN 'Gold'
               WHEN total_spent >= 1000 THEN 'Silver'
               ELSE 'Bronze'
           END AS customer_tier
    FROM customer_total
)
SELECT * FROM customer_segmented ORDER BY total_spent DESC;

-- 🧪 Scenario 2: Product Stock Status Classification
-- Use Case: Inventory team wants to flag stock levels for alerts.

SELECT product_id, product_name, stock_quantity,
       CASE 
           WHEN stock_quantity = 0 THEN 'Out of Stock'
           WHEN stock_quantity <= 20 THEN 'Low Stock'
           WHEN stock_quantity <= 100 THEN 'Medium Stock'
           ELSE 'High Stock'
       END AS stock_status
FROM products;

-- 🧪 Scenario 3: Employee Performance Band Based on KPI Score
-- Use Case: HR wants to group employees for annual appraisal.

WITH emp_kpi AS (
    SELECT employee_id, AVG(kpi_score) AS avg_score
    FROM employee_kpi
    GROUP BY employee_id
)
SELECT employee_id, avg_score,
       CASE
           WHEN avg_score >= 90 THEN 'Outstanding'
           WHEN avg_score >= 75 THEN 'Exceeds Expectations'
           WHEN avg_score >= 60 THEN 'Meets Expectations'
           ELSE 'Needs Improvement'
       END AS performance_band
FROM emp_kpi;

-- 🧪 Scenario 4: Categorize Orders by Size Based on Amount
-- Use Case: Analytics team wants to bucket order sizes for study.

SELECT order_id, order_amount,
       CASE 
           WHEN order_amount < 50 THEN 'Small'
           WHEN order_amount BETWEEN 50 AND 200 THEN 'Medium'
           ELSE 'Large'
       END AS order_size
FROM orders;

-- 🧪 Scenario 5: Monthly Revenue Bands for Visualization
-- Use Case: BI team needs categorized monthly revenue for charts.

WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', order_date) AS revenue_month,
           SUM(order_amount) AS total_revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT revenue_month, total_revenue,
       CASE
           WHEN total_revenue >= 100000 THEN 'Very High'
           WHEN total_revenue >= 50000 THEN 'High'
           WHEN total_revenue >= 20000 THEN 'Moderate'
           ELSE 'Low'
       END AS revenue_band
FROM monthly_revenue
ORDER BY revenue_month;

-- 🧪 Scenario 6: Flag Inactive Customers
-- Use Case: CRM team wants to identify customers who haven’t ordered in 6+ months.

WITH last_order_dates AS (
    SELECT customer_id, MAX(order_date) AS last_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, last_order_date,
       CASE 
           WHEN last_order_date < CURRENT_DATE - INTERVAL '6 months' THEN 'Inactive'
           ELSE 'Active'
       END AS customer_status
FROM last_order_dates
ORDER BY last_order_date;
