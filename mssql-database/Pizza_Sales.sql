CREATE VIEW vw_Pizza_Sales_Cleaned AS
SELECT 
    od.order_details_id,
    o.order_id,
    CAST(o.date AS DATE) AS order_date,
    CAST(o.time AS TIME) AS order_time,
    pt.name AS pizza_name,
    pt.category AS pizza_category,
    p.size AS pizza_size,
    CAST(p.price AS DECIMAL(10,2)) AS unit_price,
    od.quantity,
    CAST((od.quantity * p.price) AS DECIMAL(10,2)) AS line_item_revenue,
    -- Extracting Time Features for Power BI Slicers
    DATEPART(HOUR, o.time) AS order_hour,
    DATENAME(DW, o.date) AS day_of_week,
    DATEPART(MONTH, o.date) AS month_num,
    DATENAME(MONTH, o.date) AS month_name
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;

