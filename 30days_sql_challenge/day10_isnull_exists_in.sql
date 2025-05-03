-- ✅ Day 10: IS NULL, EXISTS, IN – Real-Time SQL Scenarios

-- 🧪 Real-Time Scenario 1: Detect Customers with Incomplete Info
-- Use Case: Business wants to reach out to customers with missing profile data.
-- Goal: Identify customers who don’t have an email or phone number.
SELECT customer_id, first_name, last_name
FROM customers
WHERE email IS NULL OR phone IS NULL;


-- 🧪 Real-Time Scenario 2: Identify Unshipped Orders
-- Use Case: Track orders that haven’t been shipped yet.
-- Goal: Find all orders where delivery_date is still NULL.
SELECT order_id, customer_id, order_date
FROM orders
WHERE delivery_date IS NULL;


-- 🧪 Real-Time Scenario 3: Customers Who Have Never Placed an Order
-- Use Case: Marketing wants to run a campaign for inactive users.
-- Goal: Get customers not present in the orders table.
SELECT customer_id, first_name, last_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 
  FROM orders o 
  WHERE o.customer_id = c.customer_id
);


-- 🧪 Real-Time Scenario 4: High-Value Repeat Customers
-- Use Case: Loyalty program for repeat buyers.
-- Goal: Find customers who placed more than 1 order.
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Alternate using EXISTS:
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE EXISTS (
  SELECT 1 
  FROM orders o 
  WHERE o.customer_id = c.customer_id
  GROUP BY o.customer_id
  HAVING COUNT(*) > 1
);


-- 🧪 Real-Time Scenario 5: Get Orders for a Specific Product Set
-- Use Case: Analyze orders for key SKUs during campaign.
-- Goal: Find orders that include specific product IDs.
SELECT DISTINCT order_id
FROM order_items
WHERE product_id IN (101, 105, 112);


-- 🧪 Real-Time Scenario 6: Identify Out-of-Stock Products
-- Use Case: Inventory team wants to know which products need replenishing.
-- Goal: Find all products where stock is NULL or 0.
SELECT product_id, product_name
FROM products
WHERE stock IS NULL OR stock = 0;


-- 🧪 Real-Time Scenario 7: Customers Who Ordered from Specific Categories
-- Use Case: Category-wise customer segmentation.
-- Goal: Find customers who ordered from the ‘Electronics’ or ‘Clothing’ categories.
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name IN ('Electronics', 'Clothing');
