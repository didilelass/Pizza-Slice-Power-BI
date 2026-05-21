CREATE VIEW vw_Product_Performance AS
SELECT 
    pizza_category,
    pizza_size,
    SUM(quantity) AS total_units_sold,
    SUM(line_item_revenue) AS total_revenue,
    -- Calculate % Contribution of each category to total revenue
    CAST(SUM(line_item_revenue) / SUM(SUM(line_item_revenue)) OVER() * 100 AS DECIMAL(10,2)) AS Revenue_Contribution_Pct
FROM vw_Pizza_Sales_Cleaned
GROUP BY pizza_category, pizza_size;
