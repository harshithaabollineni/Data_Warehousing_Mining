# Data Warehousing and Mining Practical

## Project Overview
This repository contains the practical implementation of Data Warehousing and Mining concepts using **PostgreSQL**. The practical demonstrates relational database creation, data manipulation, transaction management, and analytical operations using OLTP and OLAP concepts.

## Technologies Used
- **DBMS:** PostgreSQL
- **Database Tool:** pgAdmin 4
- **Language:** SQL
- **Operating System:** Windows

## Database Details

**Database Name:** `ShoppingDB`

The practical uses a shopping database to manage customers, products, orders, and order details.

## Database Tables

| Table Name | Description |
|---|---|
| Customers | Stores customer information |
| Products | Stores product details and prices |
| Orders | Stores customer order information |
| OrderDetails | Stores individual products associated with orders |

## Practical Implementation

### 1. Database Creation
- Created the `ShoppingDB` database.
- Connected to the database using pgAdmin 4.

### 2. Table Creation
Created four relational tables:
- Customers
- Products
- Orders
- OrderDetails

### 3. Data Insertion
Inserted sample records into the tables to demonstrate database operations.

### 4. OLTP Operations
Implemented Online Transaction Processing operations:
- INSERT – Adding new records.
- UPDATE – Modifying existing records.
- DELETE – Removing records.
- COMMIT – Permanently saving transactions.
- ROLLBACK – Reverting transactions.

### 5. OLAP Operations
Implemented Online Analytical Processing queries:
- Total revenue calculation using SUM().
- Customer-wise sales analysis.
- City-wise sales analysis.
- Total order count using COUNT().
- Monthly sales analysis using GROUP BY.
- Product-wise sales analysis using JOIN and aggregate functions.

### 6. Transaction Management
Demonstrated transaction handling using BEGIN, COMMIT, and ROLLBACK to understand transaction control in PostgreSQL.

### 7. OLTP and OLAP Comparison
Studied the differences between OLTP and OLAP based on their purpose, operations, and applications.

## SQL Concepts Covered
- CREATE DATABASE
- CREATE TABLE
- INSERT INTO
- SELECT
- UPDATE
- DELETE
- PRIMARY KEY
- FOREIGN KEY
- JOIN
- GROUP BY
- ORDER BY
- SUM()
- COUNT()
- EXTRACT()
- BEGIN
- COMMIT
- ROLLBACK

## Repository Structure

```text
Data-Warehousing-and-Mining/
│
├── Data_Warehousing_and_Mining_Practical.sql
└── README.md
```

## How to Execute

1. Install PostgreSQL and pgAdmin 4.
2. Open pgAdmin 4.
3. Create a database named `ShoppingDB`.
4. Open the Query Tool connected to `ShoppingDB`.
5. Open the SQL file in the Query Tool or paste its contents.
6. Execute the SQL commands in the correct order.
7. Verify the created tables and query results.

**Note:** The SQL script is intended for a fresh, empty `ShoppingDB` database. If the tables and records already exist, do not execute the complete script again without resetting the database.

## Learning Outcomes
- Understood relational database creation and management.
- Learned how to establish relationships using primary and foreign keys.
- Practiced SQL data manipulation operations.
- Understood transaction management using COMMIT and ROLLBACK.
- Performed analytical queries using aggregate functions and JOIN operations.
- Understood the practical differences between OLTP and OLAP.

## Conclusion
This practical provided hands-on experience with PostgreSQL and SQL operations. It demonstrated how relational databases manage daily transactions through OLTP and how stored data can be analyzed using OLAP queries. The implementation helped understand database relationships, transaction management, and analytical data processing.

---

**Subject:** Data Warehousing and Mining  
**Database:** ShoppingDB  
**Tool:** PostgreSQL / pgAdmin 4
