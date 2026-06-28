USE onlinestoreAnalytics
GO

SELECT TOP(5)productName,price FROM dbo.products 
GO

SELECT productName,price FROM dbo.products WHERE price>5000000 ORDER BY price DESC
GO


SELECT * FROM dbo.products WHERE productName IN (N'گوشی آیفون 13',N'گوشی سامسونگ A54')
GO



 SELECT productName,price FROM dbo.products WHERE CAST(price AS INT)=12500000
  GO

   
SELECT productName,stock FROM dbo.products WHERE stock IN(30,50,70)
go


SELECT productName,stock FROM dbo.products WHERE stock NOT IN (30,50,70)
GO


SELECT * FROM dbo.products WHERE price BETWEEN 1000000 AND 12000000
GO


SELECT * FROM dbo.products WHERE price NOT BETWEEN 1000000 AND 12000000
GO


SELECT * FROM dbo.products WHERE productName=N'گوشی سامسونگ A54' AND stock=50
GO


SELECT * FROM dbo.CUSTOMERS  WHERE FirstName=N'علی' OR FirstName=N'امیر'
GO


SELECT p.ProductName, c.CategoryName FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN (N'موبایل', N'لپ‌تاپ');

GO


SELECT  c.FirstName,c.LastName,c.RegisterDate,o.Status FROM dbo.CUSTOMERS c
JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status ='Cancelled'

GO


SELECT p.ProductName, p.Stock,c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID    
WHERE p.Stock < 30  AND (c.CategoryName = N'لوازم خانگی' OR c.ParentCategoryID = 4);           
GO



SELECT ProductName, Price FROM Products WHERE ProductName LIKE N'%سامسونگ%'
GO


SELECT productName FROM dbo.products WHERE productName NOT LIKE N'%س%'
GO




SELECT productName, stock FROM dbo.products WHERE productName LIKE N'%س%' AND stock LIKE 50
GO


SELECT C.CategoryName, COUNT(P.productID) AS ProductCount FROM dbo.Categories c
LEFT JOIN dbo.products p ON C.CategoryID = P.categoryid
GROUP BY c.CategoryName ORDER BY ProductCount DESC
GO


SELECT c.FirstName+ ' ' + c.LastName AS customerName,
p.productName FROM dbo.CUSTOMERS c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
JOIN dbo.OrderDetails od ON od.OrderID = o.OrderID
JOIN dbo.products p ON p.productID = od.ProductID
GO


SELECT c.CategoryName, COUNT(p.ProductID)FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
GO



SELECT c.CategoryName, COUNT(p.ProductID)FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
GO


SELECT c.LastName + ' '+ c.FirstName AS customerName, o.OrderID FROM dbo.CUSTOMERS c
INNER JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
GO


SELECT c.FirstName, c.LastName, o.OrderID FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
GO


SELECT c.FirstName, c.LastName, o.OrderID
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

GO


SELECT c.CategoryName,p.price, AVG(p.Price) AS AvgPrice FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName,p.price
HAVING AVG(p.Price) > 2000000;
GO


SELECT c.CategoryName, max(p.price) AS [max] FROM dbo.Categories c
INNER JOIN dbo.products p ON p.categoryid = c.CategoryID
GROUP BY c.CategoryName
GO


SELECT ProductName, Price,Cost,(Price - Cost) AS Profit,
CAST(((Price - Cost) / Price) * 100 AS DECIMAL(5,2)) AS ProfitPercent FROM Products
ORDER BY ProfitPercent DESC;
GO



SELECT AVG(FinalAmount) FROM dbo.Orders WHERE Status ='Delivered'
GO


SELECT  CAST(AVG(FinalAmount) AS DECIMAL(18,3)) AS AvgFinalAmount FROM Orders
WHERE Status = 'Delivered';
GO


SELECT  OrderID, N'سفارش شما در تاریخ ' + CAST(OrderDate AS NVARCHAR(20)) + N' ثبت شد.' AS Message 
FROM Orders;
GO



SELECT ProductName, Price, Cost, 
(Price - Cost) AS Profit,CAST(((Price - Cost) / Price) * 100 AS DECIMAL(5,2)) AS ProfitPercent
FROM Products
ORDER BY ProfitPercent DESC;
GO



SELECT FirstName, LastName, City, CustomerType
FROM Customers
WHERE City = N'تهران' AND CustomerType = 'VIP';
GO



SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName,
o.FinalAmount,
CASE 
WHEN o.FinalAmount > 20000000 THEN N'خرید بزرگ'
WHEN o.FinalAmount > 5000000 THEN N'خرید متوسط'
ELSE N'خرید کوچک'
END AS OrderSize,o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;
GO



SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'Cancelled';
GO



SELECT c.FirstName + ' ' + c.LastName AS FullName,
COUNT(o.OrderID) AS OrderCount,
ISNULL(SUM(o.FinalAmount), 0) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSpent DESC;
GO



SELECT ProductName, Stock
FROM Products WHERE Stock < 30
ORDER BY Stock ASC;
GO



SELECT TOP 5 
c.FirstName + ' ' + c.LastName AS FullName,
SUM(o.FinalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status = 'Delivered'
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSpent DESC;
GO



UPDATE Products
SET Price = Price * 1.1
WHERE ProductName LIKE N'%سامسونگ%';
GO


SELECT p.ProductName, r.ReviewID FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
WHERE r.ReviewID IS NULL;
GO

