USE OnlineRetailSystem;
GO

CREATE TABLE Customers
(
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    ShippingAddress VARCHAR(200),
    RegistrationDate DATE
);
GO
CREATE TABLE Suppliers
(
    SupplierId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(50),
    Email VARCHAR(100),
    Address VARCHAR(200),
    ContactNumber VARCHAR(20)
);
GO
CREATE TABLE Categories
(
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(250),
    MainCategory INT NULL,
    FOREIGN KEY (MainCategory)
        REFERENCES Categories(CategoryId)
);
GO
CREATE TABLE Products
(
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    StockQuantity INT NOT NULL DEFAULT 0,
    Name VARCHAR(100) NOT NULL,
    AddedDate DATE DEFAULT GETDATE(),
    Description VARCHAR(250),
    UnitPrice DECIMAL(10,2) NOT NULL,
    CategoryId INT NULL,
    FOREIGN KEY (CategoryId)
        REFERENCES Categories(CategoryId)
);
GO
CREATE TABLE Products_Suppliers
(
    SupplierId INT NOT NULL,
    ProductId INT NOT NULL,

    PRIMARY KEY (SupplierId, ProductId),

    FOREIGN KEY (SupplierId)
        REFERENCES Suppliers(SupplierId),

    FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId)
);
GO
CREATE TABLE Orders
(
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    Status VARCHAR(30),
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    OrderDate DATE DEFAULT GETDATE(),
    CustomerId INT NOT NULL,

    FOREIGN KEY (CustomerId)
        REFERENCES Customers(CustomerId)
);
GO
CREATE TABLE OrderItems
(
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    ProductId INT NOT NULL,
    OrderId INT NOT NULL,

    FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId),

    FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId)
);
GO
CREATE TABLE Payments
(
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE DEFAULT GETDATE(),
    Amount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(30),
    Method VARCHAR(50)
);
GO
CREATE TABLE Orders_Payments
(
    OrderId INT NOT NULL,
    PaymentId INT NOT NULL,

    PRIMARY KEY (OrderId, PaymentId),

    FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId),

    FOREIGN KEY (PaymentId)
        REFERENCES Payments(PaymentId)
);
GO
CREATE TABLE Shipments
(
    ShipmentId INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentDate DATE DEFAULT GETDATE(),
    Status VARCHAR(30),
    DeliveryDate DATE,
    CarrierName VARCHAR(100),
    TrackingNumber VARCHAR(100),
    OrderId INT NOT NULL,

    FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId)
);
GO
CREATE TABLE Reviews
(
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT,
    Date DATE DEFAULT GETDATE(),
    Comment VARCHAR(500),
    ProductID INT NOT NULL,
    CustomerId INT NOT NULL,

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductId),

    FOREIGN KEY (CustomerId)
        REFERENCES Customers(CustomerId)
);
GO
CREATE TABLE StockTransactions
(
    TranId INT IDENTITY(1,1) PRIMARY KEY,
    TranDate DATE NOT NULL,
    QuantityChange INT NOT NULL,
    Type VARCHAR(50),
    Reference VARCHAR(100),
    ProductId INT NOT NULL,

    FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId)
);
GO
INSERT INTO Customers
(
    FullName,
    PhoneNumber,
    Email,
    ShippingAddress,
    RegistrationDate
)
VALUES
(
    'Mahmoud Osamh',
    '01156781769',
    'Mahmoud@example.com',
    'Cairo, Egypt',
    GETDATE()
);
GO
INSERT INTO Suppliers
(
    Name,
    Country,
    Email,
    Address,
    ContactNumber
)
VALUES
(
    'Supplier One',
    'Egypt',
    'supplier1@example.com',
    'Cairo',
    '01234567890'
),
(
    'Supplier Two',
    'Egypt',
    'supplier2@example.com',
    'Giza',
    '01122334455'
),
(
    'Supplier Three',
    'Egypt',
    'supplier3@example.com',
    'Alexandria',
    '01112222333'
);
GO
INSERT INTO Categories
(
    Name,
    Description
)
VALUES
(
    'Electronics',
    'Electronic products'
),
(
    'Accessories',
    'Product accessories'
);
GO
INSERT INTO Products
(
    Name,
    UnitPrice
)
VALUES
(
    'USB Cable',
    75.00
);
GO
CREATE TABLE ArchivedStock
(
    TranId INT,
    ProductId INT,
    QuantityChange INT,
    TranDate DATE
);
GO
INSERT INTO ArchivedStock
(
    TranId,
    ProductId,
    QuantityChange,
    TranDate
)
SELECT
    TranId,
    ProductId,
    QuantityChange,
    TranDate
FROM StockTransactions
WHERE TranDate < '2023-01-01';
GO

UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE UnitPrice < 100;
GO

UPDATE Orders
SET Status = 'Premium'
WHERE TotalAmount > 5000;
GO

UPDATE Orders
SET Status = 'Standard'
WHERE TotalAmount <= 5000;
GO

SELECT name
FROM sys.tables
ORDER BY name;
GO