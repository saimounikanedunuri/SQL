-- Day 4 - Real-Time SQL Answers: String Functions for Data Cleaning

-- 1. Extract first name from full_name
SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name) - 1) AS first_name
FROM customers;

-- 2. Clean extra spaces in customer names
SELECT TRIM(full_name) AS clean_name
FROM customers;

-- 3. Replace '.con' with '.com' in email
SELECT REPLACE(email, '.con', '.com') AS fixed_email
FROM customers;

-- 4. Extract domain part of email
SELECT SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS email_domain
FROM customers;

-- 5. Extract first 3 characters of customer's name
SELECT LEFT(full_name, 3) AS name_code
FROM customers;

-- 6. Extract last 4 digits from customer_contact
SELECT RIGHT(customer_contact, 4) AS last_4_digits
FROM customers;

-- 7. Lowercase the email fields
SELECT LOWER(email) AS clean_email
FROM customers;

-- 8. Extract numeric part from order_id like "ORD#12345"
SELECT SUBSTRING(order_id, CHARINDEX('#', order_id) + 1, LEN(order_id)) AS order_number
FROM orders;

-- 9. Extract only name part from product_name like "P-1001 | Soap 200ml"
SELECT LTRIM(RTRIM(SUBSTRING(product_name, CHARINDEX('|', product_name) + 1, LEN(product_name)))) AS product_clean_name
FROM products;

-- 10. Replace underscores with spaces in customer names
SELECT REPLACE(full_name, '_', ' ') AS clean_name
FROM customers;

-- 11. Clean emails with spaces and fix format
SELECT TRIM(LOWER(email)) AS cleaned_email
FROM customers;

-- 12. Remove prefixes like "Mr." or "Ms."
SELECT REPLACE(full_name, 'Mr. ', '') AS no_prefix_name
FROM customers
WHERE full_name LIKE 'Mr.%'
UNION
SELECT REPLACE(full_name, 'Ms. ', '') 
FROM customers
WHERE full_name LIKE 'Ms.%';

-- 13. Identify missing '@' in emails
SELECT email
FROM customers
WHERE email NOT LIKE '%@%';

-- 14. Extract numeric part from order_id like "#ORD_000345"
SELECT SUBSTRING(order_id, CHARINDEX('_', order_id) + 1, LEN(order_id)) AS order_number
FROM orders;

-- 15. Remove "CAT - " prefix in category_name
SELECT REPLACE(category_name, 'CAT - ', '') AS cleaned_category
FROM categories;

-- 16. Extract initials from full name
SELECT 
  UPPER(LEFT(full_name, 1)) + '.' +
  UPPER(SUBSTRING(full_name, CHARINDEX(' ', full_name) + 1, 1)) + '.' AS initials
FROM customers;

-- 17. Remove tracking part after domain in email
SELECT 
  SUBSTRING(email, 1, CHARINDEX('#', email + '#') - 1) AS clean_email
FROM customers;

-- 18. Standardize full names (trim, lower, single spaces)
SELECT 
  LOWER(TRIM(REPLACE(REPLACE(full_name, '  ', ' '), '  ', ' '))) AS standardized_name
FROM customers;

-- 19. Detect email typos like 'john@@abc..com'
SELECT email
FROM customers
WHERE email LIKE '%@@%' OR email LIKE '%.%.%';

-- 20. Mask characters before '@' in email
SELECT 
  REPLICATE('*', CHARINDEX('@', email) - 1) + SUBSTRING(email, CHARINDEX('@', email), LEN(email)) AS masked_email
FROM customers;
