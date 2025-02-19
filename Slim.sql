create database slim
use slim

-- T?o b?ng Role
CREATE TABLE Role (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(255) NOT NULL
);

-- T?o b?ng Accounts
CREATE TABLE Accounts (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(255) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    RoleID INT FOREIGN KEY REFERENCES Role(ID)
);

-- T?o b?ng Customer
CREATE TABLE Customer (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255),
    Points INT
);

CREATE TABLE Employees (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName NVARCHAR(255) NOT NULL,
    Salary INT NOT NULL,
    CCCD NVARCHAR(20) NOT NULL,
    AccountsID INT FOREIGN KEY REFERENCES Accounts(ID),
    IsAvailable BIT NOT NULL DEFAULT 1 -- 1: Còn làm việc, 0: Nghỉ việc
);


-- T?o b?ng WorkSchedule
CREATE TABLE WorkSchedule (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    WorkDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    CheckIn TIME,
    CheckOut TIME,
    EmployeesID INT FOREIGN KEY REFERENCES Employees(ID)
);

-- T?o b?ng Payroll
CREATE TABLE Payroll (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MonthYear NVARCHAR(255) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

-- T?o b?ng Employees_Payroll
CREATE TABLE Employees_Payroll (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeesID INT FOREIGN KEY REFERENCES Employees(ID),
    PayrollID INT FOREIGN KEY REFERENCES Payroll(ID),
    WorkDays INT NOT NULL,
    PayDate DATE NOT NULL
);

-- T?o b?ng Categories
CREATE TABLE Categories (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255),
    Image NVARCHAR(255)
);

-- T?o b?ng Products
CREATE TABLE Products (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255) NOT NULL,
    ProductCode NVARCHAR(50) NOT NULL,
    UnitPrice INT NOT NULL,
    StockQuantity INT NOT NULL,
    IsAvailable BIT NOT NULL,
	imageURL NVARCHAR(255) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(ID)
);

-- T?o b?ng Payments
CREATE TABLE Payments (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    PaymentMethods NVARCHAR(255) NOT NULL
);

-- T?o b?ng Vouchers
CREATE TABLE Vouchers (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(50) NOT NULL,
    MinOrder INT NOT NULL,
    DiscountRate INT NOT NULL,
    MaxValue INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

-- T?o b?ng Orders (Quan h? 1-1 v?i Payments và Vouchers)
CREATE TABLE Orders (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    TotalAmount INT NOT NULL,
    Paid BIT NOT NULL,
    CustomerID INT FOREIGN KEY REFERENCES Customer(ID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(ID),
    PaymentsID INT UNIQUE, -- Quan h? 1-1 v?i Payments
    VouchersID INT UNIQUE  -- Quan h? 1-1 v?i Vouchers
);

-- Thi?t l?p khóa ngo?i cho Orders ?? ??m b?o quan h? 1-1
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Payments FOREIGN KEY (PaymentsID) REFERENCES Payments(ID) ON DELETE SET NULL;

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Vouchers FOREIGN KEY (VouchersID) REFERENCES Vouchers(ID) ON DELETE SET NULL;

-- T?o b?ng OrderDetails
CREATE TABLE OrderDetails (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL,
    UnitPrice INT NOT NULL,
    OrdersID INT FOREIGN KEY REFERENCES Orders(ID),
    ProductsID INT FOREIGN KEY REFERENCES Products(ID)
);

-- T?o b?ng Discount
CREATE TABLE Discount (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MinQuantity INT NOT NULL,
    DiscountRate INT NOT NULL,
    MaxValue INT NOT NULL,
    ProductsID INT FOREIGN KEY REFERENCES Products(ID)
);

-- T?o b?ng Returns
CREATE TABLE Returns (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL,
    Reason NVARCHAR(255) NOT NULL,
    ReturnDate DATE NOT NULL,
    OrdersID INT FOREIGN KEY REFERENCES Orders(ID),
    EmployeesID INT FOREIGN KEY REFERENCES Employees(ID)
);

-- T?o b?ng Suppliers
CREATE TABLE Suppliers (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL
);

-- T?o b?ng SupplierDebt
CREATE TABLE SupplierDebt (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TotalDebt INT NOT NULL,
    LastUpdate DATE NOT NULL,
    SuppliersID INT FOREIGN KEY REFERENCES Suppliers(ID)
);

-- T?o b?ng SupplierPayments
CREATE TABLE SupplierPayments (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AmountPaid INT NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod NVARCHAR(255) NOT NULL,
    Notes NVARCHAR(255),
    SupplierDebtID INT FOREIGN KEY REFERENCES SupplierDebt(ID)
);

-- T?o b?ng GoodsReceipt
CREATE TABLE GoodsReceipt (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ReceivedDate DATE NOT NULL,
    TotalCost INT NOT NULL,
    SuppliersID INT FOREIGN KEY REFERENCES Suppliers(ID)
);

-- T?o b?ng GoodReceiptDetails
CREATE TABLE GoodReceiptDetails (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    BatchNumber NVARCHAR(50) NOT NULL,
    QuantityReceived INT NOT NULL,
    UnitCost INT NOT NULL,
    ExpirationDate DATE NOT NULL,
    GoodsReceiptID INT FOREIGN KEY REFERENCES GoodsReceipt(ID),
    ProductsID INT FOREIGN KEY REFERENCES Products(ID)
);
