-- ============================================================
-- RETAIL DIMENSIONAL DATA WAREHOUSE (STAR SCHEMA)
-- Database: Retail_Dimensional_DW
-- Run this script while connected to Retail_Dimensional_DW.
-- ============================================================

-- 1. CREATE DIMENSION TABLES AND FACT TABLE
CREATE TABLE IF NOT EXISTS dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_store (
    store_key SERIAL PRIMARY KEY,
    store_id INT,
    store_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS fact_sales (
    sales_key SERIAL PRIMARY KEY,
    transaction_id INT,
    date_key INT REFERENCES dim_date(date_key),
    product_key INT REFERENCES dim_product(product_key),
    customer_key INT REFERENCES dim_customer(customer_key),
    store_key INT REFERENCES dim_store(store_key),
    quantity INT,
    unit_price NUMERIC(10,2),
    discount NUMERIC(10,2),
    total_sales NUMERIC(12,2)
);

-- 2. INSERT DIMENSION DATA
INSERT INTO dim_date (full_date, day, month, month_name, quarter, year)
SELECT v.full_date, EXTRACT(DAY FROM v.full_date)::INT,
       EXTRACT(MONTH FROM v.full_date)::INT,
       TO_CHAR(v.full_date, 'FMMonth'),
       EXTRACT(QUARTER FROM v.full_date)::INT,
       EXTRACT(YEAR FROM v.full_date)::INT
FROM (VALUES
    (DATE '2026-01-10'),
    (DATE '2026-01-15'),
    (DATE '2026-02-05'),
    (DATE '2026-02-20')
) AS v(full_date)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_date d WHERE d.full_date = v.full_date
);

INSERT INTO dim_product (product_id, product_name, category, brand)
SELECT v.product_id, v.product_name, v.category, v.brand
FROM (VALUES
    (101, 'Laptop', 'Electronics', 'Dell'),
    (102, 'Mobile', 'Electronics', 'Samsung'),
    (103, 'Mouse', 'Accessories', 'Logitech'),
    (104, 'Keyboard', 'Accessories', 'HP'),
    (105, 'Chair', 'Furniture', 'Godrej')
) AS v(product_id, product_name, category, brand)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_product p WHERE p.product_id = v.product_id
);

INSERT INTO dim_customer (customer_id, customer_name, gender, city, state)
SELECT v.customer_id, v.customer_name, v.gender, v.city, v.state
FROM (VALUES
    (201, 'Rahul', 'Male', 'Hyderabad', 'Telangana'),
    (202, 'Priya', 'Female', 'Vijayawada', 'Andhra Pradesh'),
    (203, 'Amit', 'Male', 'Chennai', 'Tamil Nadu'),
    (204, 'Sneha', 'Female', 'Bengaluru', 'Karnataka')
) AS v(customer_id, customer_name, gender, city, state)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_customer c WHERE c.customer_id = v.customer_id
);

INSERT INTO dim_store (store_id, store_name, city, state)
SELECT v.store_id, v.store_name, v.city, v.state
FROM (VALUES
    (301, 'Central Mall', 'Hyderabad', 'Telangana'),
    (302, 'City Mall', 'Vijayawada', 'Andhra Pradesh'),
    (303, 'Mega Store', 'Chennai', 'Tamil Nadu')
) AS v(store_id, store_name, city, state)
WHERE NOT EXISTS (
    SELECT 1 FROM dim_store s WHERE s.store_id = v.store_id
);

-- 3. INSERT FACT DATA
-- The date/product/customer/store keys below are generated surrogate keys.
-- This script resolves them by matching the dimension values.
INSERT INTO fact_sales (
    transaction_id, date_key, product_key, customer_key, store_key,
    quantity, unit_price, discount, total_sales
)
SELECT
    v.transaction_id,
    d.date_key,
    p.product_key,
    c.customer_key,
    st.store_key,
    v.quantity,
    v.unit_price,
    v.discount,
    (v.quantity * v.unit_price - v.discount)::NUMERIC(12,2)
FROM (VALUES
    (1001, DATE '2026-01-10', 'Laptop', 'Rahul', 'Central Mall', 2, 50000.00, 2000.00),
    (1001, DATE '2026-01-10', 'Mouse', 'Rahul', 'Central Mall', 1, 1000.00, 0.00),
    (1002, DATE '2026-01-15', 'Mobile', 'Priya', 'City Mall', 2, 20000.00, 1000.00),
    (1003, DATE '2026-02-05', 'Laptop', 'Amit', 'Mega Store', 1, 50000.00, 5000.00),
    (1004, DATE '2026-02-20', 'Keyboard', 'Sneha', 'Central Mall', 3, 2000.00, 0.00)
) AS v(transaction_id, full_date, product_name, customer_name, store_name,
       quantity, unit_price, discount)
JOIN dim_date d ON d.full_date = v.full_date
JOIN dim_product p ON p.product_name = v.product_name
JOIN dim_customer c ON c.customer_name = v.customer_name
JOIN dim_store st ON st.store_name = v.store_name
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_sales f
    WHERE f.transaction_id = v.transaction_id
      AND f.date_key = d.date_key
      AND f.product_key = p.product_key
      AND f.customer_key = c.customer_key
      AND f.store_key = st.store_key
);

-- 4. VERIFY DIMENSION AND FACT DATA
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT * FROM dim_date ORDER BY date_key;
SELECT * FROM dim_product ORDER BY product_key;
SELECT * FROM dim_customer ORDER BY customer_key;
SELECT * FROM dim_store ORDER BY store_key;
SELECT * FROM fact_sales ORDER BY sales_key;

-- 5. ANALYTICAL QUERIES

-- 5.1 Total revenue
SELECT SUM(total_sales) AS total_revenue
FROM fact_sales;

-- 5.2 Product-wise sales
SELECT
    p.product_name,
    SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY p.product_name;

-- 5.3 Customer-wise sales
SELECT
    c.customer_name,
    SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name
ORDER BY c.customer_name;

-- 5.4 Monthly sales
SELECT
    d.month_name,
    SUM(f.total_sales) AS monthly_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.month, d.month_name
ORDER BY d.month;

-- 5.5 Store-wise sales
SELECT
    s.store_name,
    SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY s.store_name
ORDER BY s.store_name;

-- 5.6 Category-wise sales
SELECT
    p.category,
    SUM(f.total_sales) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY p.category;

-- 6. FINAL VERIFICATION
SELECT
    COUNT(*) AS total_records,
    SUM(quantity) AS total_quantity,
    SUM(total_sales) AS total_revenue
FROM fact_sales;

-- END OF DIMENSIONAL MODELLING SCRIPT
