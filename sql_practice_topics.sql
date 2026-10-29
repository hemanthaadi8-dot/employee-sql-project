-- ============================================================
-- SQL PRACTICE TOPICS
-- MySQL 8.0
-- Main practice database: company_db
-- Purpose: Consolidated examples from terminal practice
-- ============================================================

-- IMPORTANT:
-- Sections 1-10 use the user's company_db tables:
-- employees(emp_id, name, department, location, salary,
--           joining_date, phone_number, age, manager_id)
-- departments(department_name)
--
-- LeetCode-style examples at the end use separate problem tables.
-- Run those only when the corresponding tables exist.

USE company_db;


-- ============================================================
-- 1. SELECT, WHERE, COMPARISON OPERATORS
-- ============================================================

-- Employees earning more than 50000
SELECT name, salary
FROM employees
WHERE salary > 50000;

-- IT employees earning more than 60000
SELECT name, department, salary
FROM employees
WHERE department = 'IT'
  AND salary > 60000;

-- Employees in either IT or HR
SELECT name, department
FROM employees
WHERE department IN ('IT', 'HR');

-- Employees earning between 50000 and 70000 (inclusive)
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 70000;

-- Employees whose names start with 'A'
SELECT name
FROM employees
WHERE name LIKE 'A%';


-- ============================================================
-- 2. DISTINCT, ORDER BY, LIMIT, OFFSET
-- ============================================================

-- List each department once
SELECT DISTINCT department
FROM employees
ORDER BY department ASC;

-- Highest-paid employees first
SELECT name, salary
FROM employees
ORDER BY salary DESC;

-- Top 5 highest-paid employees
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Skip the first 5 rows and return the next 5
SELECT name, salary
FROM employees
ORDER BY emp_id
LIMIT 5 OFFSET 5;


-- ============================================================
-- 3. NULL HANDLING
-- ============================================================

-- Employees who do not have a manager
SELECT name, manager_id
FROM employees
WHERE manager_id IS NULL;

-- Employees who have a manager
SELECT name, manager_id
FROM employees
WHERE manager_id IS NOT NULL;

-- Reminder: use IS NULL / IS NOT NULL, not = NULL or 'NULL'.


-- ============================================================
-- 4. AGGREGATE FUNCTIONS
-- ============================================================

-- Count employees
SELECT COUNT(*) AS employee_count
FROM employees;

-- Average, minimum, maximum, and total salary
SELECT
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary,
    SUM(salary) AS total_salary
FROM employees;


-- ============================================================
-- 5. GROUP BY AND HAVING
-- ============================================================

-- Number of employees in each department
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- Average salary by department
SELECT department, AVG(salary) AS average_salary
FROM employees
GROUP BY department;

-- Departments whose average salary is greater than 60000
SELECT department, AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;


-- ============================================================
-- 6. JOINS
-- ============================================================

-- INNER JOIN: employee rows with matching department rows
SELECT e.name, e.department, d.department_name
FROM employees AS e
INNER JOIN departments AS d
    ON e.department = d.department_name;

-- LEFT JOIN: all employees, with department matches where available
SELECT e.name, e.department, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
    ON e.department = d.department_name;

-- RIGHT JOIN: all department rows, with employee matches where available
SELECT e.name, e.department, d.department_name
FROM employees AS e
RIGHT JOIN departments AS d
    ON e.department = d.department_name;

-- MySQL does not support FULL OUTER JOIN directly.
-- This LEFT JOIN + RIGHT JOIN + UNION pattern combines both sides.
SELECT e.name, e.department, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
    ON e.department = d.department_name
UNION
SELECT e.name, e.department, d.department_name
FROM employees AS e
RIGHT JOIN departments AS d
    ON e.department = d.department_name;


-- ============================================================
-- 7. SELF JOIN
-- ============================================================

-- Show each employee and their manager
SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m
    ON e.manager_id = m.emp_id;

-- Employees earning more than their managers
SELECT e.name
FROM employees AS e
JOIN employees AS m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


-- ============================================================
-- 8. SUBQUERIES: SCALAR, IN, EXISTS
-- ============================================================

-- Employees earning more than the overall average salary
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Employees working in departments that have at least one employee
SELECT name, department
FROM employees
WHERE department IN (
    SELECT department
    FROM employees
);

-- EXISTS: employees whose department has an employee earning over 80000
SELECT e.name, e.department
FROM employees AS e
WHERE EXISTS (
    SELECT 1
    FROM employees AS e2
    WHERE e2.department = e.department
      AND e2.salary > 80000
);

-- Employees whose salary is the maximum salary
SELECT name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);


-- ============================================================
-- 9. CASE AND COALESCE
-- ============================================================

-- Categorize employees by salary
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 70000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;

-- Display a label when manager_id is NULL
SELECT
    name,
    COALESCE(CAST(manager_id AS CHAR), 'No manager') AS manager
FROM employees;


-- ============================================================
-- 10. DATE FUNCTIONS
-- ============================================================

-- Employees who joined in 2022
SELECT name, joining_date
FROM employees
WHERE YEAR(joining_date) = 2022;

-- Employees who joined in January
SELECT name, joining_date
FROM employees
WHERE MONTH(joining_date) = 1;

-- Employees who joined on or after 2023-01-01
SELECT name, joining_date
FROM employees
WHERE joining_date >= '2023-01-01';

-- Number of days between joining date and 2024-01-01
SELECT
    name,
    DATEDIFF('2024-01-01', joining_date) AS days_difference
FROM employees;

-- Employees who joined in the last 365 days relative to today
SELECT name, joining_date
FROM employees
WHERE joining_date >= DATE_SUB(CURDATE(), INTERVAL 365 DAY);


-- ============================================================
-- 11. COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================

-- A CTE is a named result available to the statement that follows it.
WITH hyderabad_employees AS (
    SELECT name, location, salary
    FROM employees
    WHERE location = 'Hyderabad'
      AND salary > 50000
)
SELECT *
FROM hyderabad_employees;


-- ============================================================
-- 12. LEETCODE-STYLE PRACTICE
-- These examples use separate problem tables.
-- Run only when the named table and columns exist.
-- ============================================================

-- Products: return IDs that are both low-fat and recyclable.
-- Table: Products(product_id, low_fats, recyclable)
-- SELECT product_id
-- FROM Products
-- WHERE low_fats = 'Y'
--   AND recyclable = 'Y';


-- Customer: names whose referee is not customer 2,
-- including customers with no referee.
-- Table: Customer(id, name, referee_id)
-- SELECT name
-- FROM Customer
-- WHERE referee_id != 2
--    OR referee_id IS NULL;


-- Big Countries: either area is at least 3000000
-- OR population is at least 25000000.
-- Table: World(name, continent, area, population, gdp)
-- SELECT name, population, area
-- FROM World
-- WHERE area >= 3000000
--    OR population >= 25000000;


-- Views: authors who viewed at least one of their own articles.
-- Table: Views(article_id, author_id, viewer_id, view_date)
-- SELECT DISTINCT author_id AS id
-- FROM Views
-- WHERE author_id = viewer_id
-- ORDER BY id ASC;


-- Invalid Tweets: content with strictly more than 15 characters.
-- Table: Tweets(tweet_id, content)
-- SELECT tweet_id
-- FROM Tweets
-- WHERE CHAR_LENGTH(content) > 15;


-- Customers who never placed an order.
-- Tables: Customers(id, name), Orders(id, customerId)
-- SELECT name
-- FROM Customers
-- WHERE id NOT IN (
--     SELECT customerId
--     FROM Orders
-- );


-- ============================================================
-- END OF PRACTICE FILE
-- Next topic to practise: window functions
-- (ROW_NUMBER, RANK, DENSE_RANK)
-- ============================================================
