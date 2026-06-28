
WITH SalesData AS (
SELECT p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
)
SELECT ProductName,
TotalSales,
ROW_NUMBER() OVER (ORDER BY TotalSales DESC) AS Rank
FROM SalesData;
GO



WITH MonthlySales AS (
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month,
SUM(FinalAmount) AS TotalSales
FROM Orders
WHERE Status = 'Delivered'
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT Year, Month, TotalSales,
LAG(TotalSales) OVER (ORDER BY Year, Month) AS PreviousMonthSales,
TotalSales - LAG(TotalSales) OVER (ORDER BY Year, Month) AS Growth
FROM MonthlySales
ORDER BY Year, Month;
GO


SELECT c.FirstName, c.LastName, SUM(o.FinalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
HAVING SUM(o.FinalAmount) > (
SELECT AVG(TotalPerCustomer)
FROM (
SELECT SUM(FinalAmount) AS TotalPerCustomer
FROM Orders
GROUP BY CustomerID
) AS CustomerTotals
);
GO



WITH CategorySales AS (
SELECT c.CategoryName,
ISNULL(SUM(od.Quantity * od.UnitPrice), 0) AS TotalSales
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName)
SELECT CategoryName, TotalSales,
CASE 
WHEN (SELECT SUM(TotalSales) FROM CategorySales) = 0 THEN 0
ELSE CAST(TotalSales * 100.0 / (SELECT SUM(TotalSales) FROM CategorySales) AS DECIMAL(5,2))
END AS SalesPercent
FROM CategorySales ORDER BY TotalSales DESC;
GO



SELECT c.FirstName, c.LastName,
MIN(o.OrderDate) AS FirstOrder,
MAX(o.OrderDate) AS LastOrder,
DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS DaysBetween
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(o.OrderID) > 1;
GO



SELECT p.ProductName,
CAST(AVG(CAST(r.Rating AS DECIMAL(3,1))) AS DECIMAL(3,1)) AS AvgRating,
COUNT(r.ReviewID) AS ReviewCount
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductName
HAVING AVG(CAST(r.Rating AS DECIMAL(3,1))) IS NOT NULL
ORDER BY AvgRating DESC;
GO



SELECT o.OrderID, COUNT(od.ProductID) AS UniqueProducts
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING COUNT(od.ProductID) > 1;
GO



SELECT o.OrderID, c.FirstName,
STRING_AGG(p.ProductName, '، ') AS Products
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID, c.FirstName;
GO



SELECT DISTINCT c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.FinalAmount > 10000000
AND o.PaymentMethod = 'Online';
GO



WITH CustomerLTV AS (
SELECT CustomerID, SUM(FinalAmount) AS LifetimeValue
FROM Orders
WHERE Status = 'Delivered'
GROUP BY CustomerID
)
SELECT c.FirstName, c.LastName, clv.LifetimeValue,
CASE 
WHEN clv.LifetimeValue > 50000000 THEN N'طلایی'
WHEN clv.LifetimeValue > 20000000 THEN N'نقره‌ای'
ELSE N'برنزی'
END AS CustomerTier
FROM Customers c
JOIN CustomerLTV clv ON c.CustomerID = clv.CustomerID
ORDER BY clv.LifetimeValue DESC;
GO



SELECT OrderID,
OrderDate,
FORMAT(OrderDate, 'yyyy/MM/dd', 'fa-IR') AS ShamsiDate,
DATENAME(WEEKDAY, OrderDate) AS WeekDay,
DATEPART(QUARTER, OrderDate) AS Quarter
FROM Orders
ORDER BY OrderDate;
GO



SELECT c.FirstName,
COUNT(CASE WHEN MONTH(o.OrderDate) = 1 THEN 1 END) AS Jan,
COUNT(CASE WHEN MONTH(o.OrderDate) = 2 THEN 1 END) AS Feb,
COUNT(CASE WHEN MONTH(o.OrderDate) = 3 THEN 1 END) AS Mar
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2024
GROUP BY c.FirstName;
GO




SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(o.OrderID) = 1;
GO



UPDATE Products
SET IsActive = 0
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails 
WHERE OrderID IN (SELECT OrderID FROM Orders 
WHERE OrderDate >= DATEADD(YEAR, -1, GETDATE())
)
);
GO

