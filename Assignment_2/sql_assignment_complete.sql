/* ============================================================================
   SQL ASSIGNMENT — COMPLETE EXECUTABLE FILE
   ============================================================================
   Database : E-Commerce (Indian Market Sample)
   Tables   : customers, products, orders, order_items
   Engine   : MySQL 8.0+  (also compatible with PostgreSQL with minor tweaks)
   
   HOW TO RUN:
     1. Open MySQL Workbench / phpMyAdmin / any MySQL client
     2. Create a database:  CREATE DATABASE ecommerce_db;
     3. Switch to it:       USE ecommerce_db;
     4. Copy-paste this entire file and execute
     5. Each query result will appear in order
   ============================================================================ */


/* ============================================================================
   PART 1: DATABASE & TABLE SETUP
   ============================================================================
   We first drop existing tables (in reverse dependency order) to allow
   re-running this script cleanly, then create all 4 tables with proper
   constraints, primary keys, and foreign keys.
   ============================================================================ */

-- Drop tables in reverse dependency order (child tables first)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- -------------------------
-- Table 1: customers
-- -------------------------
CREATE TABLE customers (
    customer_id   INT            PRIMARY KEY,
    first_name    VARCHAR(50)    NOT NULL,
    last_name     VARCHAR(50)    NOT NULL,
    email         VARCHAR(100)   UNIQUE NOT NULL,
    city          VARCHAR(50)    NOT NULL,
    state         VARCHAR(50)    NOT NULL,
    join_date     DATE           NOT NULL,
    is_premium    BOOLEAN        DEFAULT FALSE
);

-- -------------------------
-- Table 2: products
-- -------------------------
CREATE TABLE products (
    product_id    INT            PRIMARY KEY,
    product_name  VARCHAR(100)   NOT NULL,
    category      VARCHAR(50)    NOT NULL,
    brand         VARCHAR(50)    NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL  CHECK (unit_price > 0),
    stock_qty     INT            NOT NULL  DEFAULT 0  CHECK (stock_qty >= 0)
);

-- -------------------------
-- Table 3: orders
-- -------------------------
CREATE TABLE orders (
    order_id      INT            PRIMARY KEY,
    customer_id   INT            NOT NULL,
    order_date    DATE           NOT NULL,
    status        VARCHAR(20)    NOT NULL  DEFAULT 'Pending'
                                 CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')),
    total_amount  DECIMAL(12,2)  NOT NULL  CHECK (total_amount >= 0),

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -------------------------
-- Table 4: order_items
-- -------------------------
CREATE TABLE order_items (
    item_id       INT            PRIMARY KEY,
    order_id      INT            NOT NULL,
    product_id    INT            NOT NULL,
    quantity      INT            NOT NULL  CHECK (quantity > 0),
    unit_price    DECIMAL(10,2)  NOT NULL  CHECK (unit_price > 0),
    discount_pct  DECIMAL(5,2)   DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),

    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


/* ============================================================================
   PART 2: CREATE INDEXES
   ============================================================================
   Indexes speed up WHERE, JOIN, and ORDER BY operations on frequently
   queried columns. They are B-Tree structures that let the database
   find rows without scanning the entire table.
   ============================================================================ */

-- Indexes on customers
CREATE INDEX idx_customers_city  ON customers(city);
CREATE INDEX idx_customers_state ON customers(state);
CREATE INDEX idx_customers_join_date ON customers(join_date);

-- Indexes on orders
CREATE INDEX idx_orders_date   ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);

-- Index on products
CREATE INDEX idx_products_category ON products(category);


/* ============================================================================
   PART 3: INSERT SAMPLE DATA
   ============================================================================ */

-- ========== INSERT: customers ==========
INSERT INTO customers VALUES
(101, 'Aarav',   'Sharma', 'aarav.s@email.com',   'Mumbai',    'Maharashtra',  '2024-01-15', TRUE),
(102, 'Priya',   'Patel',  'priya.p@email.com',   'Ahmedabad', 'Gujarat',      '2024-02-20', FALSE),
(103, 'Rohan',   'Gupta',  'rohan.g@email.com',   'Delhi',     'Delhi',        '2024-03-10', TRUE),
(104, 'Sneha',   'Reddy',  'sneha.r@email.com',   'Hyderabad', 'Telangana',    '2024-04-05', FALSE),
(105, 'Vikram',  'Singh',  'vikram.s@email.com',   'Jaipur',    'Rajasthan',    '2024-05-12', TRUE),
(106, 'Ananya',  'Iyer',   'ananya.i@email.com',   'Chennai',   'Tamil Nadu',   '2024-06-18', FALSE),
(107, 'Karan',   'Mehta',  'karan.m@email.com',    'Pune',      'Maharashtra',  '2024-07-22', TRUE),
(108, 'Divya',   'Nair',   'divya.n@email.com',    'Kochi',     'Kerala',       '2024-08-30', FALSE);

-- ========== INSERT: products ==========
INSERT INTO products VALUES
(201, 'Wireless Earbuds',      'Electronics', 'BoAt',         1499.00, 250),
(202, 'Cotton T-Shirt',        'Clothing',    'Levis',         799.00, 500),
(203, 'Smart Watch',           'Electronics', 'Noise',        2999.00, 150),
(204, 'Running Shoes',         'Clothing',    'Nike',         4599.00, 120),
(205, 'Bluetooth Speaker',     'Electronics', 'JBL',          3499.00, 200),
(206, 'Bedsheet Set',          'Home',        'Spaces',       1299.00, 300),
(207, 'Laptop Stand',          'Electronics', 'AmazonBasics',  899.00, 180),
(208, 'Cushion Covers (Set)',  'Home',        'HomeCenter',    599.00, 400);

-- ========== INSERT: orders ==========
INSERT INTO orders VALUES
(1001, 101, '2024-08-01', 'Delivered',  2998.00),
(1002, 102, '2024-08-05', 'Delivered',  4599.00),
(1003, 103, '2024-08-10', 'Shipped',    1499.00),
(1004, 104, '2024-08-12', 'Pending',    3798.00),
(1005, 105, '2024-08-15', 'Delivered',  5998.00),
(1006, 106, '2024-08-18', 'Cancelled',   799.00),
(1007, 107, '2024-08-20', 'Shipped',    6998.00),
(1008, 108, '2024-08-22', 'Delivered',  1299.00),
(1009, 101, '2024-08-25', 'Pending',    4498.00),
(1010, 103, '2024-09-01', 'Delivered',   899.00);

-- ========== INSERT: order_items ==========
INSERT INTO order_items VALUES
(1,  1001, 201, 2, 1499.00,  0.00),   -- Order 1001: 2× Wireless Earbuds
(2,  1002, 204, 1, 4599.00,  0.00),   -- Order 1002: 1× Running Shoes
(3,  1003, 201, 1, 1499.00,  5.00),   -- Order 1003: 1× Wireless Earbuds (5% off)
(4,  1004, 203, 1, 2999.00,  0.00),   -- Order 1004: 1× Smart Watch
(5,  1004, 202, 1,  799.00,  0.00),   -- Order 1004: 1× Cotton T-Shirt
(6,  1005, 203, 2, 2999.00,  0.00),   -- Order 1005: 2× Smart Watch
(7,  1006, 202, 1,  799.00,  0.00),   -- Order 1006: 1× Cotton T-Shirt
(8,  1007, 205, 2, 3499.00,  5.00),   -- Order 1007: 2× Bluetooth Speaker (5% off)
(9,  1008, 206, 1, 1299.00,  0.00),   -- Order 1008: 1× Bedsheet Set
(10, 1009, 201, 1, 1499.00,  0.00),   -- Order 1009: 1× Wireless Earbuds
(11, 1009, 203, 1, 2999.00, 10.00),   -- Order 1009: 1× Smart Watch (10% off)
(12, 1010, 207, 1,  899.00,  0.00),   -- Order 1010: 1× Laptop Stand
(13, 1007, 208, 3,  599.00,  0.00),   -- Order 1007: 3× Cushion Covers
(14, 1005, 207, 1,  899.00, 10.00),   -- Order 1005: 1× Laptop Stand (10% off)
(15, 1002, 206, 1, 1299.00, 10.00);   -- Order 1002: 1× Bedsheet Set (10% off)


/* ============================================================================
   PART 4: VERIFY DATA LOADED CORRECTLY
   ============================================================================ */

SELECT 'customers'   AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products',   COUNT(*) FROM products
UNION ALL
SELECT 'orders',     COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

-- Expected Output:
-- +-------------+-----------+
-- | table_name  | row_count |
-- +-------------+-----------+
-- | customers   |         8 |
-- | products    |         8 |
-- | orders      |        10 |
-- | order_items |        15 |
-- +-------------+-----------+


/* ============================================================================
   ╔══════════════════════════════════════════════════════════════════════════╗
   ║          SECTION A — SQL BASICS (SELECT, Constraints, Primary Keys)    ║
   ║          Questions 1 – 6                                               ║
   ╚══════════════════════════════════════════════════════════════════════════╝
   ============================================================================ */


-- ============================================================================
-- Q1. Write a query to display all columns and rows from the customers table.
-- ============================================================================
-- EXPLANATION:
--   SELECT * retrieves every column.
--   No WHERE clause means every row is returned.
--   The asterisk (*) is a wildcard that expands to all column names.

SELECT * FROM customers;

-- Expected Output: All 8 rows with columns:
-- customer_id, first_name, last_name, email, city, state, join_date, is_premium


-- ============================================================================
-- Q2. Retrieve only the first_name, last_name, and city of all customers.
-- ============================================================================
-- EXPLANATION:
--   Instead of SELECT *, we explicitly list only the columns we need.
--   This is called "column projection" — it reduces data transferred and
--   makes the query intent clearer. Best practice over SELECT *.

SELECT first_name, last_name, city
FROM customers;

-- Expected Output:
-- +------------+-----------+-----------+
-- | first_name | last_name | city      |
-- +------------+-----------+-----------+
-- | Aarav      | Sharma    | Mumbai    |
-- | Priya      | Patel     | Ahmedabad |
-- | Rohan      | Gupta     | Delhi     |
-- | Sneha      | Reddy     | Hyderabad |
-- | Vikram     | Singh     | Jaipur    |
-- | Ananya     | Iyer      | Chennai   |
-- | Karan      | Mehta     | Pune      |
-- | Divya      | Nair      | Kochi     |
-- +------------+-----------+-----------+


-- ============================================================================
-- Q3. List all unique categories available in the products table.
-- ============================================================================
-- EXPLANATION:
--   DISTINCT removes duplicate values from the result set.
--   Without DISTINCT, 'Electronics' would appear 4 times (products 201,203,205,207).
--   With DISTINCT, each category appears exactly once.

SELECT DISTINCT category
FROM products;

-- Expected Output:
-- +-------------+
-- | category    |
-- +-------------+
-- | Electronics |
-- | Clothing    |
-- | Home        |
-- +-------------+


-- ============================================================================
-- Q4. Identify the Primary Key of each table in the schema.
--     Explain why a Primary Key must be unique and NOT NULL.
-- ============================================================================
-- ANSWER (Theoretical):
--
-- Primary Keys in this schema:
--   ┌───────────────┬──────────────┐
--   │ Table         │ Primary Key  │
--   ├───────────────┼──────────────┤
--   │ customers     │ customer_id  │
--   │ products      │ product_id   │
--   │ orders        │ order_id     │
--   │ order_items   │ item_id      │
--   └───────────────┴──────────────┘
--
-- WHY must a Primary Key be UNIQUE and NOT NULL?
--
-- 1. UNIQUE: A primary key uniquely identifies each row in the table.
--    If two rows had the same primary key value, there would be no way
--    to distinguish between them — you couldn't update or delete a
--    specific row. Example: If two customers both had customer_id = 101,
--    which one does an order with customer_id = 101 belong to?
--
-- 2. NOT NULL: A primary key must always have a value because it serves
--    as the row's identity. A NULL value means "unknown" or "missing".
--    If a row's identity is unknown, it cannot be reliably referenced
--    by foreign keys or used in JOINs. It would break referential integrity.
--
-- Together, UNIQUE + NOT NULL guarantee that every row has a definite,
-- one-of-a-kind identifier.

-- Verification query — show primary key columns:
SELECT * FROM customers  WHERE customer_id IS NULL;  -- Always returns 0 rows
SELECT * FROM products   WHERE product_id  IS NULL;  -- Always returns 0 rows
SELECT * FROM orders     WHERE order_id    IS NULL;  -- Always returns 0 rows
SELECT * FROM order_items WHERE item_id    IS NULL;  -- Always returns 0 rows


-- ============================================================================
-- Q5. What constraints are applied to the email column in the customers table?
--     What would happen if you tried to insert a duplicate email?
-- ============================================================================
-- ANSWER (Theoretical + Demonstration):
--
-- Constraints on the email column:
--   1. UNIQUE  — No two customers can have the same email address.
--   2. NOT NULL — Every customer must have an email; it cannot be left empty.
--
-- WHAT HAPPENS with a duplicate email:
--   The database rejects the INSERT with an error like:
--   ERROR 1062 (23000): Duplicate entry 'aarav.s@email.com' for key 'email'
--
-- WHY this matters:
--   Email is often used as a login credential or communication channel.
--   Allowing duplicates would mean two different customers sharing the
--   same email — leading to wrong emails, login conflicts, and data confusion.

-- Demonstration: This INSERT will FAIL because the email already exists
-- Uncomment the line below to see the error:

-- INSERT INTO customers VALUES
-- (109, 'Test', 'User', 'aarav.s@email.com', 'Mumbai', 'Maharashtra', '2024-09-01', FALSE);
-- ERROR: Duplicate entry 'aarav.s@email.com' for key 'customers.email'


-- ============================================================================
-- Q6. Try inserting a product with unit_price = -50. What happens and which
--     constraint prevents it? Write both the INSERT statement and explain.
-- ============================================================================
-- ANSWER:
--
-- The CHECK constraint on the unit_price column prevents this:
--   CHECK (unit_price > 0)
--
-- This constraint ensures that no product can have a zero or negative price,
-- which would be logically invalid in an e-commerce context.
--
-- The database rejects the INSERT with an error like:
--   ERROR 3819 (HY000): Check constraint 'products_chk_1' is violated.

-- Demonstration: This INSERT will FAIL due to CHECK constraint
-- Uncomment the line below to see the error:

-- INSERT INTO products VALUES
-- (209, 'Invalid Product', 'Electronics', 'TestBrand', -50.00, 100);
-- ERROR: Check constraint 'products_chk_1' is violated.

-- The CHECK (unit_price > 0) constraint ensures data integrity by
-- preventing nonsensical negative prices from entering the database.


/* ============================================================================
   ╔══════════════════════════════════════════════════════════════════════════╗
   ║       SECTION B — Filtering & Optimization (WHERE, Indexes)           ║
   ║       Questions 7 – 12                                                ║
   ╚══════════════════════════════════════════════════════════════════════════╝
   ============================================================================ */


-- ============================================================================
-- Q7. Retrieve all orders with status = 'Delivered'.
-- ============================================================================
-- EXPLANATION:
--   The WHERE clause filters rows that match the condition.
--   Only rows where the status column exactly equals 'Delivered' are returned.
--   The index idx_orders_status speeds up this lookup.

SELECT *
FROM orders
WHERE status = 'Delivered';

-- Expected Output:
-- +----------+-------------+------------+-----------+--------------+
-- | order_id | customer_id | order_date | status    | total_amount |
-- +----------+-------------+------------+-----------+--------------+
-- |     1001 |         101 | 2024-08-01 | Delivered |      2998.00 |
-- |     1002 |         102 | 2024-08-05 | Delivered |      4599.00 |
-- |     1005 |         105 | 2024-08-15 | Delivered |      5998.00 |
-- |     1008 |         108 | 2024-08-22 | Delivered |      1299.00 |
-- |     1010 |         103 | 2024-09-01 | Delivered |       899.00 |
-- +----------+-------------+------------+-----------+--------------+


-- ============================================================================
-- Q8. Find all products in the 'Electronics' category with unit_price > 2000.
-- ============================================================================
-- EXPLANATION:
--   We use AND to combine two conditions:
--     1. category = 'Electronics'  — filters by category
--     2. unit_price > 2000         — filters by price
--   Both conditions must be TRUE for a row to appear in results.
--   The index idx_products_category helps with the first condition.

SELECT *
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;

-- Expected Output:
-- +------------+--------------------+-------------+-------+------------+-----------+
-- | product_id | product_name       | category    | brand | unit_price | stock_qty |
-- +------------+--------------------+-------------+-------+------------+-----------+
-- |        203 | Smart Watch        | Electronics | Noise |    2999.00 |       150 |
-- |        205 | Bluetooth Speaker  | Electronics | JBL   |    3499.00 |       200 |
-- +------------+--------------------+-------------+-------+------------+-----------+


-- ============================================================================
-- Q9. List all customers who joined in 2024 and belong to state 'Maharashtra'.
-- ============================================================================
-- EXPLANATION:
--   We use the YEAR() function to extract the year from the join_date column.
--   The AND operator ensures both conditions must be satisfied.
--   Alternative: join_date BETWEEN '2024-01-01' AND '2024-12-31'
--   (the BETWEEN approach is index-friendly — see Q12 for why).

SELECT *
FROM customers
WHERE YEAR(join_date) = 2024
  AND state = 'Maharashtra';

-- Expected Output:
-- +-------------+------------+-----------+--------------------+--------+-------------+------------+------------+
-- | customer_id | first_name | last_name | email              | city   | state       | join_date  | is_premium |
-- +-------------+------------+-----------+--------------------+--------+-------------+------------+------------+
-- |         101 | Aarav      | Sharma    | aarav.s@email.com  | Mumbai | Maharashtra | 2024-01-15 |          1 |
-- |         107 | Karan      | Mehta     | karan.m@email.com  | Pune   | Maharashtra | 2024-07-22 |          1 |
-- +-------------+------------+-----------+--------------------+--------+-------------+------------+------------+


-- ============================================================================
-- Q10. Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive)
--      that are NOT cancelled.
-- ============================================================================
-- EXPLANATION:
--   BETWEEN is inclusive on both ends (includes the start and end dates).
--   The != operator (or <>) excludes cancelled orders.
--   We could also write: status NOT IN ('Cancelled')
--   The index idx_orders_date helps the database quickly locate rows
--   within the date range without scanning the entire table.

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status != 'Cancelled';

-- Expected Output:
-- +----------+-------------+------------+-----------+--------------+
-- | order_id | customer_id | order_date | status    | total_amount |
-- +----------+-------------+------------+-----------+--------------+
-- |     1003 |         103 | 2024-08-10 | Shipped   |      1499.00 |
-- |     1004 |         104 | 2024-08-12 | Pending   |      3798.00 |
-- |     1005 |         105 | 2024-08-15 | Delivered |      5998.00 |
-- |     1007 |         107 | 2024-08-20 | Shipped   |      6998.00 |
-- |     1008 |         108 | 2024-08-22 | Delivered |      1299.00 |
-- |     1009 |         101 | 2024-08-25 | Pending   |      4498.00 |
-- +----------+-------------+------------+-----------+--------------+
-- Note: Order 1006 (2024-08-18, Cancelled) is excluded by the status filter.


-- ============================================================================
-- Q11. Explain what the index idx_orders_date does. How would it improve
--      performance? Write a sample query that benefits from this index.
-- ============================================================================
-- ANSWER (Theoretical + Practical):
--
-- WHAT IS idx_orders_date?
--   CREATE INDEX idx_orders_date ON orders(order_date);
--   This creates a B-Tree index on the order_date column of the orders table.
--
-- HOW IT WORKS:
--   Without an index, the database must perform a FULL TABLE SCAN — reading
--   every single row to check if order_date matches the condition.
--   With an index, the database uses the B-Tree structure to jump directly
--   to the relevant rows, like using a book's index to find a topic instead
--   of reading every page.
--
-- PERFORMANCE IMPROVEMENT:
--   ┌──────────────────────┬─────────────────┬──────────────────┐
--   │ Scenario             │ Without Index   │ With Index       │
--   ├──────────────────────┼─────────────────┼──────────────────┤
--   │ 10 orders            │ Scans 10 rows   │ Scans ~2 rows    │
--   │ 1,000,000 orders     │ Scans 1M rows   │ Scans ~20 rows   │
--   │ Time Complexity      │ O(n)            │ O(log n)         │
--   └──────────────────────┴─────────────────┴──────────────────┘
--
-- SAMPLE QUERY that benefits from this index:

SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date = '2024-08-15';

-- The database uses idx_orders_date to instantly locate the row(s)
-- with order_date = '2024-08-15' instead of scanning all rows.

-- Another example with a range scan:
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY order_date;


-- ============================================================================
-- Q12. If you run: SELECT * FROM customers WHERE YEAR(join_date) = 2024;
--      Would the index on join_date be used? Explain and rewrite to be
--      index-friendly (SARGable).
-- ============================================================================
-- ANSWER (Theoretical):
--
-- NO, the index on join_date would NOT be used!
--
-- WHY?
--   The YEAR() function wraps the column in a function call. This transforms
--   the column value before comparison, which prevents the database from
--   using the B-Tree index. The database cannot look up "YEAR(join_date)"
--   in an index built on "join_date" — the index stores raw date values,
--   not computed years.
--
--   This is called a "non-SARGable" query.
--   SARG = Search ARGument — a condition the index can directly satisfy.
--
-- NON-SARGABLE (bad — full table scan):
--   SELECT * FROM customers WHERE YEAR(join_date) = 2024;
--
-- SARGABLE (good — uses the index):

SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date <  '2025-01-01';

-- WHY THIS IS BETTER:
--   The conditions directly compare the raw join_date column values
--   against constants. The B-Tree index on join_date can efficiently
--   locate the range [2024-01-01, 2025-01-01) without scanning every row.
--
--   Rule of thumb: Never wrap an indexed column inside a function in
--   the WHERE clause. Instead, transform the constant/comparison value.
--
-- Expected Output: Same result as Q9 (all 8 customers joined in 2024),
-- but now the query runs much faster on large tables.


/* ============================================================================
   ╔══════════════════════════════════════════════════════════════════════════╗
   ║     SECTION C — Aggregation (GROUP BY, SUM, COUNT, AVG, MIN, MAX)     ║
   ║     Questions 13 – 18                                                 ║
   ╚══════════════════════════════════════════════════════════════════════════╝
   ============================================================================ */


-- ============================================================================
-- Q13. Count the total number of orders in the orders table.
-- ============================================================================
-- EXPLANATION:
--   COUNT(*) counts all rows in the table, regardless of NULL values.
--   This is an aggregate function that returns a single scalar value.
--   We use an alias (total_orders) to give the output column a meaningful name.

SELECT COUNT(*) AS total_orders
FROM orders;

-- Expected Output:
-- +--------------+
-- | total_orders |
-- +--------------+
-- |           10 |
-- +--------------+


-- ============================================================================
-- Q14. Find the total revenue (SUM of total_amount) from all 'Delivered' orders.
-- ============================================================================
-- EXPLANATION:
--   SUM() adds up all values in the specified column.
--   The WHERE clause first filters to only 'Delivered' orders, THEN
--   SUM() aggregates the total_amount of those filtered rows.
--   ROUND() formats the result to 2 decimal places for currency display.

SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE status = 'Delivered';

-- Expected Output:
-- +---------------+
-- | total_revenue |
-- +---------------+
-- |      15793.00 |
-- +---------------+
-- Breakdown: 2998 + 4599 + 5998 + 1299 + 899 = 15,793.00


-- ============================================================================
-- Q15. Calculate the average unit_price of products in each category.
-- ============================================================================
-- EXPLANATION:
--   GROUP BY groups rows that share the same category value.
--   AVG() calculates the average unit_price within each group.
--   Each category produces one row in the output.
--   ROUND(..., 2) ensures we get exactly 2 decimal places.

SELECT
    category,
    ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category;

-- Expected Output:
-- +-------------+-----------+
-- | category    | avg_price |
-- +-------------+-----------+
-- | Electronics |   2224.00 |
-- | Clothing    |   2699.00 |
-- | Home        |    949.00 |
-- +-------------+-----------+
-- Electronics: (1499 + 2999 + 3499 + 899) / 4 = 2224.00
-- Clothing:    (799 + 4599) / 2 = 2699.00
-- Home:        (1299 + 599) / 2 = 949.00


-- ============================================================================
-- Q16. For each order status, find the count of orders and the total revenue.
--      Sort the result by total revenue in descending order.
-- ============================================================================
-- EXPLANATION:
--   GROUP BY status creates one group per unique status value.
--   COUNT(*) counts orders in each group.
--   SUM(total_amount) totals the revenue per status.
--   ORDER BY ... DESC sorts from highest revenue to lowest.

SELECT
    status,
    COUNT(*)                    AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- Expected Output:
-- +-----------+-------------+---------------+
-- | status    | order_count | total_revenue |
-- +-----------+-------------+---------------+
-- | Delivered |           5 |      15793.00 |
-- | Shipped   |           2 |       8497.00 |
-- | Pending   |           2 |       8296.00 |
-- | Cancelled |           1 |        799.00 |
-- +-----------+-------------+---------------+


-- ============================================================================
-- Q17. Find the most expensive (MAX) and cheapest (MIN) product in each category.
-- ============================================================================
-- EXPLANATION:
--   MAX(unit_price) returns the highest price within each category group.
--   MIN(unit_price) returns the lowest price within each category group.
--   These aggregate functions work within each GROUP BY partition.

SELECT
    category,
    MAX(unit_price) AS most_expensive,
    MIN(unit_price) AS cheapest
FROM products
GROUP BY category;

-- Expected Output:
-- +-------------+----------------+----------+
-- | category    | most_expensive | cheapest |
-- +-------------+----------------+----------+
-- | Electronics |        3499.00 |   899.00 |
-- | Clothing    |        4599.00 |   799.00 |
-- | Home        |        1299.00 |   599.00 |
-- +-------------+----------------+----------+


-- ============================================================================
-- Q18. List all product categories where the average unit_price > ₹2000.
--      (Hint: Use HAVING clause)
-- ============================================================================
-- EXPLANATION:
--   HAVING filters groups AFTER aggregation (unlike WHERE which filters
--   individual rows BEFORE grouping).
--
--   Execution order:
--     1. FROM products         — start with all rows
--     2. GROUP BY category     — group rows by category
--     3. AVG(unit_price)       — calculate average per group
--     4. HAVING AVG(...) > 2000 — keep only groups meeting the condition
--
--   WHERE vs HAVING:
--     WHERE:  Filters rows BEFORE GROUP BY  (cannot use aggregate functions)
--     HAVING: Filters groups AFTER GROUP BY (CAN use aggregate functions)

SELECT
    category,
    ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

-- Expected Output:
-- +-------------+-----------+
-- | category    | avg_price |
-- +-------------+-----------+
-- | Electronics |   2224.00 |
-- | Clothing    |   2699.00 |
-- +-------------+-----------+
-- Home (avg 949.00) is excluded because 949 < 2000.


/* ============================================================================
   ╔══════════════════════════════════════════════════════════════════════════╗
   ║             SECTION D — Joins & Relationships                         ║
   ║             Questions 19 – 23                                         ║
   ╚══════════════════════════════════════════════════════════════════════════╝
   ============================================================================ */


-- ============================================================================
-- Q19. Write an INNER JOIN query to display each order along with the
--      customer's first_name and last_name.
--      Show: order_id, order_date, first_name, last_name, total_amount
-- ============================================================================
-- EXPLANATION:
--   INNER JOIN returns only rows where there is a matching record in BOTH tables.
--   The ON clause specifies the join condition: orders.customer_id = customers.customer_id
--   Every order has a valid customer_id (enforced by the FOREIGN KEY), so INNER JOIN
--   returns all 10 orders here. If an order had a customer_id not in customers
--   (impossible due to FK), it would be excluded.

SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Expected Output:
-- +----------+------------+------------+-----------+--------------+
-- | order_id | order_date | first_name | last_name | total_amount |
-- +----------+------------+------------+-----------+--------------+
-- |     1001 | 2024-08-01 | Aarav      | Sharma    |      2998.00 |
-- |     1002 | 2024-08-05 | Priya      | Patel     |      4599.00 |
-- |     1003 | 2024-08-10 | Rohan      | Gupta     |      1499.00 |
-- |     1004 | 2024-08-12 | Sneha      | Reddy     |      3798.00 |
-- |     1005 | 2024-08-15 | Vikram     | Singh     |      5998.00 |
-- |     1006 | 2024-08-18 | Ananya     | Iyer      |       799.00 |
-- |     1007 | 2024-08-20 | Karan      | Mehta     |      6998.00 |
-- |     1008 | 2024-08-22 | Divya      | Nair      |      1299.00 |
-- |     1009 | 2024-08-25 | Aarav      | Sharma    |      4498.00 |
-- |     1010 | 2024-09-01 | Rohan      | Gupta     |       899.00 |
-- +----------+------------+------------+-----------+--------------+


-- ============================================================================
-- Q20. Using a LEFT JOIN, list ALL customers and their orders (if any).
--      Customers with no orders should still appear with NULL values.
-- ============================================================================
-- EXPLANATION:
--   LEFT JOIN (or LEFT OUTER JOIN) returns ALL rows from the LEFT table
--   (customers) even if there is no matching row in the RIGHT table (orders).
--   Non-matching rows get NULL in the order columns.
--
--   In our data, customers 104 (Sneha) and 106 (Ananya) each have 1 order,
--   while ALL customers have at least one order. So no NULLs appear here,
--   but the query structure ensures they WOULD appear if a customer had
--   no orders.

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Expected Output (all customers appear, even if they had no orders):
-- +-------------+------------+-----------+----------+------------+--------------+
-- | customer_id | first_name | last_name | order_id | order_date | total_amount |
-- +-------------+------------+-----------+----------+------------+--------------+
-- |         101 | Aarav      | Sharma    |     1001 | 2024-08-01 |      2998.00 |
-- |         101 | Aarav      | Sharma    |     1009 | 2024-08-25 |      4498.00 |
-- |         102 | Priya      | Patel     |     1002 | 2024-08-05 |      4599.00 |
-- |         103 | Rohan      | Gupta     |     1003 | 2024-08-10 |      1499.00 |
-- |         103 | Rohan      | Gupta     |     1010 | 2024-09-01 |       899.00 |
-- |         104 | Sneha      | Reddy     |     1004 | 2024-08-12 |      3798.00 |
-- |         105 | Vikram     | Singh     |     1005 | 2024-08-15 |      5998.00 |
-- |         106 | Ananya     | Iyer      |     1006 | 2024-08-18 |       799.00 |
-- |         107 | Karan      | Mehta     |     1007 | 2024-08-20 |      6998.00 |
-- |         108 | Divya      | Nair      |     1008 | 2024-08-22 |      1299.00 |
-- +-------------+------------+-----------+----------+------------+--------------+
-- NOTE: If a customer had NO orders, their row would show:
--       | 109 | Test | User | NULL | NULL | NULL |


-- ============================================================================
-- Q21. Write a query using JOINs across three tables
--      (orders → order_items → products) to show:
--      order_id, product_name, quantity, unit_price, discount_pct
-- ============================================================================
-- EXPLANATION:
--   This is a multi-table JOIN that chains relationships:
--     orders ←→ order_items (via order_id)
--     order_items ←→ products (via product_id)
--
--   The query follows the foreign key path:
--     orders.order_id = order_items.order_id
--     order_items.product_id = products.product_id
--
--   We use table aliases (o, oi, p) for readability.
--   Note: oi.unit_price is the price AT TIME OF PURCHASE (may differ
--   from p.unit_price if prices change over time).

SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p     ON oi.product_id = p.product_id
ORDER BY o.order_id, oi.item_id;

-- Expected Output (15 rows):
-- +----------+----------------------+----------+------------+--------------+
-- | order_id | product_name         | quantity | unit_price | discount_pct |
-- +----------+----------------------+----------+------------+--------------+
-- |     1001 | Wireless Earbuds     |        2 |    1499.00 |         0.00 |
-- |     1002 | Running Shoes        |        1 |    4599.00 |         0.00 |
-- |     1002 | Bedsheet Set         |        1 |    1299.00 |        10.00 |
-- |     1003 | Wireless Earbuds     |        1 |    1499.00 |         5.00 |
-- |     1004 | Smart Watch          |        1 |    2999.00 |         0.00 |
-- |     1004 | Cotton T-Shirt       |        1 |     799.00 |         0.00 |
-- |     1005 | Smart Watch          |        2 |    2999.00 |         0.00 |
-- |     1005 | Laptop Stand         |        1 |     899.00 |        10.00 |
-- |     1006 | Cotton T-Shirt       |        1 |     799.00 |         0.00 |
-- |     1007 | Bluetooth Speaker    |        2 |    3499.00 |         5.00 |
-- |     1007 | Cushion Covers (Set) |        3 |     599.00 |         0.00 |
-- |     1008 | Bedsheet Set         |        1 |    1299.00 |         0.00 |
-- |     1009 | Wireless Earbuds     |        1 |    1499.00 |         0.00 |
-- |     1009 | Smart Watch          |        1 |    2999.00 |        10.00 |
-- |     1010 | Laptop Stand         |        1 |     899.00 |         0.00 |
-- +----------+----------------------+----------+------------+--------------+


-- ============================================================================
-- Q22. Explain the difference between LEFT JOIN and RIGHT JOIN with an
--      example from this schema. When would you use a FULL OUTER JOIN?
-- ============================================================================
-- ANSWER (Theoretical + Examples):
--
-- ┌───────────────┬──────────────────────────────────────────────────────┐
-- │ JOIN Type     │ What It Returns                                    │
-- ├───────────────┼──────────────────────────────────────────────────────┤
-- │ INNER JOIN    │ Only rows with matches in BOTH tables              │
-- │ LEFT JOIN     │ ALL rows from LEFT table + matching from RIGHT     │
-- │ RIGHT JOIN    │ ALL rows from RIGHT table + matching from LEFT     │
-- │ FULL OUTER    │ ALL rows from BOTH tables (NULLs where no match)   │
-- └───────────────┴──────────────────────────────────────────────────────┘
--
-- LEFT JOIN Example:
--   "Show ALL customers, even if they have no orders"
--   customers LEFT JOIN orders → Every customer appears; if no order
--   exists, order columns are NULL.
--
-- RIGHT JOIN Example:
--   "Show ALL orders, even if the customer record is somehow missing"
--   customers RIGHT JOIN orders → Every order appears; if no matching
--   customer exists, customer columns are NULL.
--
-- FULL OUTER JOIN:
--   Used when you need ALL records from BOTH tables, even unmatched ones.
--   Example: Merging two datasets (e.g., online orders + in-store orders)
--   where some customers exist only in one system.
--   Note: MySQL does not natively support FULL OUTER JOIN. You can
--   simulate it with: LEFT JOIN UNION RIGHT JOIN.

-- LEFT JOIN example:
SELECT c.first_name, c.last_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN example (equivalent to swapping table order with LEFT JOIN):
SELECT c.first_name, c.last_name, o.order_id, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


-- ============================================================================
-- Q23. Identify all Foreign Key relationships in the schema. Explain what
--      would happen if you tried to insert an order with customer_id = 999.
-- ============================================================================
-- ANSWER (Theoretical):
--
-- FOREIGN KEY RELATIONSHIPS:
--   ┌─────────────────────────────────┬───────────────────────────────────────┐
--   │ Foreign Key Column              │ References (Parent Table)             │
--   ├─────────────────────────────────┼───────────────────────────────────────┤
--   │ orders.customer_id              │ customers.customer_id                 │
--   │ order_items.order_id            │ orders.order_id                       │
--   │ order_items.product_id          │ products.product_id                   │
--   └─────────────────────────────────┴───────────────────────────────────────┘
--
--   Entity Relationships:
--     customers  ──(1:N)──►  orders        (one customer has many orders)
--     orders     ──(1:N)──►  order_items   (one order has many items)
--     products   ──(1:N)──►  order_items   (one product in many order items)
--
-- WHAT HAPPENS with customer_id = 999?
--   The INSERT would FAIL with a Foreign Key constraint violation error:
--   ERROR 1452 (23000): Cannot add or update a child row: a foreign key
--   constraint fails (`ecommerce_db`.`orders`, CONSTRAINT `orders_ibfk_1`
--   FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`))
--
--   This is called REFERENTIAL INTEGRITY — it ensures every order belongs
--   to a real, existing customer. You cannot create an "orphan" order.

-- Demonstration: This INSERT will FAIL (uncomment to test):
-- INSERT INTO orders VALUES (1011, 999, '2024-09-15', 'Pending', 500.00);
-- ERROR: Foreign key constraint fails — customer_id 999 does not exist.


/* ============================================================================
   ╔══════════════════════════════════════════════════════════════════════════╗
   ║      SECTION E — Advanced Concepts (CASE, ACID, Transactions)         ║
   ║      Questions 24 – 27                                                ║
   ╚══════════════════════════════════════════════════════════════════════════╝
   ============================================================================ */


-- ============================================================================
-- Q24. Write a query using CASE to classify products into price tiers:
--        'Budget'    → unit_price < 1000
--        'Mid-Range' → unit_price BETWEEN 1000 AND 3000
--        'Premium'   → unit_price > 3000
--      Display: product_name, unit_price, price_tier
-- ============================================================================
-- EXPLANATION:
--   The CASE expression works like an IF-ELSE chain:
--     - It evaluates conditions top-to-bottom
--     - Returns the value for the FIRST matching condition
--     - ELSE handles anything not caught by previous conditions
--   This is useful for creating derived/calculated columns on-the-fly
--   without modifying the actual table data.

SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 1000                      THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000       THEN 'Mid-Range'
        WHEN unit_price > 3000                      THEN 'Premium'
    END AS price_tier
FROM products
ORDER BY unit_price;

-- Expected Output:
-- +----------------------+------------+------------+
-- | product_name         | unit_price | price_tier |
-- +----------------------+------------+------------+
-- | Cushion Covers (Set) |     599.00 | Budget     |
-- | Cotton T-Shirt       |     799.00 | Budget     |
-- | Laptop Stand         |     899.00 | Budget     |
-- | Bedsheet Set         |    1299.00 | Mid-Range  |
-- | Wireless Earbuds     |    1499.00 | Mid-Range  |
-- | Smart Watch          |    2999.00 | Mid-Range  |
-- | Bluetooth Speaker    |    3499.00 | Premium    |
-- | Running Shoes        |    4599.00 | Premium    |
-- +----------------------+------------+------------+


-- ============================================================================
-- Q25. Using a CASE statement inside an aggregate function, count how many
--      orders are 'Delivered' vs 'Not Delivered' (all other statuses).
--      Display the result in a single row.
-- ============================================================================
-- EXPLANATION:
--   This technique is called "conditional aggregation" or "pivot by CASE".
--   
--   How it works:
--     SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END)
--     → For each row, if status is 'Delivered', add 1; otherwise add 0.
--     → The SUM gives us the total count of 'Delivered' orders.
--
--   This produces a SINGLE ROW with two columns — much cleaner than
--   using GROUP BY which would give multiple rows.

SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;

-- Alternative using COUNT (also valid):
-- SELECT
--     COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered_count,
--     COUNT(CASE WHEN status != 'Delivered' THEN 1 END) AS not_delivered_count
-- FROM orders;

-- Expected Output:
-- +-----------------+---------------------+
-- | delivered_count | not_delivered_count  |
-- +-----------------+---------------------+
-- |               5 |                   5 |
-- +-----------------+---------------------+
-- Delivered: 1001, 1002, 1005, 1008, 1010 = 5
-- Not Delivered: 1003(Shipped), 1004(Pending), 1006(Cancelled),
--               1007(Shipped), 1009(Pending) = 5


-- ============================================================================
-- Q26. Explain each letter of ACID with a real-world bank transfer example.
-- ============================================================================
-- ANSWER (Theoretical):
--
-- ACID is a set of 4 properties that guarantee database transactions are
-- processed reliably. Consider this example:
--   "Transfer ₹5000 from Account A to Account B"
--
-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ A — ATOMICITY ("All or Nothing")                                       │
-- ├──────────────────────────────────────────────────────────────────────────┤
-- │ The entire transaction is treated as a single, indivisible unit.       │
-- │ Either BOTH steps happen, or NEITHER happens.                          │
-- │                                                                        │
-- │ Example:                                                               │
-- │   Step 1: Deduct ₹5000 from Account A                                 │
-- │   Step 2: Add ₹5000 to Account B                                      │
-- │                                                                        │
-- │ If Step 2 fails (e.g., server crash), Step 1 is also ROLLED BACK.     │
-- │ Money doesn't just "disappear" from Account A.                         │
-- └──────────────────────────────────────────────────────────────────────────┘
--
-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ C — CONSISTENCY ("Valid State to Valid State")                          │
-- ├──────────────────────────────────────────────────────────────────────────┤
-- │ The database must move from one valid state to another valid state.    │
-- │ All constraints, rules, and triggers must be satisfied.                │
-- │                                                                        │
-- │ Example:                                                               │
-- │   Rule: Account balance cannot be negative.                            │
-- │   If Account A has ₹3000 and you try to transfer ₹5000,              │
-- │   the transaction is REJECTED because it would violate the rule.       │
-- │   The database stays in its original consistent state.                 │
-- └──────────────────────────────────────────────────────────────────────────┘
--
-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ I — ISOLATION ("Transactions Don't Interfere")                         │
-- ├──────────────────────────────────────────────────────────────────────────┤
-- │ Concurrent transactions execute as if they were running sequentially.  │
-- │ One transaction cannot see the intermediate state of another.          │
-- │                                                                        │
-- │ Example:                                                               │
-- │   Transaction 1: Transfer ₹5000 from A → B                           │
-- │   Transaction 2: Check balance of Account A                            │
-- │                                                                        │
-- │   Transaction 2 sees EITHER the old balance (before transfer) OR       │
-- │   the new balance (after transfer) — never a partially-deducted        │
-- │   intermediate state. This prevents "dirty reads".                     │
-- └──────────────────────────────────────────────────────────────────────────┘
--
-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ D — DURABILITY ("Committed = Permanent")                               │
-- ├──────────────────────────────────────────────────────────────────────────┤
-- │ Once a transaction is committed, the changes are permanent — even if   │
-- │ the system crashes, loses power, or encounters hardware failure.       │
-- │                                                                        │
-- │ Example:                                                               │
-- │   After the transfer is COMMITTED, the ₹5000 is permanently in        │
-- │   Account B. Even if the server crashes 1 millisecond after COMMIT,    │
-- │   when the system restarts, Account B still has the ₹5000.            │
-- │   This is achieved through Write-Ahead Logging (WAL).                  │
-- └──────────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- Q27. Write a SQL transaction that does the following atomically:
--   1. Insert a new order (order_id=1011, customer_id=102, today's date,
--      'Pending', 1598.00)
--   2. Insert two order items for that order
--   3. Update the stock_qty of the purchased products
--   4. If any step fails, ROLLBACK the entire transaction. Otherwise, COMMIT.
-- ============================================================================
-- EXPLANATION:
--   START TRANSACTION begins a new transaction block.
--   All statements inside are treated as a single atomic unit.
--   COMMIT saves all changes permanently.
--   If any statement fails, we ROLLBACK to undo ALL changes.
--
--   This ensures:
--     - The order, its items, and stock updates all succeed together
--     - OR none of them happen (no partial/inconsistent state)
--   This is ATOMICITY (the "A" in ACID) in action.

-- Using MySQL syntax with error handling:

START TRANSACTION;

-- Step 1: Insert the new order
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

-- Step 2: Insert two order items for order 1011
--   Item 1: 1× Wireless Earbuds (product_id=201, price=1499.00, no discount)
--   Item 2: 1× Cushion Covers   (product_id=208, price=599.00, discount=10%)
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (16, 1011, 201, 1, 1499.00, 0.00);

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (17, 1011, 208, 1, 599.00, 10.00);

-- Step 3: Update stock quantities (reduce by purchased quantity)
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 201;  -- Earbuds: 250 → 249
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 208;  -- Cushion: 400 → 399

-- Step 4: If we reach here without errors, COMMIT all changes
COMMIT;

-- VERIFICATION: Check that the transaction was successful
SELECT 'New Order Created:' AS info;
SELECT * FROM orders WHERE order_id = 1011;

SELECT 'Order Items Added:' AS info;
SELECT * FROM order_items WHERE order_id = 1011;

SELECT 'Updated Stock Quantities:' AS info;
SELECT product_id, product_name, stock_qty
FROM products
WHERE product_id IN (201, 208);

-- Expected Output after COMMIT:
-- orders:      (1011, 102, <today>, 'Pending', 1598.00)
-- order_items: item_id 16 (Earbuds), item_id 17 (Cushion Covers)
-- products:    Earbuds stock_qty = 249, Cushion Covers stock_qty = 399
--
-- IF ANY STEP FAILED:
--   Replace COMMIT with ROLLBACK; and no changes would be saved.
--   Example:
--     START TRANSACTION;
--     INSERT INTO orders ...;  -- succeeds
--     INSERT INTO order_items ...;  -- FAILS (e.g., duplicate item_id)
--     ROLLBACK;  -- undoes the order INSERT too!
--
-- In production applications, error handling is done in application code:
--   try {
--       START TRANSACTION;
--       ... SQL statements ...
--       COMMIT;
--   } catch (error) {
--       ROLLBACK;
--       throw error;
--   }


/* ============================================================================
   END OF ASSIGNMENT
   ============================================================================
   Summary of SQL Concepts Covered:
   
   Section A (Q1-Q6):   SELECT, *, DISTINCT, PRIMARY KEY, UNIQUE, CHECK, NOT NULL
   Section B (Q7-Q12):  WHERE, AND, BETWEEN, !=, YEAR(), Indexes, SARGability
   Section C (Q13-Q18): COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING, ROUND
   Section D (Q19-Q23): INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN,
                         Multi-table JOINs, Foreign Keys, Referential Integrity
   Section E (Q24-Q27): CASE, Conditional Aggregation, ACID Properties,
                         Transactions, START TRANSACTION, COMMIT, ROLLBACK
   ============================================================================ */
