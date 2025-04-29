
-- ✅ Real-Time SQL Questions – Day 6: CASE WHEN, Conditional Aggregation

-- 🧠 Tagging and Categorization with CASE WHEN

-- 1. Tag each customer as 'High Value', 'Medium Value', or 'Low Value' based on number of orders
SELECT customer_id,
       COUNT(order_id) AS total_orders,
       CASE 
           WHEN COUNT(order_id) > 5 THEN 'High Value'
           WHEN COUNT(order_id) BETWEEN 3 AND 5 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_value_tag
FROM orders
GROUP BY customer_id;

-- 2. Tag orders as 'Old' or 'Recent'
SELECT order_id, customer_id, order_date,
       CASE 
           WHEN order_date < '2023-01-01' THEN 'Old'
           ELSE 'Recent'
       END AS order_tag
FROM orders;

-- 3. Classify customers into age groups
SELECT name, age,
       CASE 
           WHEN age < 20 THEN 'Teen'
           WHEN age BETWEEN 20 AND 40 THEN 'Adult'
           ELSE 'Senior'
       END AS age_group
FROM customers;

-- 4. Tag each order as 'First Order' or 'Repeat Order'
SELECT o.order_id, o.customer_id,
       CASE 
           WHEN o.order_date = MIN(o.order_date) OVER (PARTITION BY o.customer_id) THEN 'First Order'
           ELSE 'Repeat Order'
       END AS order_type
FROM orders o;

-- 5. Add a column is_frequent_buyer (1 if >5 orders)
SELECT customer_id,
       CASE 
           WHEN COUNT(order_id) > 5 THEN 1
           ELSE 0
       END AS is_frequent_buyer
FROM orders
GROUP BY customer_id;

-- 📊 Conditional Aggregation

-- 6. Show summary report with customer_id, total_orders, orders_in_2023, orders_in_2024
SELECT customer_id,
       COUNT(*) AS total_orders,
       COUNT(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN 1 END) AS orders_in_2023,
       COUNT(CASE WHEN EXTRACT(YEAR FROM order_date) = 2024 THEN 1 END) AS orders_in_2024
FROM orders
GROUP BY customer_id;

-- 7. Count customers by location and those above 30 years old
SELECT location,
       COUNT(*) AS total_customers,
       COUNT(CASE WHEN age > 30 THEN 1 END) AS above_30_customers
FROM customers
GROUP BY location;

-- 8. Show number of orders by category types
SELECT 
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN category = 'Electronics' THEN 1 END) AS category_electronics_orders,
    COUNT(CASE WHEN category = 'Clothing' THEN 1 END) AS category_clothing_orders,
    COUNT(CASE WHEN category NOT IN ('Electronics', 'Clothing') THEN 1 END) AS other_orders
FROM orders;

-- 9. Show number of prepaid and COD orders
SELECT 
    COUNT(CASE WHEN payment_type = 'Prepaid' THEN 1 END) AS prepaid_orders,
    COUNT(CASE WHEN payment_type = 'COD' THEN 1 END) AS cod_orders
FROM orders;

-- 10. Spend aggregation by order value
SELECT customer_id,
       SUM(order_amount) AS total_spend,
       SUM(CASE WHEN order_amount > 1000 THEN order_amount ELSE 0 END) AS spend_above_1000,
       SUM(CASE WHEN order_amount <= 1000 THEN order_amount ELSE 0 END) AS spend_1000_or_less
FROM orders
GROUP BY customer_id;

-- 📦 Business-Like Use Cases

-- 11. Loyalty report with tiers
SELECT c.name, COUNT(o.order_id) AS total_orders,
       CASE 
           WHEN COUNT(o.order_id) > 10 THEN 'Platinum'
           WHEN COUNT(o.order_id) BETWEEN 5 AND 10 THEN 'Gold'
           ELSE 'Silver'
       END AS loyalty_tier
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- 12. Monthly summary for delayed/on-time orders
SELECT DATE_TRUNC('month', order_date) AS month,
       COUNT(CASE WHEN delivery_date > expected_date THEN 1 END) AS delayed_orders,
       COUNT(CASE WHEN delivery_date <= expected_date THEN 1 END) AS ontime_orders
FROM orders
GROUP BY month;

-- 13. Count of first-time buyers this month
SELECT COUNT(DISTINCT customer_id) AS first_time_buyers
FROM (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
) first_orders
WHERE DATE_TRUNC('month', first_order_date) = DATE_TRUNC('month', CURRENT_DATE);

-- 14. Customers from each location with no orders
SELECT c.location, COUNT(*) AS inactive_customers
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
GROUP BY c.location;

-- 15. Gender-based spend summary
SELECT 
    SUM(CASE WHEN gender = 'Male' THEN order_amount ELSE 0 END) AS Male_total_spend,
    SUM(CASE WHEN gender = 'Female' THEN order_amount ELSE 0 END) AS Female_total_spend,
    SUM(CASE WHEN gender NOT IN ('Male', 'Female') THEN order_amount ELSE 0 END) AS Other_total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
