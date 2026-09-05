--What is the total sales amount for each store? Show the store name, region, and total sales.
SELECT
    st.store_name,
    st.region,
    COALESCE(SUM(sa.total_amount), 0) AS total_sales
FROM stores st
LEFT JOIN sales sa
    ON st.store_id = sa.store_id
GROUP BY
    st.store_id,
    st.store_name,
    st.region
ORDER BY total_sales DESC;
--Total sales and transaction count for each month of 2023
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    SUM(total_amount) AS total_sales,
    COUNT(sale_id) AS transaction_count
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;

--Which product categories generate the most revenue? Rank categories by total sales amount.
SELECT
    c.category_name,
    COALESCE(SUM(si.quantity * si.price_sold), 0) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(si.quantity * si.price_sold) DESC
    ) AS revenue_rank
FROM categories c
LEFT JOIN products p
    ON c.category_id = p.category_id
LEFT JOIN sale_items si
    ON p.product_id = si.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY revenue_rank;
---Identify the top 5 most frequently purchased products along with their total quantity sold.
SELECT
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM products p
JOIN sale_items si
    ON p.product_id = si.product_id
WHERE si.sale_id IS NOT NULL
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;
--For each customer, list their name, email, number of purchases, and the date of their most recent purchase.
SELECT
    c.first_name,
    c.last_name,
    c.email,
    COUNT(s.sale_id) AS number_of_purchases,
    MAX(s.sale_date) AS most_recent_purchase
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
ORDER BY number_of_purchases DESC;

