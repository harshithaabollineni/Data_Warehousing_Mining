# Data_Warehousing_Mining
# Data Warehouse Architecture Design and Implementation

## Project Overview

This repository contains the practical implementation of Data Warehouse Architecture Design and Implementation using PostgreSQL and pgAdmin 4. It covers two important approaches to database design: Normalized Modelling and Dimensional Modelling. Both approaches are implemented using a retail sales dataset to understand how data can be organized, stored, and analyzed efficiently.

## Technologies Used

- PostgreSQL
- pgAdmin 4
- SQL
- Visual Studio Code
- GitHub

## Project Structure


Skill/
│
├── 01_Normalized_Modelling/
│
├── 02_Dimensional_Modelling/
│
└── README.md


## Skill 1: Normalized Modelling

### Objective
To design and implement a normalized retail database that reduces data redundancy and maintains data consistency.

### Database Name
`Retail_Normalized_DW`

### Tables Created

1. **Category** – Stores product category details.
2. **Product** – Stores product names, brands, and category references.
3. **Customer** – Stores customer information.
4. **Store** – Stores retail store information.
5. **Sales** – Stores transaction dates and customer and store references.
6. **Sales_Details** – Stores product quantities, prices, and discounts for each transaction.

### Implementation

- Created six relational tables using SQL.
- Established primary key and foreign key relationships.
- Inserted sample retail data.
- Executed SQL queries using JOIN, GROUP BY, and aggregate functions.
- Performed sales analysis based on products, customers, categories, and stores.

## Skill 2: Dimensional Modelling

### Objective
To design and implement a dimensional data warehouse using a Star Schema for analytical reporting and decision-making.

### Database Name
`Retail_Dimensional_DW`

### Tables Created

**Dimension Tables:**

1. `dim_date` – Stores date-related information.
2. `dim_product` – Stores product, category, and brand details.
3. `dim_customer` – Stores customer information.
4. `dim_store` – Stores store information.

**Fact Table:**

5. `fact_sales` – Stores transaction measures such as quantity, unit price, discount, and total sales.

### Implementation

- Created four dimension tables and one fact table.
- Implemented primary key and foreign key relationships.
- Designed a Star Schema.
- Inserted sample dimension and fact records.
- Executed analytical queries to calculate revenue and analyze sales.
- Performed product-wise, customer-wise, monthly, store-wise, and category-wise analysis.

## Results

Both normalized and dimensional database models were successfully implemented using PostgreSQL.

The dimensional model's final verification produced:

- Total Records: 5
- Total Quantity: 9
- Total Revenue: 189000.00

The implementation demonstrates the difference between normalized database design for transactional data management and dimensional modelling for analytical processing.

## How to Run

1. Install PostgreSQL and pgAdmin 4.
2. Create the database `Retail_Normalized_DW`.
3. Open the normalized SQL file in pgAdmin Query Tool and execute it.
4. Create the database `Retail_Dimensional_DW`.
5. Open the dimensional SQL file in its respective Query Tool and execute it.
6. Run the analytical queries to view the results.

**Note:** Run each SQL script in its corresponding database. If you have already created and populated the tables, avoid executing the complete scripts again without checking the existing data.

## Conclusion

This practical helped demonstrate the implementation of normalized and dimensional data warehouse architectures using SQL. It provided hands-on experience in relational database design, table relationships, data insertion, Star Schema implementation, and analytical querying using PostgreSQL.
