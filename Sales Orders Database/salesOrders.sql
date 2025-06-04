create database sales_orders;
-- List all customers and the number of orders they placed.
select c.cust_name, count(distinct oi.quantity) as total_quantity from customers c join orders o 
on c.cust_id = o.cust_id join order_items oi on o.order_id = oi.order_id 
group by c.cust_name;

-- Show all order items with product name and total price (quantity × price).
SELECT 
    oi.order_item_id,
    o.order_id,
    p.product_name,
    oi.quantity,
    p.price,
    (oi.quantity * p.price) AS total_price
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    orders o ON oi.order_id = o.order_id
ORDER BY 
    o.order_id, oi.order_item_id;

-- Find the total revenue per customer
SELECT 
    c.cust_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.cust_id = o.cust_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    c.cust_name
ORDER BY 
    total_revenue DESC;
    
    -- List the top 3 best-selling products by quantity sold
    SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_sold DESC
LIMIT 3;

--  Show orders with more than 3 items
SELECT 
    o.order_id,
    SUM(oi.quantity) AS total_items
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id
HAVING 
    SUM(oi.quantity) > 3;
    
    -- Find products that were never ordered 
    SELECT 
    p.product_name
FROM 
    products p
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.product_id IS NULL;
    
    -- Get each customer's most recent order date
    SELECT 
    c.cust_name,
    MAX(o.order_date) AS most_recent_order
FROM 
    customers c
JOIN 
    orders o ON c.cust_id = o.cust_id
GROUP BY 
    c.cust_name;
    
    -- Find customers who have spent more than ₹10,000 in total
    SELECT 
    c.cust_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM 
    customers c
JOIN 
    orders o ON c.cust_id = o.cust_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    c.cust_name
HAVING 
    SUM(oi.quantity * p.price) > 10000;

--  For each product, calculate: Total quantity sold,Total revenue ,Unique customers who ordered it
SELECT 
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(oi.quantity * p.price), 0) AS total_revenue,
    COUNT(DISTINCT o.cust_id) AS Total_customers
FROM 
    products p
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id
LEFT JOIN 
    orders o ON oi.order_id = o.order_id
GROUP BY 
    p.product_name;
    
     -- Show the daily revenue for each day in 2023
SELECT 
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
 year(o.order_date)=2023
GROUP BY 
    o.order_date
ORDER BY 
    o.order_date;
    
    -- Calculate monthly revenue using DATE_TRUNC() or equivalent
    
SELECT 
    DATE_format( o.order_date,'%y-%m') AS monthy,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
monthy
ORDER BY 
    monthy;
