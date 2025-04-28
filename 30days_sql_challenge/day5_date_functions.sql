-- ✅ Real-Time Scenario-Based SQL Interview Questions (5.6 Yrs Experience)

-- 1. Get monthly sales count
SELECT DATE_TRUNC('month', order_date) AS month, COUNT(order_id) AS total_orders
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY month
ORDER BY month;

-- 2. Year-wise active customers
SELECT EXTRACT(YEAR FROM signup_date) AS year, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY year
ORDER BY year;

-- 3. Monthly new customers trend
SELECT DATE_TRUNC('month', signup_date) AS month, COUNT(customer_id) AS new_customers
FROM customers
WHERE signup_date >= '2022-01-01'
GROUP BY month
ORDER BY month;

-- 4. Order volume for a specific quarter (Q2 2023)
SELECT COUNT(order_id) AS total_orders, SUM(order_amount) AS total_revenue
FROM orders
WHERE order_date BETWEEN '2023-04-01' AND '2023-06-30';

-- 5. Filter customers by signup range
SELECT *
FROM customers
WHERE signup_date BETWEEN '2022-01-01' AND '2022-12-31';

-- 6. Difference between order and delivery dates
SELECT order_id, DATEDIFF(day, order_date, delivery_date) AS days_to_deliver
FROM orders;

-- 7. Average delivery time per month (2023)
SELECT DATE_TRUNC('month', order_date) AS month, 
       AVG(DATEDIFF(day, order_date, delivery_date)) AS avg_delivery_days
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY month
ORDER BY month;

-- 8. Identify late deliveries (>7 days)
SELECT order_id, order_date, delivery_date, DATEDIFF(day, order_date, delivery_date) AS delivery_days
FROM orders
WHERE DATEDIFF(day, order_date, delivery_date) > 7;

-- 9. Earliest and latest order date per category
SELECT category_id, 
       MIN(order_date) AS first_order_date, 
       MAX(order_date) AS last_order_date
FROM orders
GROUP BY category_id;

-- 10. Monthly sales trend for a product ('Soap 200ml')
SELECT DATE_TRUNC('month', order_date) AS month, 
       SUM(order_amount) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE p.product_name = 'Soap 200ml'
GROUP BY month
ORDER BY month;

-- 11. Orders in the current week (Monday to today)
SELECT *
FROM orders
WHERE order_date >= DATE_TRUNC('week', CURRENT_DATE)
  AND order_date <= CURRENT_DATE;

-- 12. Top 3 months with highest sales
SELECT DATE_TRUNC('month', order_date) AS month, SUM(order_amount) AS total_sales
FROM orders
GROUP BY month
ORDER BY total_sales DESC
LIMIT 3;

-- 13. Customer inactivity period
SELECT customer_id, 
       MAX(order_date) AS last_order_date, 
       DATEDIFF(day, MAX(order_date), CURRENT_DATE) AS days_since_last_order
FROM orders
GROUP BY customer_id
ORDER BY days_since_last_order DESC;

-- 14. Date-wise category revenue
SELECT DATE_TRUNC('day', order_date) AS order_day, 
       category_id, 
       SUM(order_amount) AS total_revenue
FROM orders
GROUP BY order_day, category_id
ORDER BY order_day, category_id;

-- 15. Monthly revenue growth
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(order_amount) AS revenue
    FROM orders
    GROUP BY month
)
SELECT month, 
       revenue,
       LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
       (revenue - LAG(revenue) OVER (ORDER BY month)) AS revenue_growth
FROM monthly_revenue
ORDER BY month;
