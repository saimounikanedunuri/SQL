-- ✅ Day 21: Real-Time Advanced Query Writing – Interview-Level Problems

-- 🧪 Scenario 1: Find Top 2 Customers by Total Spending in Each City
-- Use Case: Regional managers want to reward top spenders per city.

SELECT *
FROM (
    SELECT c.customer_id, c.customer_name, c.city, SUM(o.order_amount) AS total_spent,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.order_amount) DESC) AS city_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.city
) ranked
WHERE city_rank <= 2;

-- 🧪 Scenario 2: Detect Products Not Sold in Last 3 Months
-- Use Case: Inventory team wants to review stagnant products.

SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN (
    SELECT DISTINCT product_id
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '3 months'
) recent_sales ON p.product_id = recent_sales.product_id
WHERE recent_sales.product_id IS NULL;

-- 🧪 Scenario 3: Identify Customers Who Ordered in 3+ Consecutive Months
-- Use Case: Loyalty program targeting consistent buyers.

WITH customer_months AS (
    SELECT customer_id,
           DATE_TRUNC('month', order_date) AS order_month
    FROM orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
ranked AS (
    SELECT customer_id, order_month,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_month) AS rnk
    FROM customer_months
),
grouped AS (
    SELECT customer_id,
           DATE_PART('month', order_month) - rnk AS grp
    FROM ranked
),
consecutive_counts AS (
    SELECT customer_id, COUNT(*) AS consecutive_months
    FROM grouped
    GROUP BY customer_id, grp
)
SELECT customer_id
FROM consecutive_counts
WHERE consecutive_months >= 3;

-- 🧪 Scenario 4: Return Customer's First and Last Order Amount
-- Use Case: Analyze purchase behavior lifecycle.

WITH ranked_orders AS (
    SELECT customer_id, order_id, order_amount,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn_first,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn_last
    FROM orders
)
SELECT customer_id,
       MAX(CASE WHEN rn_first = 1 THEN order_amount END) AS first_order,
       MAX(CASE WHEN rn_last = 1 THEN order_amount END) AS last_order
FROM ranked_orders
GROUP BY customer_id;

-- 🧪 Scenario 5: Products With Increasing Sales Trend Over 3 Months
-- Use Case: Marketing wants to promote consistently growing products.

WITH monthly_sales AS (
    SELECT product_id,
           TO_CHAR(order_date, 'YYYY-MM') AS sale_month,
           SUM(quantity) AS total_quantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY product_id, TO_CHAR(order_date, 'YYYY-MM')
),
ranked_sales AS (
    SELECT product_id, sale_month, total_quantity,
           ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY sale_month) AS rn
    FROM monthly_sales
),
sales_windowed AS (
    SELECT a.product_id, a.total_quantity AS qty1, b.total_quantity AS qty2, c.total_quantity AS qty3
    FROM ranked_sales a
    JOIN ranked_sales b ON a.product_id = b.product_id AND a.rn + 1 = b.rn
    JOIN ranked_sales c ON b.product_id = c.product_id AND b.rn + 1 = c.rn
)
SELECT DISTINCT product_id
FROM sales_windowed
WHERE qty1 < qty2 AND qty2 < qty3;

-- 🧪 Scenario 6: Highest Revenue-Generating Product per Category This Quarter
-- Use Case: Dashboard display for product performance.

WITH quarterly_sales AS (
    SELECT p.product_id, p.product_name, c.category_name,
           SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE DATE_TRUNC('quarter', o.order_date) = DATE_TRUNC('quarter', CURRENT_DATE)
    GROUP BY p.product_id, p.product_name, c.category_name
),
ranked_products AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY total_revenue DESC) AS rn
    FROM quarterly_sales
)
SELECT product_id, product_name, category_name, total_revenue
FROM ranked_products
WHERE rn = 1;
