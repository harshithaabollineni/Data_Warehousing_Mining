-- ============================================================
-- RETAIL NORMALIZED DATA WAREHOUSE
-- Database: Retail_Normalized_DW
-- Run this script while connected to Retail_Normalized_DW.
-- ============================================================

-- 1. CREATE TABLES
CREATE TABLE IF NOT EXISTS category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE
);

CREATE TABLE IF NOT EXISTS product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    brand VARCHAR(50),
    category_id INT REFERENCES category(category_id)
);

CREATE TABLE IF NOT EXISTS customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS sales (
    sales_id SERIAL PRIMARY KEY,
    transaction_date DATE,
    customer_id INT REFERENCES customer(customer_id),
    store_id INT REFERENCES store(store_id)
);

CREATE TABLE IF NOT EXISTS sales_details (
    sales_detail_id SERIAL PRIMARY KEY,
    sales_id INT REFERENCES sales(sales_id),
    product_id INT REFERENCES product(product_id),
    quantity INT,
    unit_price NUMERIC(10,2),
    discount NUMERIC(10,2)
);

-- 2. INSERT SAMPLE DATA
INSERT INTO category (category_name)
VALUES
('Electronics'),
('Accessories'),
('Furniture')
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO product (product_name, brand, category_id)
SELECT v.product_name, v.brand, c.category_id
FROM (VALUES
    ('Laptop', 'Dell', 'Electronics'),
    ('Mobile', 'Samsung', 'Electronics'),
    ('Mouse', 'Logitech', 'Accessories'),
    ('Keyboard', 'HP', 'Accessories'),
    ('Chair', 'Godrej', 'Furniture')
) AS v(product_name, brand, category_name)
JOIN category c ON c.category_name = v.category_name
WHERE NOT EXISTS (
    SELECT 1 FROM product p WHERE p.product_name = v.product_name
);

INSERT INTO customer (customer_name, gender, city, state)
SELECT v.customer_name, v.gender, v.city, v.state
FROM (VALUES
    ('Rahul', 'Male', 'Hyderabad', 'Telangana'),
    ('Priya', 'Female', 'Vijayawada', 'Andhra Pradesh'),
    ('Amit', 'Male', 'Chennai', 'Tamil Nadu'),
    ('Sneha', 'Female', 'Bengaluru', 'Karnataka')
) AS v(customer_name, gender, city, state)
WHERE NOT EXISTS (
    SELECT 1 FROM customer c WHERE c.customer_name = v.customer_name
);

INSERT INTO store (store_name, city, state)
SELECT v.store_name, v.city, v.state
FROM (VALUES
    ('Central Mall', 'Hyderabad', 'Telangana'),
    ('City Mall', 'Vijayawada', 'Andhra Pradesh'),
    ('Mega Store', 'Chennai', 'Tamil Nadu')
) AS v(store_name, city, state)
WHERE NOT EXISTS (
    SELECT 1 FROM store s WHERE s.store_name = v.store_name
);

INSERT INTO sales (transaction_date, customer_id, store_id)
SELECT v.transaction_date, c.customer_id, st.store_id
FROM (VALUES
    (DATE '2026-01-10', 'Rahul', 'Central Mall'),
    (DATE '2026-01-15', 'Priya', 'City Mall'),
    (DATE '2026-02-05', 'Amit', 'Mega Store'),
    (DATE '2026-02-20', 'Sneha', 'Central Mall')
) AS v(transaction_date, customer_name, store_name)
JOIN customer c ON c.customer_name = v.customer_name
JOIN store st ON st.store_name = v.store_name
WHERE NOT EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.transaction_date = v.transaction_date
      AND s.customer_id = c.customer_id
      AND s.store_id = st.store_id
);

INSERT INTO sales_details (sales_id, product_id, quantity, unit_price, discount)
SELECT s.sales_id, p.product_id, v.quantity, v.unit_price, v.discount
FROM (VALUES
    (DATE '2026-01-10', 'Rahul', 'Laptop', 2, 50000.00, 2000.00),
    (DATE '2026-01-10', 'Rahul', 'Mouse', 1, 1000.00, 0.00),
    (DATE '2026-01-15', 'Priya', 'Mobile', 2, 20000.00, 1000.00),
    (DATE '2026-02-05', 'Amit', 'Laptop', 1, 50000.00, 5000.00),
    (DATE '2026-02-20', 'Sneha', 'Keyboard', 3, 2000.00, 0.00)
) AS v(transaction_date, customer_name, product_name, quantity, unit_price, discount)
JOIN customer c ON c.customer_name = v.customer_name
JOIN sales s ON s.transaction_date = v.transaction_date
           AND s.customer_id = c.customer_id
JOIN product p ON p.product_name = v.product_name
WHERE NOT EXISTS (
    SELECT 1 FROM sales_details sd
    WHERE sd.sales_id = s.sales_id AND sd.product_id = p.product_id
);

-- 3. VERIFY TABLES AND SAMPLE DATA
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT * FROM category ORDER BY category_id;
SELECT * FROM product ORDER BY product_id;
SELECT * FROM customer ORDER BY customer_id;
SELECT * FROM store ORDER BY store_id;
SELECT * FROM sales ORDER BY sales_id;
SELECT * FROM sales_details ORDER BY sales_detail_id;

-- 4. ANALYTICAL QUERIES

-- 4.1 Complete sales details
SELECT
    s.sales_id,
    s.transaction_date,
    c.customer_name,
    p.product_name,
    sd.quantity,
    sd.unit_price,
    sd.discount,
    (sd.quantity * sd.unit_price - sd.discount) AS total_amount
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
JOIN sales_details sd ON s.sales_id = sd.sales_id
JOIN product p ON sd.product_id = p.product_id
ORDER BY s.sales_id, p.product_name;

-- 4.2 Product-wise sales
SELECT
    p.product_name,
    SUM(sd.quantity * sd.unit_price - sd.discount) AS total_sales
FROM sales_details sd
JOIN product p ON sd.product_id = p.product_id
GROUP BY p.product_name
ORDER BY p.product_name;

-- 4.3 Customer-wise sales
SELECT
    c.customer_name,
    SUM(sd.quantity * sd.unit_price - sd.discount) AS total_sales
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
JOIN sales_details sd ON s.sales_id = sd.sales_id
GROUP BY c.customer_name
ORDER BY c.customer_name;

-- 4.4 Category-wise sales
SELECT
    cat.category_name,
    SUM(sd.quantity * sd.unit_price - sd.discount) AS total_sales
FROM sales_details sd
JOIN product p ON sd.product_id = p.product_id
JOIN category cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY cat.category_name;

-- 4.5 Store-wise sales
SELECT
    st.store_name,
    SUM(sd.quantity * sd.unit_price - sd.discount) AS total_sales
FROM sales s
JOIN store st ON s.store_id = st.store_id
JOIN sales_details sd ON s.sales_id = sd.sales_id
GROUP BY st.store_name
ORDER BY st.store_name;

-- END OF NORMALIZED MODELLING SCRIPT
