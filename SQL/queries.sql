--checking unmatched order ids 
SELECT COUNT(*) AS unmatched_ids
FROM order_details d 
LEFT JOIN orders o ON d.order_id = o.order_id 
WHERE o.order_id IS NULL;

--key KPIs(TOTAL ORDERS)
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

--TOTAL REVENUE 
SELECT SUM(amount) AS total_amount
FROM order_details;

--TOTAL PROFIT 
DELECT SUM(rpofit) AS total_profit
FROM order_details;

--AVERAGE ORDER VALUE
SELECT SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value
FROM order_details;

--STATE LEVEL ANALYSIS (TOP 5 STAES BY REVENUE)
SELECT 
    o.state,
    SUM(d.amount) AS total_sales
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
GROUP BY o.state
ORDER BY total_sales DESC
LIMIT 5;

-- Profit by State
SELECT 
    o.state,
    SUM(d.profit) AS total_profit
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
GROUP BY o.state
ORDER BY total_profit DESC;


--Category & Subcategory Analysis(-- Sales by Category)
SELECT 
    category,
    SUM(amount) AS total_sales
FROM order_details
GROUP BY category
ORDER BY total_sales DESC;

-- Top Subcategory by Sales
SELECT 
    sub_category,
    SUM(amount) AS total_sales
FROM order_details
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 10;

--Monthly Trend Analysis
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(d.amount) AS monthly_sales,
    SUM(d.profit) AS monthly_profit
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;

--Actual vs Target Analysis
SELECT 
    s.category,
    s.month_of_order_date,
    SUM(d.amount) AS actual_sales,
    s.target AS target_sales,
    (SUM(d.amount) - s.target) AS variance,
    ROUND((SUM(d.amount) / s.target) * 100, 2) AS achievement_percentage
FROM sales_targets s
LEFT JOIN order_details d
      ON s.category = d.category
GROUP BY s.category, s.month_of_order_date, s.target
ORDER BY s.month_of_order_date, s.category;

--Customer Insights(-- Top 10 Customers by Revenue)
SELECT 
    o.customer_name,
    SUM(d.amount) AS total_spend
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
GROUP BY o.customer_name
ORDER BY total_spend DESC
LIMIT 10;

-- Average Order Quantity per Customer
SELECT 
    o.customer_name,
    AVG(d.quantity) AS avg_quantity
FROM orders o
JOIN order_details d ON o.order_id = d.order_id
GROUP BY o.customer_name
ORDER BY avg_quantity DESC;

--High-Level Summary Using CTEs
WITH summary AS (
    SELECT
        SUM(amount) AS total_sales,
        SUM(profit) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM order_details
),
category_sales AS (
    SELECT 
        category,
        SUM(amount) AS cat_sales
    FROM order_details
    GROUP BY category
)
SELECT 
    s.total_sales,
    s.total_profit,
    s.total_orders,
    (SELECT category FROM category_sales ORDER BY cat_sales DESC LIMIT 1) AS top_category,
    (SELECT category FROM category_sales ORDER BY cat_sales ASC LIMIT 1) AS worst_category
FROM summary s;

--Performance Optimization
CREATE INDEX idx_orders_orderid ON orders(order_id);
CREATE INDEX idx_details_orderid ON order_details(order_id);
CREATE INDEX idx_category ON order_details(category);