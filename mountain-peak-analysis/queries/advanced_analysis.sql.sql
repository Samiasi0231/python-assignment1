--Calculate the total sales amount and number of transactions for each employee. Who are the top-performing sales associates?
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.position,
    COALESCE(SUM(s.total_amount), 0.00) AS total_sales_amount,
    COUNT(s.sale_id) AS number_of_transactions
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.position
ORDER BY
    total_sales_amount DESC;
--Find the average transaction value for each employee. Who generates the highest average sale amount?
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.position,
    COUNT(s.sale_id) AS number_of_transactions,
    ROUND(
        COALESCE(AVG(s.total_amount), 0),
        2
    ) AS average_transaction_value
FROM employees e
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.position
ORDER BY
    average_transaction_value DESC;
--Create a report showing each store's name, manager's name, number of employees, and total sales amount.
SELECT
    st.store_id,
    st.store_name,
    COALESCE(
        m.first_name || ' ' || m.last_name,
        'No Manager Assigned'
    ) AS manager_name,
    COUNT(DISTINCT e.employee_id) AS number_of_employees,
    COALESCE(SUM(s.total_amount), 0.00) AS total_sales_amount
FROM stores st

LEFT JOIN employees e
    ON st.store_id = e.store_id

LEFT JOIN employees m
    ON e.manager_id = m.employee_id

LEFT JOIN sales s
    ON e.employee_id = s.employee_id

GROUP BY
    st.store_id,
    st.store_name,
    m.employee_id,
    m.first_name,
    m.last_name

ORDER BY
    total_sales_amount DESC;
--Identify stores where the average employee salary is higher than the company-wide average.
WITH company_average_salary AS (
    SELECT
        AVG(salary) AS average_company_salary
    FROM employees
),

store_average_salary AS (
    SELECT
        st.store_id,
        st.store_name,
        AVG(e.salary) AS average_store_salary
    FROM stores st
    JOIN employees e
        ON st.store_id = e.store_id
    GROUP BY
        st.store_id,
        st.store_name
)

SELECT
    sas.store_id,
    sas.store_name,
    ROUND(sas.average_store_salary, 2)
        AS average_store_salary,
    ROUND(cas.average_company_salary, 2)
        AS company_average_salary
FROM store_average_salary sas
CROSS JOIN company_average_salary cas
WHERE sas.average_store_salary > cas.average_company_salary
ORDER BY
    sas.average_store_salary DESC;
--Create a product performance matrix that categorizes products into four groups based on their sales volume and profit margin:
--Stars: High sales, high margin
--Volume Drivers: High sales, low margin

 WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,

        COALESCE(
            SUM(si.quantity),
            0
        ) AS sales_volume,

        COALESCE(
            SUM(
                si.quantity *
                (si.price_sold - p.cost)
            ),
            0
        ) AS total_profit,

        CASE
            WHEN SUM(
                si.quantity * si.price_sold
            ) > 0
            THEN
                SUM(
                    si.quantity *
                    (si.price_sold - p.cost)
                )
                /
                SUM(
                    si.quantity * si.price_sold
                )
            ELSE 0
        END AS profit_margin

    FROM products p

    LEFT JOIN sale_items si
        ON p.product_id = si.product_id

    GROUP BY
        p.product_id,
        p.product_name
),

performance_thresholds AS (
    SELECT
        AVG(sales_volume) AS average_sales_volume,
        AVG(profit_margin) AS average_profit_margin
    FROM product_performance
)

SELECT
    pp.product_id,
    pp.product_name,
    pp.sales_volume,

    ROUND(
        pp.total_profit,
        2
    ) AS total_profit,

    ROUND(
        pp.profit_margin * 100,
        2
    ) AS profit_margin_percentage,

    CASE
        WHEN pp.sales_volume >= pt.average_sales_volume
         AND pp.profit_margin >= pt.average_profit_margin
        THEN 'Stars'

        WHEN pp.sales_volume >= pt.average_sales_volume
         AND pp.profit_margin < pt.average_profit_margin
        THEN 'Volume Drivers'

        WHEN pp.sales_volume < pt.average_sales_volume
         AND pp.profit_margin >= pt.average_profit_margin
        THEN 'Opportunities'

        ELSE 'Problems'
    END AS performance_category

FROM product_performance pp

CROSS JOIN performance_thresholds pt

ORDER BY
    performance_category,
    pp.sales_volume DESC;