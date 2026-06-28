CREATE DATABASE onlinestoreAnalytics
GO 


USE onlinestoreAnalytics
GO

CREATE TABLE CUSTOMERS(
CustomerID INT IDENTITY(1,1) PRIMARY KEY,    
FirstName NVARCHAR(50) NOT NULL,            
LastName NVARCHAR(50) NOT NULL,
Email NVARCHAR(100) UNIQUE NOT NULL,        
Phone NVARCHAR(15),                            
City NVARCHAR(50),
RegisterDate DATE DEFAULT GETDATE(),        
CustomerType NVARCHAR(20) DEFAULT 'NORMAL'   
)
go


CREATE TABLE Categories(
CategoryID INT IDENTITY(1,1) PRIMARY KEY,  
CategoryName NVARCHAR(50) NOT NULL,
ParentCategoryID INT NULL ,          
Description NVARCHAR(max),           
FOREIGN KEY (ParentCategoryID) REFERENCES Categories(categoryid)  
)
GO


CREATE TABLE products(
productID INT IDENTITY(1,1) PRIMARY KEY,
productName NVARCHAR(100) NOT NULL,
categoryid INT NOT NULL,
price DECIMAL(18,2) NOT NULL CHECK(price>0),                   
cost DECIMAL(18,2) NOT NULL,                                  
stock INT NOT NULL DEFAULT 0,                                  
IsActive BIT DEFAULT 1,                                        
CreatdDate DATE DEFAULT GETDATE(),                              
FOREIGN KEY(categoryID) REFERENCES categories (CategoryID)     
)                                                              
GO
 

 
CREATE TABLE Orders (
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT NOT NULL,
OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
TotalAmount DECIMAL(18,2) NOT NULL,
Discount DECIMAL(18,2) DEFAULT 0,
FinalAmount AS (TotalAmount - Discount),     
Status NVARCHAR(20) DEFAULT 'Pending',       
PaymentMethod NVARCHAR(20),                 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO
 


CREATE TABLE OrderDetails (
OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,                                     
ProductID INT NOT NULL,                                    
Quantity INT NOT NULL CHECK (Quantity > 0),                
UnitPrice DECIMAL(18,2) NOT NULL,                          
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),          
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)      
);                                                             
GO


CREATE TABLE Reviews (                        
ReviewID INT IDENTITY(1,1) PRIMARY KEY,   
CustomerID INT NOT NULL,
ProductID INT NOT NULL,
Rating INT CHECK (Rating BETWEEN 1 AND 5),
Comment NVARCHAR(MAX),
ReviewDate DATETIME DEFAULT GETDATE(),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO
 


USE onlinestoreAnalytics
GO
 
 INSERT INTO dbo.Categories
(
CategoryName,
ParentCategoryID,
Description
)
VALUES
(   N'ماشین لباسشویی', -- CategoryName - nvarchar(50)
4,   -- ParentCategoryID - int
N'انواع ماشین لباسشویی'  -- Description - nvarchar(max)
),

(   N'پوشاک', -- CategoryName - nvarchar(50)
null,   -- ParentCategoryID - int
N'پوشاک و مد'  -- Description - nvarchar(max)
),

(   N'مردانه', -- CategoryName - nvarchar(50)
7,   -- ParentCategoryID - int
N'پوشاک مردانه'  -- Description - nvarchar(max)
),

(   N'زنانه', -- CategoryName - nvarchar(50)
7,   -- ParentCategoryID - int
N'پوشاک زنانه'  -- Description - nvarchar(max)
),

(   N'کتاب', -- CategoryName - nvarchar(50)
null,   -- ParentCategoryID - int
N'کتاب و مجلات'  -- Description - nvarchar(max)
)
	 
GO



INSERT INTO Products (ProductName, CategoryID, Price, Cost, Stock) VALUES
(N'گوشی سامسونگ A54', 2, 12500000, 10500000, 50),
(N'گوشی آیفون 13', 2, 35000000, 30000000, 30),
(N'گوشی شیائومی Note 12', 2, 9800000, 8000000, 70),
(N'لپ‌تاپ ایسوس Zenbook', 3, 28000000, 23000000, 20),
(N'لپ‌تاپ لنوو IdeaPad', 3, 19000000, 15500000, 35),
(N'یخچال سامسونگ ۲۴ فوت', 5, 22000000, 18000000, 15),
(N'ماشین لباسشویی بوش ۸ کیلو', 6, 16000000, 13000000, 25),
(N'تیشرت مردانه', 8, 350000, 200000, 200),
(N'شلوار جین مردانه', 8, 850000, 500000, 150),
(N'مانتو زنانه', 9, 1200000, 700000, 100),
(N'کتاب Clean Code', 10, 450000, 300000, 80),
(N'کتاب SQL Performance Explained', 10, 380000, 250000, 60);

GO



INSERT INTO Customers (FirstName, LastName, Email, Phone, City, RegisterDate, CustomerType) VALUES
(N'علی',N'محمدی','ali.m@email.com','09121234567',N'تهران','2023-01-15','VIP'),
(N'زهرا',N'احمدی','zahra.a@email.com', '09131234567',N'اصفهان','2023-02-20','Normal'),
(N'محمد', N'رضایی', 'mohammad.r@email.com', '09141234567', N'تبریز', '2023-03-10', 'Normal'),
(N'مریم', N'حسینی', 'maryam.h@email.com', '09151234567', N'شیراز', '2023-01-05', 'VIP'),
(N'رضا', N'کریمی', 'reza.k@email.com', '09161234567', N'مشهد', '2023-04-18', 'Normal'),
(N'سارا', N'موسوی', 'sara.m@email.com', '09171234567', N'تهران', '2023-05-22', 'Wholesale'),
(N'امیر', N'نوروزی', 'amir.n@email.com', '09181234567', N'کرج', '2023-06-30', 'Normal'),
(N'فاطمه', N'صادقی', 'fatemeh.s@email.com', '09191234567', N'اصفهان', '2023-02-14', 'Normal'),
(N'حسین', N'عباسی', 'hossein.a@email.com', '09201234567', N'اهواز', '2023-07-08', 'Normal'),
(N'نرگس', N'قاسمی', 'narges.q@email.com', '09211234567', N'قم', '2023-08-15', 'VIP');

GO



	INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Discount, Status, PaymentMethod) VALUES
(1,'2024-01-15 10:30:00',35000000, 2000000 , N'Delivered', N'Online'),
(2, '2024-02-20 14:00:00', 12500000, 0, 'Delivered', 'Card'),
(3, '2024-03-10 09:15:00', 19000000, 500000, 'Delivered', 'Cash'),
(4, '2024-03-22 16:45:00', 22000000, 1000000, 'Delivered', 'Online'),
(5, '2024-04-05 11:00:00', 850000, 0, 'Cancelled', 'Card'),
(6, '2024-04-15 13:30:00', 45000000, 5000000, 'Delivered', 'Online'),
(7, '2024-05-01 08:20:00', 9800000, 300000, 'Delivered', 'Cash'),
(8, '2024-05-18 17:00:00', 1200000, 0, 'Processing', 'Online'),
(9, '2024-06-10 12:00:00', 28000000, 1500000, 'Delivered', 'Card'),
(10, '2024-06-25 10:45:00', 380000, 0, 'Shipped', 'Online'),
(1, '2024-07-05 15:30:00', 16000000, 800000, 'Processing', 'Online'),
(2, '2024-07-20 09:00:00', 350000, 0, 'Delivered', 'Cash'),
(4, '2024-08-01 14:15:00', 47000000, 3000000, 'Shipped', 'Card'),
(6, '2024-08-12 11:30:00', 16000000, 0, 'Delivered', 'Online'),
(8, '2024-09-01 16:00:00', 850000, 50000, 'Delivered', 'Cash');

GO



INSERT INTO dbo.OrderDetails(OrderID, ProductID, Quantity, UnitPrice)VALUES
(1, 2, 1, 35000000),
(2, 1, 1, 12500000),
(3, 5, 1, 19000000),
(4, 6, 1, 22000000),
(5, 8, 2, 350000),
(6, 2, 1, 35000000),
(6, 7, 1, 16000000),
(7, 3, 1, 9800000),
(8, 10, 1, 1200000),
(9, 4, 1, 28000000),
(10, 12, 1, 380000),
(11, 7, 1, 16000000),
(12, 8, 1, 350000),
(13, 2, 1, 35000000),
(13, 4, 1, 28000000),
(14, 7, 1, 16000000),
(15, 9, 1, 850000);
GO


DBCC CHECKIDENT('OrderDetails',RESEED,0)
GO


INSERT INTO Reviews (CustomerID, ProductID, Rating, Comment, ReviewDate) VALUES
(1, 2, 5, N'عالی بود، ارزش خرید داره', '2024-02-01 10:00:00'),
(2, 1, 4, N'خوب بود ولی باتری می‌تونست بهتر باشه', '2024-03-01 12:00:00'),
(3, 5, 5, N'لپ‌تاپ بسیار خوبی برای کارهای روزمره است', '2024-03-20 14:00:00'),
(4, 6, 4, N'یخچال جادار و کم مصرف', '2024-04-15 16:00:00'),
(6, 2, 5, N'دوربینش فوق‌العاده‌ست', '2024-05-01 09:00:00'),
(7, 3, 3, N'قیمتش مناسبه', '2024-05-20 11:00:00'),
(9, 4, 5, N'سرعت و کیفیت عالی', '2024-07-01 08:00:00'),
(10, 12, 4, N'کتاب خوبی برای یادگیری SQL', '2024-07-10 15:00:00');
GO

