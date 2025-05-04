-- ✅ Day 11: CTEs, WITH Clause, and Recursive CTEs

-- 🧪 Scenario 1: Use CTE to simplify complex joins
-- Use Case: Combine customer data from two sources

WITH combined_customers AS (
    SELECT first_name, last_name FROM customers
    UNION
    SELECT first_name, last_name FROM archived_customers
)
SELECT * FROM combined_customers;

-- 🧪 Scenario 2: Use CTEs to find loyal customers (ordered in both 2023 and 2024)

WITH orders_2023 AS (
    SELECT DISTINCT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023
),
orders_2024 AS (
    SELECT DISTINCT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024
)
SELECT customer_id
FROM orders_2023
INTERSECT
SELECT customer_id
FROM orders_2024;

-- 🧪 Scenario 3: CTE for identifying inactive customers (ordered in 2023, not in 2024)

WITH orders_2023 AS (
    SELECT DISTINCT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023
),
orders_2024 AS (
    SELECT DISTINCT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024
)
SELECT customer_id
FROM orders_2023
EXCEPT
SELECT customer_id
FROM orders_2024;

-- 🧪 Scenario 4: Recursive CTE to generate a date series
-- Use Case: Useful for reporting or filling gaps in time series

WITH RECURSIVE date_series AS (
    SELECT DATE '2024-01-01' AS dt
    UNION ALL
    SELECT dt + INTERVAL '1 day'
    FROM date_series
    WHERE dt + INTERVAL '1 day' <= DATE '2024-01-10'
)
SELECT * FROM date_series;

-- 🧪 Scenario 5: Recursive CTE to generate sequence numbers
-- Use Case: Generate a number sequence without using a numbers table

WITH RECURSIVE numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1 FROM numbers WHERE num < 10
)
SELECT * FROM numbers;
