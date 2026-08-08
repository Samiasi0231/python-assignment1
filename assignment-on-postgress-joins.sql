-- customers
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150),
    city          VARCHAR(80)
);

-- ------------------------------------------------------------
-- products
-- ------------------------------------------------------------
CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  VARCHAR(120) NOT NULL,
    category      VARCHAR(60),
    price         NUMERIC(12,2)
);

-- ------------------------------------------------------------
-- orders  (customer_id NOT enforced as FK on purpose)
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER,          -- may be NULL or point to a non-existent customer
    order_date    DATE,
    total_amount  NUMERIC(12,2)
);

-- ------------------------------------------------------------
-- order_items (order_id / product_id NOT enforced as FK on purpose)
-- ------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER,          -- may point to a non-existent order
    product_id    INTEGER,          -- may be NULL or point to a non-existent product
    quantity      INTEGER,
    unit_price    NUMERIC(12,2)
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- ---------------- customers ----------------
INSERT INTO customers (customer_id, name, email, city) VALUES
(1,  'Chinedu Okeke',      'chinedu.okeke@gmail.com',   'Lagos'),
(2,  'Amaka Eze',          'amaka.eze@yahoo.com',       'Enugu'),
(3,  'Tunde Bakare',       'tunde.bakare@gmail.com',    'Ibadan'),
(4,  'Ngozi Madu',         'ngozi.madu@outlook.com',    'Port Harcourt'),
(5,  'Ibrahim Sani',       'ibrahim.sani@gmail.com',    'Kano'),
(6,  'Funke Adeyemi',      'funke.adeyemi@gmail.com',   'Abeokuta'),
(7,  'Emeka Nwosu',        'emeka.nwosu@gmail.com',     'Onitsha'),
(8,  'Halima Bello',       'halima.bello@yahoo.com',    'Kaduna'),
-- customers 9 & 10 will have NO orders (for Q5)
(9,  'Olu Fadeyi',         'olu.fadeyi@gmail.com',      'Akure'),
(10, 'Zainab Yusuf',       'zainab.yusuf@gmail.com',    'Maiduguri');

-- ---------------- products ----------------
INSERT INTO products (product_id, product_name, category, price) VALUES
(101, 'Tecno Spark 20',        'Electronics',   145000.00),
(102, 'Itel Power Bank 20000', 'Electronics',    18500.00),
(103, 'HP Pavilion Laptop',    'Electronics',   650000.00),
(104, 'Ankara Fabric (6 yds)', 'Fashion',        12000.00),
(105, 'Leather Sandals',       'Fashion',        15500.00),
(106, 'Golden Penny Semovita', 'Groceries',       8500.00),
(107, 'Peak Milk Tin (carton)','Groceries',      14000.00),
(108, 'Office Swivel Chair',   'Furniture',      45000.00),
-- products 109 & 110 will be NEVER ordered (for Q6)
(109, 'Standing Desk',         'Furniture',     120000.00),
(110, 'Ceramic Dinner Set',    'Home',           22000.00);

-- ---------------- orders ----------------
-- Valid orders (customer exists)
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1001, 1, '2025-01-05', 163500.00),
(1002, 1, '2025-02-11', 650000.00),
(1003, 2, '2025-01-20',  27500.00),
(1004, 3, '2025-03-02', 145000.00),
(1005, 4, '2025-03-15',  22500.00),
(1006, 5, '2025-04-01',  59000.00),
(1007, 6, '2025-04-10',  14000.00),
(1008, 7, '2025-05-05',  31000.00),
(1009, 8, '2025-05-18',  45000.00),
-- INTENTIONAL ANOMALY: customer_id 999 does not exist (orphan order) — for Q3, Q4, Q7
(1010, 999, '2025-05-22', 18500.00),
-- INTENTIONAL ANOMALY: customer_id IS NULL (missing reference) — for Q3, Q4, Q7
(1011, NULL, '2025-05-25', 90000.00);

-- ---------------- order_items ----------------
-- Valid order_items (order + product both exist)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 101, 1, 145000.00),   -- Tecno Spark
(2, 1001, 102, 1,  18500.00),   -- Power Bank
(3, 1002, 103, 1, 650000.00),   -- HP Laptop
(4, 1003, 104, 1,  12000.00),   -- Ankara
(5, 1003, 105, 1,  15500.00),   -- Sandals
(6, 1004, 101, 1, 145000.00),   -- Tecno Spark
(7, 1005, 105, 1,  15500.00),   -- Sandals (Fashion) for Ngozi
(8, 1006, 108, 1,  45000.00),   -- Swivel Chair
(9, 1006, 102, 1,  18500.00),   -- Power Bank (NOTE qty/price create reconciliation diff for Q17)
(10,1007, 107, 1,  14000.00),   -- Peak Milk
(11,1008, 105, 2,  15500.00),   -- Sandals x2
(12,1009, 108, 1,  45000.00),   -- Swivel Chair
-- Electronics + other category for Chinedu (cust 1) already: order 1001 Electronics, need a non-Electronics too
(13,1002, 106, 2,   8500.00),   -- Semovita on order 1002 -> cust 1 now has Electronics + Groceries (Q18)
-- INTENTIONAL ANOMALY: order_id 8888 does not exist (orphan item) — for Q14, Q15
(14, 8888, 101, 1, 145000.00),
-- INTENTIONAL ANOMALY: product_id 7777 does not exist (invalid product) — for Q10, Q14, Q15
(15, 1004, 7777, 3, 10000.00),
-- INTENTIONAL ANOMALY: product_id IS NULL (missing product) — for Q10, Q14
(16, 1007, NULL, 1, 5000.00);
select * from customers
select * from products
--Only customers who have orders → INNER JOIN

SELECT
    c.name AS customer_name,
    o.order_id,
    o.order_date
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

--Question 2: Complete Customer List
SELECT
    c.name,
    c.email,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
--Question 4: Complete Relationship View
SELECT
    c.customer_id,
    c.name AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
FULL OUTER JOIN orders o
    ON c.customer_id = o.customer_id;
--Q5. Customers Without Orders
SELECT
    c.name,
    c.email,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
--Q6. Products Never Ordered
SELECT
    p.product_name,
    p.category,
    p.price
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
--Q7. Orders Missing Customer Data
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.total_amount
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
--Valid Purchases Only
SELECT
    c.name AS customer_name,
    o.order_date,
    p.product_name
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;
--Q9. All Customers with Valid Products
SELECT
    c.name AS customer_name,
    o.order_date,
    p.product_name,
    oi.quantity
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;
--Q10. Complete Order Details with Missing Data Handling
SELECT
    COALESCE(c.name, 'Unknown Customer') AS customer_name,
    o.order_date,
    COALESCE(p.product_name, 'Unknown Product') AS product_name,
    p.category,
    oi.quantity,
    oi.unit_price
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON oi.product_id = p.product_id;
--Q11. Customer Order Statistics
SELECT
    c.name AS customer_name,
    COUNT(o.order_id) AS number_of_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_amount_spent
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;
--Q12. Product Sales Summary
SELECT
    p.product_name,
    p.category,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY p.product_id;
--Q13. Category Performance Analysis
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT CASE
        WHEN oi.order_item_id IS NOT NULL
        THEN p.product_id
    END) AS products_sold,
    COUNT(DISTINCT CASE
        WHEN oi.order_item_id IS NULL
        THEN p.product_id
    END) AS products_unsold
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY p.category;
--Q14. Orphaned Records Report
SELECT
    (
        SELECT COUNT(*)
        FROM orders o
        LEFT JOIN customers c
            ON o.customer_id = c.customer_id
        WHERE c.customer_id IS NULL
    ) AS orders_without_valid_customers,

    (
        SELECT COUNT(*)
        FROM order_items oi
        LEFT JOIN orders o
            ON oi.order_id = o.order_id
        WHERE o.order_id IS NULL
    ) AS items_without_valid_orders,

    (
        SELECT COUNT(*)
        FROM order_items oi
        LEFT JOIN products p
            ON oi.product_id = p.product_id
        WHERE p.product_id IS NULL
    ) AS items_without_valid_products;
--Q15. Complete Data Integrity Check
SELECT
    'Customer with no orders' AS issue_type,
    c.name AS record_description
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order without valid customer' AS issue_type,
    CAST(o.order_id AS VARCHAR) AS record_description
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Product with no sales' AS issue_type,
    p.product_name AS record_description
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL

UNION ALL

SELECT
    'Order item with invalid order' AS issue_type,
    CAST(oi.order_item_id AS VARCHAR) AS record_description
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order item with invalid product' AS issue_type,
    CAST(oi.order_item_id AS VARCHAR) AS record_description
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

--Q16. Customer Purchase Diversity
SELECT
    c.name AS customer_name,
    COUNT(DISTINCT p.category) AS category_count,
    STRING_AGG(DISTINCT p.category, ', ' ORDER BY p.category)
        AS categories
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;
--Q17. Revenue Reconciliation
SELECT
    o.order_id,
    o.total_amount AS stated_total,
    SUM(oi.quantity * oi.unit_price) AS calculated_total,
    o.total_amount - SUM(oi.quantity * oi.unit_price) AS difference
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.total_amount
ORDER BY o.order_id;
--Q18. Complex Relationship Analysis
SELECT
    c.name AS customer_name,
    STRING_AGG(
        DISTINCT p.category,
        ', '
        ORDER BY p.category
    ) AS categories_ordered
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
HAVING
    COUNT(DISTINCT CASE
        WHEN p.category = 'Electronics'
        THEN p.category
    END) > 0
    AND COUNT(DISTINCT p.category) > 1;