-- ✅ Day 15: ROW_NUMBER(), RANK(), DENSE_RANK() – Real-Time SQL Scenarios

-- 🧪 Scenario 1: Find the 2nd Highest Salary in Each Department
-- Use Case: HR wants to recognize the second-best performer in each department.
SELECT *
FROM (
  SELECT employee_id, first_name, department_id, salary,
         RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_salary_rank
  FROM employees
) ranked
WHERE dept_salary_rank = 2;


-- 🧪 Scenario 2: Deduplicate Orders, Keep Only Latest per Customer
-- Use Case: Analytics team wants to keep only the latest order per customer.
SELECT *
FROM (
  SELECT *, 
         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
  FROM orders
) latest_orders
WHERE rn = 1;


-- 🧪 Scenario 3: List Top 3 Selling Products per Category
-- Use Case: Business wants to showcase the bestsellers by category on the homepage.
SELECT *
FROM (
  SELECT p.product_id, p.product_name, c.category_name, SUM(oi.quantity) AS total_sold,
         RANK() OVER (PARTITION BY c.category_id ORDER BY SUM(oi.quantity) DESC) AS product_rank
  FROM order_items oi
  JOIN products p ON oi.product_id = p.product_id
  JOIN categories c ON p.category_id = c.category_id
  GROUP BY p.product_id, p.product_name, c.category_name, c.category_id
) ranked
WHERE product_rank <= 3;


-- 🧪 Scenario 4: Detect Salary Ties Using DENSE_RANK()
-- Use Case: Finance wants to analyze pay band distribution without skipping tied ranks.
SELECT employee_id, first_name, department_id, salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_band
FROM employees;


-- 🧪 Scenario 5: Customers with Multiple Orders but Only the Latest One
-- Use Case: For feedback collection, show the latest order per repeat customer.
SELECT *
FROM (
  SELECT o.*, 
         ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS rn
  FROM orders o
  JOIN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
  ) repeat_customers ON o.customer_id = repeat_customers.customer_id
) filtered
WHERE rn = 1;


-- 🧪 Scenario 6: Employee of the Month
-- Use Case: Select the highest sales-generating employee for each month.
-- Assuming there's a sales table with: employee_id, sale_date, amount.
SELECT *
FROM (
  SELECT employee_id, DATE_TRUNC('month', sale_date) AS sale_month, SUM(amount) AS monthly_sales,
         ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('month', sale_date) ORDER BY SUM(amount) DESC) AS rn
  FROM sales
  GROUP BY employee_id, DATE_TRUNC('month', sale_date)
) ranked
WHERE rn = 1;
