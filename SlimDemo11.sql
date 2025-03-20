CREATE DATABASE SlimDemo3
GO
USE SlimDemo3;
GO

-- Tạo bảng Roles
CREATE TABLE Roles (
                       ID INT IDENTITY(1,1) PRIMARY KEY,
                       RoleName VARCHAR(255) NOT NULL
);

-- Tạo bảng Accounts
CREATE TABLE Accounts (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          UserName VARCHAR(255) NOT NULL,
                          Password VARCHAR(255) NOT NULL,
                          Email VARCHAR(255) NOT NULL,
                          Phone VARCHAR(255) NOT NULL,
                          Address VARCHAR(255) NOT NULL,
                          RoleID INT NOT NULL,
                          FOREIGN KEY (RoleID) REFERENCES Roles(ID)
);
-- Tạo bảng Customers
CREATE TABLE Customer (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          CustomerName VARCHAR(255) NOT NULL,
                          Phone VARCHAR(20) NOT NULL,
                          Address VARCHAR(255) NOT NULL,
                          Points INT NOT NULL
);

-- Tạo bảng Vouchers với các trường bổ sung
CREATE TABLE Vouchers (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          Code VARCHAR(255) NOT NULL,
                          MinOrder INT NOT NULL,
                          DiscountRate INT NOT NULL,
                          MaxValue INT NOT NULL,
                          Usage_limit INT NULL, -- Thêm Usage_limit
                          Usage_count INT NULL, -- Thêm Usage_count
                          Status BIT NULL, -- Thêm Status
                          StartDate DATE NOT NULL,
                          EndDate DATE NOT NULL
);
-- Tạo bảng Payments
CREATE TABLE Payments (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          PaymentMethods NVARCHAR(255) NOT NULL
);
-- Tạo bảng Employees
CREATE TABLE Employees (
                           ID INT IDENTITY(1,1) PRIMARY KEY,
                           EmployeeName VARCHAR(255) NOT NULL,
                           DoB DATE NOT NULL,
                           Gender INT NOT NULL,
                           Salary INT NOT NULL,
                           CCCD VARCHAR(255) NOT NULL,
                           Avatar VARCHAR(255),
                           IsAvailable BIT,
                           AccountsID INT,
                           FOREIGN KEY (AccountsID) REFERENCES Accounts(ID)
);
-- Tạo bảng Categories
CREATE TABLE Categories (
                            ID INT IDENTITY(1,1) PRIMARY KEY,
                            CategoryName VARCHAR(255) NOT NULL,
                            Description VARCHAR(255),
                            Image VARCHAR(255)
);
-- Tạo bảng Products
CREATE TABLE Products (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          ProductName VARCHAR(255) NOT NULL,
                          ProductCode VARCHAR(255) NOT NULL,
                          Price INT NOT NULL,
                          StockQuantity INT NOT NULL,
                          IsAvailable BIT NOT NULL,
                          ImageURL VARCHAR(255),
                          CategoryID INT,
                          FOREIGN KEY (CategoryID) REFERENCES Categories(ID)
);
-- Tạo bảng Orders
CREATE TABLE Orders (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        OrderDate DATE NOT NULL,
                        TotalAmount INT NOT NULL,
                        CustomerID INT,
                        EmployeesID INT,
                        PaymentsID INT,
                        VouchersID INT,
                        FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
                        FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                        FOREIGN KEY (PaymentsID) REFERENCES Payments(ID),
                        FOREIGN KEY (VouchersID) REFERENCES Vouchers(ID)
);
-- Tạo bảng Returns và thêm các khóa ngoại OrdersID và EmployeesID
CREATE TABLE Returns(
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        Quantity INT NULL,
                        Reason VARCHAR(255) NULL,
                        ReturnDate DATE NULL,
                        OrdersID INT NULL,
                        EmployeesID INT NULL,
                        RefundAmount float NULL,
                        FOREIGN KEY (OrdersID) REFERENCES Orders(ID), -- Khóa ngoại OrdersID tham chiếu đến bảng Orders
                        FOREIGN KEY (EmployeesID) REFERENCES Employees(ID) -- Khóa ngoại EmployeesID tham chiếu đến bảng Employees
);
Select * from Returns;
CREATE TABLE OrderDetails (
                              ID INT IDENTITY(1,1) PRIMARY KEY,
                              Quantity INT NOT NULL,
                              Price INT NOT NULL,
                              OrdersID INT NOT NULL,
                              ProductsID INT NOT NULL,
                              FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                              FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);
-- Tạo bảng ReturnDetails
CREATE TABLE ReturnDetails(
                              id INT IDENTITY(1,1) PRIMARY KEY,
                              return_id INT NULL,
                              order_details_id INT NULL,
                              quantity INT NULL,
                              FOREIGN KEY (return_id) REFERENCES [dbo].[Returns](ID),
                              FOREIGN KEY (order_details_id) REFERENCES [dbo].[OrderDetails](ID)
);
CREATE TABLE Suppliers (
                           ID INT IDENTITY(1,1) PRIMARY KEY,
                           SupplierName VARCHAR(255) NOT NULL,
                           Phone VARCHAR(255) NOT NULL,
                           Address VARCHAR(255) NOT NULL,
                           Email VARCHAR(255) NOT NULL
);

ALTER TABLE Suppliers ADD
    SupplierCode VARCHAR(50),
    CompanyName VARCHAR(255),
    TaxCode VARCHAR(50),
    Region VARCHAR(255),
    Ward VARCHAR(255),
    CreatedBy VARCHAR(255),
    CreatedDate DATE,
    Notes VARCHAR(MAX),
    Status BIT DEFAULT 1,
    SupplierGroup VARCHAR(255),
    TotalPurchase DECIMAL(18,2) DEFAULT 0,
    CurrentDebt DECIMAL(18,2) DEFAULT 0

CREATE TABLE GoodsReceipt (
                              ID INT IDENTITY(1,1) PRIMARY KEY,
                              ReceivedDate DATE NOT NULL,
                              TotalCost INT NOT NULL,
                              SuppliersID INT NOT NULL,
                              FOREIGN KEY (SuppliersID) REFERENCES Suppliers(ID)
);

CREATE TABLE GoodReceiptDetails (
                                    ID INT IDENTITY(1,1) PRIMARY KEY,
                                    BatchNumber VARCHAR(255) NOT NULL,
                                    QuantityReceived INT NOT NULL,
                                    UnitCost INT NOT NULL,
                                    ExpirationDate DATE NOT NULL,
                                    GoodsReceiptID INT NOT NULL,
                                    ProductsID INT NOT NULL,
                                    FOREIGN KEY (GoodsReceiptID) REFERENCES GoodsReceipt(ID),
                                    FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);

CREATE TABLE SupplierDebt (
                              ID INT IDENTITY(1,1) PRIMARY KEY,
                              TotalDebt INT NOT NULL,
                              LastUpdate DATE NOT NULL,
                              GoodsReceiptID INT NOT NULL,
                              FOREIGN KEY (GoodsReceiptID) REFERENCES GoodsReceipt(ID)
);

CREATE TABLE SupplierPayments (
                                  ID INT IDENTITY(1,1) PRIMARY KEY,
                                  AmountPaid INT NOT NULL,
                                  PaymentDate DATE NOT NULL,
                                  PaymentMethod VARCHAR(255) NOT NULL,
                                  Notes VARCHAR(255),
                                  SupplierID INT NOT NULL,
                                  FOREIGN KEY (SupplierID) REFERENCES Suppliers(ID)
);

CREATE TABLE Payroll (
                         ID INT IDENTITY(1,1) PRIMARY KEY,
                         Month INT NOT NULL,
                         Year INT NOT NULL,
                         StartDate DATE NOT NULL,
                         EndDate DATE NOT NULL
);

CREATE TABLE Employees_Payroll (
                                   EmployeesID INT NOT NULL,
                                   PayrollID INT NOT NULL,
                                   WorkDays INT NOT NULL,
                                   PayDate DATE NOT NULL,
                                   PRIMARY KEY (EmployeesID, PayrollID),
                                   FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                                   FOREIGN KEY (PayrollID) REFERENCES Payroll(ID)
);

CREATE TABLE Shifts (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        ShiftName VARCHAR(255) NOT NULL,
                        StartTime TIME NOT NULL,
                        EndTime TIME NOT NULL
);

CREATE TABLE WeekDays (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          WeekDay VARCHAR(255) NOT NULL
);

CREATE TABLE WeeklySchedule (
                                ID INT IDENTITY(1,1) PRIMARY KEY,
                                ShiftsID INT NOT NULL,
                                EmployeesID INT NOT NULL,
                                WeekDaysID INT NOT NULL,
                                FOREIGN KEY (ShiftsID) REFERENCES Shifts(ID),
                                FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                                FOREIGN KEY (WeekDaysID) REFERENCES WeekDays(ID)
);

CREATE TABLE Attendance (
                            ID INT IDENTITY(1,1) PRIMARY KEY,
                            WorkDate DATE NOT NULL,
                            IsPresent INT NOT NULL,
                            EmployeesID INT NOT NULL,
                            ShiftsID INT NOT NULL,
                            FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                            FOREIGN KEY (ShiftsID) REFERENCES Shifts(ID)
);

INSERT INTO Roles (RoleName)
VALUES ('Admin'), ('Employee');
-- Insert Admin Account
INSERT INTO Accounts (UserName, Password, Email, Phone, Address, RoleID)
VALUES ('admin', 'admin123', 'admin@example.com', '123456789', '123 Admin St', 1);
-- Insert Employee Accounts
INSERT INTO Accounts (UserName, Password, Email, Phone, Address, RoleID)
VALUES ('employee1', 'pass123', 'emp1@example.com', '987654321', '456 Worker St', 2),
       ('employee2', 'pass456', 'emp2@example.com', '654987321', '789 Worker St', 2);
Select * from Accounts;
-- Insert Employees
INSERT INTO Employees (EmployeeName, Salary, CCCD, Avatar, AccountsID, Gender, DoB, isAvailable)
VALUES ('John Doe', 50000, '1234567890', NULL, 2, 1, '1990-05-20', 1),
       ('Jane Smith', 55000, '0987654321', NULL, 3, 2, '1992-07-15', 1);
-- Insert thêm dữ liệu vào bảng Payments
INSERT INTO Payments (PaymentMethods)
VALUES
    ('Credit Card'),
    ('Debit Card'),
    ('Cash'),
    ('Bank Transfer'),
    ('PayPal');
-- Insert thêm dữ liệu vào bảng Categories
INSERT INTO Categories (CategoryName, Description, Image)
VALUES
    ('Electronics', 'Various electronic products like phones, laptops, etc.', 'http://example.com/electronics.jpg'),
    ('Clothing', 'Apparel including shirts, pants, jackets, etc.', 'http://example.com/clothing.jpg'),
    ('Home Appliances', 'Appliances for home use like refrigerators, microwaves, etc.', 'http://example.com/home_appliances.jpg'),
    ('Books', 'Books of various genres and categories', 'http://example.com/books.jpg');
-- Insert thêm dữ liệu vào bảng Products
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, ImageURL, CategoryID)
VALUES
    ('Product A', 'P001', 100000, 50, 1, 'http://example.com/productA.jpg', 1),
    ('Product B', 'P002', 200000, 30, 1, 'http://example.com/productB.jpg', 2),
    ('Product C', 'P003', 150000, 20, 1, 'http://example.com/productC.jpg', 3),
    ('Product D', 'P004', 250000, 10, 1, 'http://example.com/productD.jpg', 1);
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, ImageURL, CategoryID)
VALUES
    ('Product f', 'P005', 100000, 50, 1, 'http://example.com/productA.jpg', 1),
    ('Product g', 'P006', 200000, 30, 1, 'http://example.com/productB.jpg', 2),
    ('Product l', 'P007', 150000, 20, 1, 'http://example.com/productC.jpg', 3),
    ('Product f', 'P008', 100000, 50, 1, 'http://example.com/productA.jpg', 1),
    ('Product g', 'P009', 200000, 30, 1, 'http://example.com/productB.jpg', 2),
    ('Product 1', 'P00a', 150000, 20, 1, 'http://example.com/productC.jpg', 3),
    ('Product 2', 'P001b', 100000, 50, 1, 'http://example.com/productA.jpg', 1),
    ('Product 3', 'P00c', 200000, 30, 1, 'http://example.com/productB.jpg', 2),
    ('Product l4', 'P00d', 150000, 20, 1, 'http://example.com/productC.jpg', 3),
    ('Product f5', 'P00e', 100000, 50, 1, 'http://example.com/productA.jpg', 1),
    ('Product g6', 'P00f', 200000, 30, 1, 'http://example.com/productB.jpg', 2),
    ('Product l8', 'P00g', 150000, 20, 1, 'http://example.com/productC.jpg', 3),
    ('Product d9', 'P00h', 250000, 10, 1, 'http://example.com/productD.jpg', 1);
-- Insert thêm dữ liệu vào bảng Vouchers
INSERT INTO Vouchers (Code, MinOrder, DiscountRate, MaxValue, Usage_limit, Usage_count, Status, StartDate, EndDate)
VALUES
    ('VOUCHER01', 50000, 10, 10000, 100, 0, 1, '2025-03-01', '2025-03-31'),
    ('VOUCHER02', 100000, 15, 15000, 50, 0, 1, '2025-04-01', '2025-04-30'),
    ('VOUCHER03', 20000, 5, 5000, 200, 0, 1, '2025-03-15', '2025-03-25');
Select * from Vouchers;
-- Insert thêm dữ liệu vào bảng Customers
INSERT INTO Customer (CustomerName, Phone, Address, Points)
VALUES
    ('Customer A', '0912345678', '123 Customer St', 200),
    ('Customer B', '0912345679', '456 Customer Ave', 150),
    ('Customer C', '0912345680', '789 Customer Rd', 100),
    ('Customer D', '0912345681', '101 Customer Blvd', 50);
Select * from Orders;
-- Insert Shifts
INSERT INTO Shifts (ShiftName, StartTime, EndTime)
VALUES ('Morning', '00:00:00', '08:00:00'),
       ('Afternoon', '08:00:00', '16:00:00'),
       ('Night', '16:00:00', '00:00:00');

-- Insert WeekDays
INSERT INTO WeekDays (WeekDay)
VALUES ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday');
-- Insert into Suppliers
INSERT INTO Suppliers (SupplierName, Phone, Address, Email, SupplierCode, CompanyName, TaxCode, Region, Ward, CreatedBy, CreatedDate, Notes, Status, SupplierGroup, TotalPurchase, CurrentDebt)
VALUES
    ('Supplier A', '0901234567', '123 Supplier St, City', 'supplierA@example.com', 'S001', 'Supplier A Company', 'TAX001', 'North', 'Ward 1', 'Admin', '2025-03-20', 'Reliable supplier for electronics', 1, 'Electronics', 500000.00, 10000.00);

-- Insert into GoodsReceipt
INSERT INTO GoodsReceipt (ReceivedDate, TotalCost, SuppliersID)
VALUES ('2025-03-20', 1000000, 1)  -- Assuming Supplier A (ID = 1) and the total cost of goods received is 1,000,000

-- Insert into GoodReceiptDetails for each product in the Products table
INSERT INTO GoodReceiptDetails (BatchNumber, QuantityReceived, UnitCost, ExpirationDate, GoodsReceiptID, ProductsID)
VALUES
    ('BATCH001', 50, 100000, '2025-09-01', 2, 1), -- Product A
    ('BATCH002', 30, 200000, '2025-09-10', 2, 2), -- Product B
    ('BATCH003', 20, 150000, '2025-10-01', 2, 3), -- Product C
    ('BATCH004', 10, 250000, '2025-11-01', 2, 4), -- Product D
    ('BATCH005', 50, 100000, '2025-09-05', 2, 5), -- Product f
    ('BATCH006', 30, 200000, '2025-09-15', 2, 6), -- Product g
    ('BATCH007', 20, 150000, '2025-10-15',2, 7), -- Product l
    ('BATCH008', 50, 100000, '2025-09-20', 2, 8), -- Product f
    ('BATCH009', 30, 200000, '2025-09-25',2 , 9), -- Product g
    ('BATCH010', 20, 150000, '2025-10-30', 2, 10), -- Product 1
    ('BATCH011', 50, 100000, '2025-09-30',2 , 11), -- Product 2
    ('BATCH012', 30, 200000, '2025-10-10',2 , 12), -- Product 3
    ('BATCH013', 20, 150000, '2025-11-15',2 , 13), -- Product l4
    ('BATCH014', 50, 100000, '2025-09-18',2 , 14), -- Product f5
    ('BATCH015', 30, 200000, '2025-09-22',2 , 15), -- Product g6
    ('BATCH016', 20, 150000, '2025-10-05',2 , 16), -- Product l8
    ('BATCH017', 10, 250000, '2025-11-10', 2, 17); -- Product d9
