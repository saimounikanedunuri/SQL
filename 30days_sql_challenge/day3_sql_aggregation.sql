-- 🧾 Basic to Intermediate Group By Use-Cases

-- 1. Total number of orders per customer
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- 2. Total revenue by each customer
SELECT customer_id, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY customer_id;

-- 3. Average price per category
SELECT category_id, AVG(price) AS avg_price
FROM products
GROUP BY category_id;

-- 4. Product-wise sales count
SELECT product_id, COUNT(*) AS times_sold
FROM orders
GROUP BY product_id;

-- 5. Max and Min order amount per customer
SELECT customer_id, MAX(total_amount) AS max_order, MIN(total_amount) AS min_order
FROM orders
GROUP BY customer_id;

-- 📊 Customer & Sales Summary Problems

-- 6. Customer Order Summary
SELECT customer_id,
       COUNT(*) AS total_orders,
       SUM(total_amount) AS total_revenue,
       AVG(total_amount) AS avg_order_value
FROM orders
GROUP BY customer_id;

-- 7. Monthly sales summary
SELECT DATE_TRUNC('month', order_date) AS order_month,
       SUM(total_amount) AS total_sales,
       COUNT(*) AS num_orders,
       AVG(total_amount) AS avg_sales_per_order
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 8. Product performance
SELECT o.product_id,
       COUNT(*) AS total_units_sold,
       SUM(o.total_amount) AS total_revenue
FROM orders o
GROUP BY o.product_id;

-- 9. Customers with more than 5 orders
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- 10. Customers with avg order > ₹5000
SELECT customer_id, AVG(total_amount) AS avg_order_value
FROM orders
GROUP BY customer_id
HAVING AVG(total_amount) > 5000;

-- 🔎 Advanced Use-Cases With HAVING Clause

-- 11. Products ordered more than 10 times
SELECT product_id, COUNT(*) AS order_count
FROM orders
GROUP BY product_id
HAVING COUNT(*) > 10;

-- 12. Categories with revenue > ₹50,000
SELECT p.category_id, SUM(o.total_amount) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category_id
HAVING SUM(o.total_amount) > 50000;

-- 13. Customers with >3 orders and avg > ₹3000
SELECT customer_id, COUNT(*) AS order_count, AVG(total_amount) AS avg_value
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 3 AND AVG(total_amount) > 3000;

-- 14. Months where total sales > ₹100,000
SELECT DATE_TRUNC('month', order_date) AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY month
HAVING SUM(total_amount) > 100000;

-- 15. Customers who placed at least 1 order in last 3 months (advanced)
-- This is a conceptual example. Adjust based on your actual data:
SELECT customer_id
FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_TRUNC('month', order_date)) = 3;

-- 🧠 Real-Time Project Scenarios

-- 16. Sales per region
SELECT c.region,
       SUM(o.total_amount) AS total_sales,
       COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region;

-- 17. Top 3 customers per region by revenue
SELECT * FROM (
  SELECT c.region, o.customer_id,
         SUM(o.total_amount) AS total_revenue,
         RANK() OVER (PARTITION BY c.region ORDER BY SUM(o.total_amount) DESC) AS rank
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  GROUP BY c.region, o.customer_id
) sub
WHERE rank <= 3;

-- 18. Product performance with filter
SELECT o.product_id,
       COUNT(*) AS total_units,
       AVG(o.total_amount) AS avg_order_value,
       SUM(o.total_amount) AS total_revenue
FROM orders o
GROUP BY o.product_id
HAVING SUM(o.total_amount) > 10000;

-- 19. Days with > 50 orders and avg transaction < ₹1000
SELECT order_date, COUNT(*) AS order_count, AVG(total_amount) AS avg_transaction
FROM orders
GROUP BY order_date
HAVING COUNT(*) > 50 AND AVG(total_amount) < 1000;

-- 20. Customer health score
SELECT customer_id,
       SUM(total_amount) AS total_revenue,
       CASE
           WHEN SUM(total_amount) > 100000 THEN 'High Value'
           WHEN SUM(total_amount) BETWEEN 50000 AND 100000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS health_score
FROM orders
GROUP BY customer_id;
