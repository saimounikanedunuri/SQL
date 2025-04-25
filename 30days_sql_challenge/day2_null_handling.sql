-- ✅ IS NULL / IS NOT NULL
-- 1. Customers with missing email
SELECT * FROM customers WHERE email IS NULL;

-- 2. Orders with no delivery_date (Pending shipments)
SELECT * FROM orders WHERE delivery_date IS NULL;

-- 3. Products with no category_id
SELECT * FROM products WHERE category_id IS NULL;

-- 4. Employees with no manager_id
SELECT * FROM employees WHERE manager_id IS NULL;

-- 5. Transactions with non-null notes
SELECT * FROM transactions WHERE transaction_notes IS NOT NULL;

-- 🧠 COALESCE
-- 6. Orders with delivery_date fallback to estimated_delivery_date
SELECT order_id, COALESCE(delivery_date, estimated_delivery_date) AS final_delivery_date FROM orders;

-- 7. Products label from product_name, product_code, or default
SELECT product_id, COALESCE(product_name, product_code, 'Unnamed Product') AS product_label FROM products;

-- 8. Full name with fallback for nulls
SELECT id, COALESCE(first_name, 'Unknown') || ' ' || COALESCE(last_name, 'Unknown') AS full_name FROM customers;

-- 9. Employees bonus with default 0
SELECT employee_id, COALESCE(bonus, 0) AS bonus_amount FROM employees;

-- 10. Sales region fallback to 'Unknown Region'
SELECT sale_id, COALESCE(region, 'Unknown Region') AS region_display FROM sales;

-- 🛠️ ISNULL / IFNULL / NVL Examples (Database specific)
-- SQL Server: ISNULL
SELECT product_id, ISNULL(discount, 0) AS discount FROM products;

-- Orders revenue report with null-safe total_amount
SELECT SUM(ISNULL(total_amount, 0)) AS total_revenue FROM orders;

-- Categories with default description
SELECT category_id, ISNULL(description, 'No Description Available') AS description FROM categories;

-- Customers with fallback phone_number
SELECT id, ISNULL(phone_number, 'Not Provided') AS phone_number FROM customers;

-- Employees last_login_date fallback
SELECT employee_id, ISNULL(last_login_date, '2000-01-01') AS last_login_date FROM employees;

-- 🔄 Fill Missing Values
-- 16. Orders with missing shipping_address filled from customer address
SELECT o.order_id, COALESCE(o.shipping_address, c.address) AS final_shipping_address
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- 17. Products discount replaced with category-wise average
SELECT p.product_id, p.category_id,
       COALESCE(p.discount, avg_discount.avg_cat_discount) AS filled_discount
FROM products p
LEFT JOIN (
    SELECT category_id, AVG(discount) AS avg_cat_discount
    FROM products
    WHERE discount IS NOT NULL
    GROUP BY category_id
) avg_discount
ON p.category_id = avg_discount.category_id;

-- 18. Sales per region with missing regions treated as 'Others'
SELECT COALESCE(region, 'Others') AS region, SUM(amount) AS total_sales
FROM sales
GROUP BY COALESCE(region, 'Others');

-- 19. Final notes with fallback hierarchy
SELECT transaction_id,
       COALESCE(transaction_notes, transaction_type, 'No Notes') AS final_notes
FROM transactions;

-- 20. Feedbacks with null rating default to 3 in aggregation
SELECT customer_id, AVG(COALESCE(rating, 3)) AS avg_rating
FROM feedback
GROUP BY customer_id;

-- ⚙️ Real-Time Use Cases
-- 21. Always show fallback defaults in dashboard
SELECT order_id,
       COALESCE(revenue, 0) AS revenue,
       COALESCE(discount, 0) AS discount,
       COALESCE(region, 'Unknown Region') AS region,
       COALESCE(product_name, 'Unnamed Product') AS product_name
FROM orders;

-- 22. Clean last_order_date nulls for churn model
SELECT customer_id, 
       CASE WHEN last_order_date IS NULL THEN 'No Orders Yet'
            ELSE TO_CHAR(last_order_date, 'YYYY-MM-DD')
       END AS cleaned_last_order_date
FROM customers;

-- 23. Handling null product_id in reporting
SELECT order_id, 
       CASE WHEN product_id IS NULL THEN 'Missing Product ID'
            ELSE product_id::text
       END AS product_status
FROM orders;

-- 24. Strategy before exporting CSV to vendors
SELECT order_id, 
       COALESCE(shipping_date, 'Not Shipped') AS shipping_date,
       COALESCE(delivery_status, 'Pending') AS delivery_status,
       COALESCE(customer_feedback, 'No Feedback') AS feedback
FROM orders;

-- 25. Null handling in ETL validation (example logic for PySpark)
-- Conceptual: Pseudocode for PySpark usage
-- df = df.fillna({'order_id': 'UNKNOWN', 'customer_id': 'UNKNOWN', 'payment_status': 'PENDING'})
