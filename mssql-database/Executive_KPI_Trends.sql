CREATE VIEW vw_Executive_KPI_Trends AS
WITH MonthlyMetrics AS (
    SELECT 
        DATEPART(YEAR, order_date) AS Year,
        DATEPART(MONTH, order_date) AS Month,
        SUM(line_item_revenue) AS Current_Month_Revenue,
        COUNT(DISTINCT order_id) AS Total_Orders,
        SUM(quantity) AS Total_Pizzas_Sold
    FROM vw_Pizza_Sales_Cleaned
    GROUP BY DATEPART(YEAR, order_date), DATEPART(MONTH, order_date)
)
SELECT 
    Year,
    Month,
    Current_Month_Revenue,
    LAG(Current_Month_Revenue) OVER (ORDER BY Year, Month) AS Previous_Month_Revenue,
    -- Calculate MoM Growth %
    CAST(((Current_Month_Revenue - LAG(Current_Month_Revenue) OVER (ORDER BY Year, Month)) 
          / LAG(Current_Month_Revenue) OVER (ORDER BY Year, Month) * 100) AS DECIMAL(10,2)) AS Revenue_Growth_Pct,
    -- Average Order Value (AOV)
    CAST((Current_Month_Revenue / Total_Orders) AS DECIMAL(10,2)) AS AOV,
    -- Pizzas Per Order (Efficiency Metric)
    CAST((CAST(Total_Pizzas_Sold AS FLOAT) / Total_Orders) AS DECIMAL(10,2)) AS Pizzas_Per_Order
FROM MonthlyMetrics;
