--Calculate the total amount spent by each customer. Sort by total spend in descending order.SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name, c.email, COALESCE(SUM(s.total_amount), 0.00) AS total_spend FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id GROUP BY c.customer_id, c.first_name, c.last_name, c.email ORDER BY total_spend DESC;
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
c.email,
COALESCE(SUM(s.total_amount),
0.00) AS total_spend
FROM customers c LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name, 
c.email 
ORDER BY total_spend DESC;
--Find the average rating given by customers in each loyalty tier. Does loyalty tier correlate with how customers rate products?
SELECT c.loyalty_tier,
ROUND(AVG(pr.rating), 2)
AS average_rating,
COUNT(pr.review_id)
AS number_of_reviews
FROM customers c JOIN 
product_reviews pr ON c.customer_id = pr.customer_id
GROUP BY c.loyalty_tier 
ORDER BY average_rating DESC;
--Identify customers who have made purchases but have never left a product review.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM product_reviews pr
    WHERE pr.customer_id = c.customer_id
)
ORDER BY c.customer_id;
--Which customers have increased their spending in the second quarter of 2023 compared to the first quarter?
WITH customer_quarterly_spending AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.email,

        COALESCE(
            SUM(
             CASE WHEN s.sale_date >= '2023-01-01'
             AND s.sale_date < '2023-04-01'
              THEN s.total_amount
               ELSE 0
                END
            ),
            0
        ) AS q1_spending,

        COALESCE(
            SUM(
                CASE
                    WHEN s.sale_date >= '2023-04-01'
                     AND s.sale_date < '2023-07-01'
                    THEN s.total_amount
                    ELSE 0
                END
            ),
            0
        ) AS q2_spending

    FROM customers c
    LEFT JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email
)

SELECT
    customer_id,
    customer_name,
    email,
    ROUND(q1_spending, 2) AS q1_spending,
    ROUND(q2_spending, 2) AS q2_spending,
    ROUND(q2_spending - q1_spending, 2) AS increase_amount
FROM customer_quarterly_spending
WHERE q2_spending > q1_spending
ORDER BY increase_amount DESC;

---What are the favorite product categories for Gold tier customers based on their purchase history?
WITH gold_category_sales AS (
    SELECT
        c.category_id,
        c.category_name,
        SUM(si.quantity) AS total_quantity_purchased
    FROM customers cu
    JOIN sales s
        ON cu.customer_id = s.customer_id
    JOIN sale_items si
        ON s.sale_id = si.sale_id
    JOIN products p
        ON si.product_id = p.product_id
    JOIN categories c
        ON p.category_id = c.category_id
    WHERE cu.loyalty_tier = 'Gold'
    GROUP BY
        c.category_id,
        c.category_name
),

ranked_categories AS (
    SELECT
        category_id,
        category_name,
        total_quantity_purchased,
        RANK() OVER (
            ORDER BY total_quantity_purchased DESC
        ) AS category_rank
    FROM gold_category_sales
)

SELECT
    category_id,
    category_name,
    total_quantity_purchased,
    category_rank
FROM ranked_categories
WHERE category_rank = 1
ORDER BY category_name;
