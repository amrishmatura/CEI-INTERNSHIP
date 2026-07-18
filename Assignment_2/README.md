# 📊 SQL Assignment — E-Commerce Database Queries

> **Database**: Indian E-Commerce Sample (MySQL 8.0+)  
> **Total Questions**: 27 (Sections A through E)  
> **File**: [`sql_assignment_complete.sql`](./sql_assignment_complete.sql)

This repository contains a comprehensive SQL assignment demonstrating various database operations, from basic queries to advanced concepts like conditional aggregation and transactions.

---

## 📋 Table of Contents

1. [How to Run](#-how-to-run)
2. [Database Schema](#-database-schema)
3. [Entity Relationships](#-entity-relationships)
4. [SQL Concepts Covered](#-sql-concepts-covered)

---

## 🚀 How to Run

### Prerequisites
- MySQL 8.0+ (or MySQL Workbench / phpMyAdmin / DBeaver)

### Steps

**Option 1: Interactive MySQL Prompt**
```bash
# Step 1: Log into MySQL
mysql -u root -p

# Step 2: Create database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

# Step 3: Run the complete SQL file
SOURCE /path/to/sql_assignment_complete.sql;
```

**Option 2: Generate Formatted Output File (Recommended for Review)**
You can run the script from your terminal (like PowerShell or Bash) and save the output to a text file:

```bash
# First, ensure the database is created
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ecommerce_db;"

# Then run the script with table (-t) and very verbose (-vvv) flags
mysql -t -vvv -u root -p ecommerce_db < sql_assignment_complete.sql > output.txt
```
*(Open `output.txt` to see all executed queries, comments, and results neatly formatted!)*

Or copy-paste the entire contents of `sql_assignment_complete.sql` into your MySQL client (like Workbench) and execute.

### What the file does (in order):
1. **Drops** existing tables (safe for re-runs)
2. **Creates** 4 tables with constraints, PKs, and FKs
3. **Creates** indexes for performance
4. **Inserts** sample data (8 customers, 8 products, 10 orders, 15 order items)
5. **Verifies** data load with a count check
6. **Executes** all 27 queries with expected outputs in comments

---

## 🗄️ Database Schema

### Table: `customers`
| Column | Type | Constraints |
|---|---|---|
| `customer_id` | INT | **PRIMARY KEY** |
| `first_name` | VARCHAR(50) | NOT NULL |
| `last_name` | VARCHAR(50) | NOT NULL |
| `email` | VARCHAR(100) | **UNIQUE**, NOT NULL |
| `city` | VARCHAR(50) | NOT NULL |
| `state` | VARCHAR(50) | NOT NULL |
| `join_date` | DATE | NOT NULL |
| `is_premium` | BOOLEAN | DEFAULT FALSE |

### Table: `products`
| Column | Type | Constraints |
|---|---|---|
| `product_id` | INT | **PRIMARY KEY** |
| `product_name` | VARCHAR(100) | NOT NULL |
| `category` | VARCHAR(50) | NOT NULL |
| `brand` | VARCHAR(50) | NOT NULL |
| `unit_price` | DECIMAL(10,2) | NOT NULL, CHECK (> 0) |
| `stock_qty` | INT | NOT NULL, DEFAULT 0, CHECK (>= 0) |

### Table: `orders`
| Column | Type | Constraints |
|---|---|---|
| `order_id` | INT | **PRIMARY KEY** |
| `customer_id` | INT | NOT NULL, **FK → customers** |
| `order_date` | DATE | NOT NULL |
| `status` | VARCHAR(20) | NOT NULL, DEFAULT 'Pending', CHECK IN (...) |
| `total_amount` | DECIMAL(12,2) | NOT NULL, CHECK (>= 0) |

### Table: `order_items`
| Column | Type | Constraints |
|---|---|---|
| `item_id` | INT | **PRIMARY KEY** |
| `order_id` | INT | NOT NULL, **FK → orders** |
| `product_id` | INT | NOT NULL, **FK → products** |
| `quantity` | INT | NOT NULL, CHECK (> 0) |
| `unit_price` | DECIMAL(10,2) | NOT NULL, CHECK (> 0) |
| `discount_pct` | DECIMAL(5,2) | DEFAULT 0, CHECK (0–100) |

---

## 🔗 Entity Relationships
- **customers** (1) ── (N) **orders**
- **orders** (1) ── (N) **order_items**
- **products** (1) ── (N) **order_items**

---

## 📚 SQL Concepts Covered

The assignment covers a wide range of SQL topics, structured progressively:

- **Section A:** `SELECT`, `DISTINCT`, Constraints (`PRIMARY KEY`, `UNIQUE`, `CHECK`, `NOT NULL`)
- **Section B:** Filtering (`WHERE`, `AND`, `BETWEEN`, `!=`), Date Functions (`YEAR()`), Indexes, and SARGability
- **Section C:** Aggregation (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), `GROUP BY`, `HAVING`, Formatting (`ROUND`)
- **Section D:** Relational joins (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`), Multi-table Joins, Referential Integrity
- **Section E:** Advanced Concepts (`CASE`, Conditional Aggregation), ACID Properties, Transactions (`START TRANSACTION`, `COMMIT`, `ROLLBACK`)

Detailed queries and explanations for all concepts can be found in the [`sql_assignment_complete.sql`](./sql_assignment_complete.sql) file.
