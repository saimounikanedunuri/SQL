-- Part 1: Data Cleaning and Transformation

-- 1. Fixing Customer Full Names
SELECT 
  customer_id,
  TRIM(COALESCE(first_name, 'Unknown')) || ' ' || TRIM(COALESCE(last_name, 'Unknown')) AS full_name
FROM customers;

-- 2. Clean Messy Product Names (Remove Special Characters)
SELECT 
  product_id,
  REPLACE(REPLACE(TRIM(product_name), '|', ''), '  ', ' ') AS clean_product_name
FROM products;

-- 3. Replace NULL Values in Delivery Date
SELECT 
  order_id,
  COALESCE(delivery_date, DATE_ADD(order_date, INTERVAL 7 DAY)) AS final_delivery_date
FROM orders;

-- Part 2: Sales Summary Report

-- 4. Sales Summary by Customer
SELECT 
  c.customer_id,
  TRIM(c.first_name) || ' ' || TRIM(c.last_name) AS full_name,
  SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount IS NOT NULL
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_sales DESC;

-- 5. Top 5 Categories by Total Revenue
SELECT 
  cat.category_name,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 6. Monthly Revenue and Order Summary (Last 6 Months)
SELECT 
  DATE_TRUNC('month', order_date) AS month,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue
FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Part 3: Optional Advanced Challenges

-- 7. Tag Late Deliveries Using CASE WHEN
SELECT 
  order_id,
  CASE 
    WHEN delivery_date > DATE_ADD(order_date, INTERVAL 7 DAY) THEN 'Late'
    ELSE 'On-Time'
  END AS delivery_status
FROM orders;

-- 8. Handling Missing Shipping Addresses
SELECT 
  o.order_id,
  COALESCE(o.shipping_address, c.address) AS final_shipping_address
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 9. Aggregate Sales by Region, Treating NULL as ‘Others’
SELECT 
  COALESCE(region, 'Others') AS region,
  SUM(total_amount) AS total_sales
FROM orders
GROUP BY COALESCE(region, 'Others')
ORDER BY total_sales DESC;
