-- T?o b?ng Role
CREATE TABLE Role (
                      ID INT IDENTITY(1,1) PRIMARY KEY,
                      RoleName VARCHAR(255) NOT NULL
);

CREATE TABLE Accounts (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          UserName VARCHAR(255) NOT NULL,
                          Password VARCHAR(255) NOT NULL,
                          Email VARCHAR(255) NOT NULL,
                          Phone VARCHAR(255) NOT NULL,
                          Adress VARCHAR(255) NOT NULL,
                          RoleID INT NOT NULL,
                          FOREIGN KEY (RoleID) REFERENCES Role(ID)
);

CREATE TABLE Customer (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          CustomerName VARCHAR(255) NOT NULL,
                          Phone VARCHAR(255) NOT NULL,
                          Address VARCHAR(255) NOT NULL,
                          Points INT NOT NULL
);

CREATE TABLE Vouchers (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          Code VARCHAR(255) NOT NULL,
                          MinOrder INT NOT NULL,
                          DiscountRate INT NOT NULL,
                          MaxValue INT NOT NULL,
                          StartDate DATE NOT NULL,
                          EndDate DATE NOT NULL
);

CREATE TABLE Payments (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          PaymentDate DATE NOT NULL,
                          PaymentMethods VARCHAR(255) NOT NULL
);

CREATE TABLE Employees (
                           ID INT IDENTITY(1,1) PRIMARY KEY,
                           EmployeeName VARCHAR(255) NOT NULL,
                           Salary INT NOT NULL,
                           CCCD VARCHAR(255) NOT NULL,
                           Avatar VARCHAR(255),
                           AccountsID INT,
                           Gender INT NOT NULL,
                           DoB DATE NOT NULL,
                           isAvailable INT NOT NULL,
                           FOREIGN KEY (AccountsID) REFERENCES Accounts(ID)
);

CREATE TABLE Orders (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        OrderDate DATE NOT NULL,
                        TotalAmount INT NOT NULL,
                        CustomerID INT NOT NULL,
                        EmployeesID INT NOT NULL,
                        PaymentsID INT NOT NULL,
                        VouchersID INT,
                        FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
                        FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                        FOREIGN KEY (PaymentsID) REFERENCES Payments(ID),
                        FOREIGN KEY (VouchersID) REFERENCES Vouchers(ID)
);

CREATE TABLE Returns (
                         ID INT IDENTITY(1,1) PRIMARY KEY,
                         Quantity INT NOT NULL,
                         Reason VARCHAR(255) NOT NULL,
                         ReturnDate DATE NOT NULL,
                         OrdersID INT NOT NULL,
                         EmployeesID INT NOT NULL,
                         FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                         FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

CREATE TABLE Categories (
                            ID INT IDENTITY(1,1) PRIMARY KEY,
                            CategoryName VARCHAR(255) NOT NULL,
                            Description VARCHAR(255),
                            Image VARCHAR(255)
);

CREATE TABLE Products (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          ProductName VARCHAR(255) NOT NULL,
                          ProductCode VARCHAR(255) NOT NULL,
                          Price INT NOT NULL,
                          StockQuantity INT NOT NULL,
                          IsAvailable INT NOT NULL,
                          ImageURL VARCHAR(255),
                          CategoryID INT NOT NULL,
                          FOREIGN KEY (CategoryID) REFERENCES Categories(ID)
);

CREATE TABLE OrderDetails (
                              ID INT IDENTITY(1,1) PRIMARY KEY,
                              Quantity INT NOT NULL,
                              Price INT NOT NULL,
                              OrdersID INT NOT NULL,
                              ProductsID INT NOT NULL,
                              FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                              FOREIGN KEY (ProductsID) REFERENCES Products(ID)
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
-- Insert Roles
INSERT INTO Role (RoleName) VALUES ('Admin'), ('Employee');

-- Insert Admin Account
INSERT INTO Accounts (UserName, Password, Email, Phone, Adress, RoleID) 
VALUES ('admin', 'admin123', 'admin@example.com', '123456789', '123 Admin St', 1);

-- Insert Employee Accounts
INSERT INTO Accounts (UserName, Password, Email, Phone, Adress, RoleID) 
VALUES ('employee1', 'pass123', 'emp1@example.com', '987654321', '456 Worker St', 2),
       ('employee2', 'pass456', 'emp2@example.com', '654987321', '789 Worker St', 2);

-- Insert Employees
INSERT INTO Employees (EmployeeName, Salary, CCCD, Avatar, AccountsID, Gender, DoB, isAvailable) 
VALUES ('John Doe', 50000, '1234567890', NULL, 2, 1, '1990-05-20', 1),
       ('Jane Smith', 55000, '0987654321', NULL, 3, 2, '1992-07-15', 1);

-- Insert Shifts
INSERT INTO Shifts (ShiftName, StartTime, EndTime) 
VALUES ('Morning', '00:00:00', '08:00:00'),
       ('Afternoon', '08:00:00', '16:00:00'),
       ('Night', '16:00:00', '00:00:00');

-- Insert WeekDays
INSERT INTO WeekDays (WeekDay) 
VALUES ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'), ('Saturday'), ('Sunday');

