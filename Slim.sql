CREATE DATABASE SlimDB1;
GO
USE SlimDB1;

-- Bảng 1: Roles
CREATE TABLE Roles (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(255) NOT NULL
);

-- Bảng 2: Accounts
CREATE TABLE Accounts (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(ID)
);

-- Bảng 3: Employees
CREATE TABLE Employees (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    Salary INT,
    CCD INT,
    Avatar VARCHAR(255),
    AccountsID INT,
    FOREIGN KEY (AccountsID) REFERENCES Accounts(ID)
);

-- Bảng 4: WorkSchedule
CREATE TABLE WorkSchedule (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    WorkDate DATE,
    StartTime TIME,
    EndTime TIME,
    CheckIn DATETIME,
    CheckOut DATETIME,
    EmployeesID INT,
    FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

-- Bảng 5: Customer
CREATE TABLE Customer (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Points INT NOT NULL
);

-- Bảng 6: Payments
CREATE TABLE Payments (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE,
    PaymentMethods VARCHAR(255) NOT NULL
);

-- Bảng 7: Vouchers
CREATE TABLE Vouchers (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(50),
    MinOrder INT,
    DiscountRate INT,
    MaxValue INT,
    StartDate DATE,
    EndDate DATE
);

-- Bảng 8: Orders
CREATE TABLE Orders (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE,
    TotalAmount INT,
    Paid INT,
    CustomerID INT,
    EmployeesID INT,
    PaymentsID INT,
    VouchersID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
    FOREIGN KEY (PaymentsID) REFERENCES Payments(ID),
    FOREIGN KEY (VouchersID) REFERENCES Vouchers(ID)
);

-- Bảng 9: Categories
CREATE TABLE Categories (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    Image VARCHAR(255)
);

-- Bảng 10: Products
CREATE TABLE Products (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    ProductCode VARCHAR(255),
    Price INT,
    StockQuantity INT,
    IsAvailable BIT,
    ImageURL VARCHAR(255),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(ID)
);

-- Bảng 11: OrderDetails
CREATE TABLE OrderDetails (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT,
    OrdersID INT,
    ProductsID INT,
    FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
    FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);

-- Bảng 12: Returns
CREATE TABLE Returns (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT,
    Reason VARCHAR(255),
    ReturnDate DATE,
    OrdersID INT,
    EmployeesID INT,
    FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
    FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

-- Bảng 13: Suppliers
CREATE TABLE Suppliers (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(255),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    Email VARCHAR(255)
);

-- Bảng 14: GoodsReceipt
CREATE TABLE GoodsReceipt (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ReceivedDate DATE,
    TotalCost INT,
    SuppliersID INT,
    FOREIGN KEY (SuppliersID) REFERENCES Suppliers(ID)
);

-- Bảng 15: GoodReceiptDetails
CREATE TABLE GoodReceiptDetails (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    BatchNumber VARCHAR(255),
    QuantityReceived INT,
    UnitCost INT,
    ExpirationDate DATE,
    GoodsReceiptID INT,
    ProductsID INT,
    FOREIGN KEY (GoodsReceiptID) REFERENCES GoodsReceipt(ID),
    FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);

-- Bảng 16: SupplierPayments
CREATE TABLE SupplierPayments (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AmountPaid INT,
    PaymentDate DATE,
    PaymentMethod VARCHAR(255),
    Notes VARCHAR(255),
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(ID)
);

-- Bảng 17: SupplierDebt
CREATE TABLE SupplierDebt (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TotalDebt INT,
    LastUpdate DATE,
    GoodsReceiptID INT,
    FOREIGN KEY (GoodsReceiptID) REFERENCES GoodsReceipt(ID)
);

-- Bảng 18: Payroll
CREATE TABLE Payroll (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MonthYear VARCHAR(255),
    StartDate DATE,
    EndDate DATE
);

-- Bảng 19: EmployeesPayroll
CREATE TABLE EmployeesPayroll (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeesID INT,
    PayRollID INT,
    WorkDays INT,
    PayDate DATE,
    FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
    FOREIGN KEY (PayRollID) REFERENCES Payroll(ID)
);
