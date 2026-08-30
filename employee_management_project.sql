-- =====================================================
-- Employee Management & Salary Analysis
-- Database: company_db
-- =====================================================

CREATE DATABASE IF NOT EXISTS company_db;

USE company_db;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    location VARCHAR(50),
    salary INT,
    joining_date DATE,
    phone_number VARCHAR(10),
    age INT
);