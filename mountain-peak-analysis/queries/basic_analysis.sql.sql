--Which products have less than 20 items in stock? Sort the results by stock quantity in ascending order.
select * from products
where stock_quantity < 20
order by stock_quantity asc
--What products are currently out of stock (stock_quantity = 0)?
select * from products
where stock_quantity = 0
--Calculate the profit margin percentage for each product. Which products have the highest profit margins?
SELECT 
    product_name,
    price,
    cost,
    ((price - cost) /price) * 100 AS profit_margin_percentage
FROM products
ORDER BY profit_margin_percentage DESC;

--Find all products that have no assigned category or supplier.
SELECT *
FROM products
WHERE category_id IS NULL
   OR supplier_id IS NULL;
--List all products along with their category name and supplier name. Include products that don't have a category or supplier assigned.
SELECT 
    products.product_name,
    categories.category_name,
    suppliers.supplier_name
FROM products
LEFT JOIN categories
    ON products.category_id = categories.category_id
LEFT JOIN suppliers
    ON products.supplier_id = suppliers.supplier_id;