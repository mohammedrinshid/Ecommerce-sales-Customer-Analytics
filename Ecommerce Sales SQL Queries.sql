-- =========================================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- SQL ANALYSIS + EDA
-- 25 QUERIES
-- =========================================================

USE ecommerce_sales;


-- =========================================================
-- SQL ANALYSIS
-- =========================================================

-- 01. TOTAL SALES

SELECT
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID;


-- 02. TOTAL PROFIT

SELECT
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID;


-- 03. PRODUCT-WISE SALES & PROFIT

SELECT
    p.Product_Name,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC;


-- 04. REGION-WISE SALES & PROFIT

SELECT
    o.Region,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY o.Region
ORDER BY Total_Profit DESC;


-- 05. CUSTOMER-WISE SALES & PROFIT

SELECT
    o.Customer_ID,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY o.Customer_ID
ORDER BY Total_Sales DESC;


-- 06. MONTHLY SALES & PROFIT TREND

SELECT
    YEAR(o.Order_Date) AS Year,
    MONTH(o.Order_Date) AS Month,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    Year,
    Month;


-- 07. ORDER STATUS ANALYSIS

SELECT
    Order_Status,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY Order_Status
ORDER BY Order_Count DESC;


-- 08. DISCOUNT ANALYSIS

SELECT
    od.Discount,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY od.Discount
ORDER BY od.Discount;


-- 09. PAYMENT METHOD ANALYSIS

SELECT
    Payment_Method,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY Payment_Method
ORDER BY Order_Count DESC;


-- 10. SALES & PROFIT BY PAYMENT METHOD

SELECT
    o.Payment_Method,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY o.Payment_Method
ORDER BY Total_Sales DESC;


-- =========================================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================================

-- 11. MINIMUM, MAXIMUM & AVERAGE SALE

SELECT
    MIN(od.Quantity * p.Selling_Price) AS Minimum_Sale,
    MAX(od.Quantity * p.Selling_Price) AS Maximum_Sale,
    AVG(od.Quantity * p.Selling_Price) AS Average_Sale
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID;


-- 12. QUANTITY ANALYSIS

SELECT
    MIN(Quantity) AS Minimum_Quantity,
    MAX(Quantity) AS Maximum_Quantity,
    AVG(Quantity) AS Average_Quantity,
    SUM(Quantity) AS Total_Quantity
FROM order_details;


-- 13. RETURNED & CANCELLED ORDERS BY REGION

SELECT
    Region,
    Order_Status,
    COUNT(*) AS Order_Count
FROM orders
WHERE Order_Status IN ('Returned', 'Cancelled')
GROUP BY
    Region,
    Order_Status
ORDER BY
    Order_Count DESC;


-- 14. ORDER STATUS BY REGION

SELECT
    Region,
    Order_Status,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY
    Region,
    Order_Status
ORDER BY
    Region,
    Order_Count DESC;


-- 15. PRODUCT QUANTITY ANALYSIS

SELECT
    p.Product_Name,
    SUM(od.Quantity) AS Total_Quantity_Sold
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Quantity_Sold DESC;


-- 16. CUSTOMER PURCHASE FREQUENCY

SELECT
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders
GROUP BY Customer_ID
ORDER BY Total_Orders DESC;


-- 17. CUSTOMER REVENUE & PROFIT ANALYSIS

SELECT
    o.Customer_ID,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY o.Customer_ID
ORDER BY Total_Profit DESC;


-- 18. DISCOUNT VS PROFIT

SELECT
    od.Discount,
    COUNT(*) AS Order_Lines,
    SUM(od.Quantity) AS Total_Quantity,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY od.Discount
ORDER BY od.Discount;


-- 19. MONTHLY ORDER VOLUME

SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Year,
    Month;


-- 20. AVERAGE ORDER VALUE (AOV)

SELECT
    SUM(od.Quantity * p.Selling_Price)
    / COUNT(DISTINCT o.Order_ID) AS Average_Order_Value
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID;


-- 21. OVERALL PROFIT MARGIN

SELECT
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price))
    / SUM(od.Quantity * p.Selling_Price) * 100
    AS Profit_Margin_Percentage
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID;


-- 22. PRODUCT PROFIT MARGIN ANALYSIS

SELECT
    p.Product_Name,
    SUM(od.Quantity * p.Selling_Price) AS Total_Sales,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price)) AS Total_Profit,
    SUM(od.Quantity * (p.Selling_Price - p.Cost_Price))
    / SUM(od.Quantity * p.Selling_Price) * 100
    AS Profit_Margin_Percentage
FROM order_details od
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Profit_Margin_Percentage DESC;


-- 23. CUSTOMER AVERAGE ORDER VALUE

SELECT
    o.Customer_ID,
    SUM(od.Quantity * p.Selling_Price)
    / COUNT(DISTINCT o.Order_ID) AS Average_Order_Value
FROM orders o
JOIN order_details od
    ON o.Order_ID = od.Order_ID
JOIN products p
    ON od.Product_ID = p.Product_ID
GROUP BY o.Customer_ID
ORDER BY Average_Order_Value DESC;


-- 24. RETURN & CANCELLATION RATE

SELECT
    COUNT(*) AS Total_Orders,

    SUM(
        CASE
            WHEN Order_Status = 'Returned'
            THEN 1
            ELSE 0
        END
    ) AS Returned_Orders,

    SUM(
        CASE
            WHEN Order_Status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS Cancelled_Orders,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Returned'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS Return_Rate_Percentage,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS Cancellation_Rate_Percentage

FROM orders;


-- 25. REGION-WISE RETURN & CANCELLATION RATE

SELECT
    Region,
    COUNT(*) AS Total_Orders,

    SUM(
        CASE
            WHEN Order_Status = 'Returned'
            THEN 1
            ELSE 0
        END
    ) AS Returned_Orders,

    SUM(
        CASE
            WHEN Order_Status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS Cancelled_Orders,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Returned'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS Return_Rate_Percentage,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS Cancellation_Rate_Percentage

FROM orders
GROUP BY Region
ORDER BY Return_Rate_Percentage DESC;


-- =========================================================
-- END OF SQL ANALYSIS
-- =========================================================