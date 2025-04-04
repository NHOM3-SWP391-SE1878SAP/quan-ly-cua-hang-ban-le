CREATE DATABASE SLIM7
GO
USE SLIM7
GO

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
                          Adress VARCHAR(255),
                          RoleID INT NOT NULL,
                          FOREIGN KEY (RoleID) REFERENCES Role(ID)
);

CREATE TABLE Customer (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          CustomerName VARCHAR(255) NOT NULL,
                          Phone INT NOT NULL,
                          Address VARCHAR(255),
                          Points INT
);

CREATE TABLE Employees (
                           ID INT IDENTITY(1,1) PRIMARY KEY,
                           EmployeeName VARCHAR(255) NOT NULL,
                           Salary INT NOT NULL,
                           CCCD VARCHAR(255),
                           Avatar VARCHAR(255),
                           AccountsID INT,
                           Gender VARCHAR(10),
                           DoB DATE,
                           isAvailable INT NOT NULL,
                           FOREIGN KEY (AccountsID) REFERENCES Accounts(ID)
);

CREATE TABLE Payroll (
                         ID INT IDENTITY(1,1) PRIMARY KEY,
                         Month INT NOT NULL,
                         Year INT NOT NULL,
                         TotalDebt INT NOT NULL,
                         PayDate DATE,
                         EndDate DATE
);

CREATE TABLE Employees_Payroll (
                                   ID INT IDENTITY(1,1) PRIMARY KEY,
                                   EmployeesID INT NOT NULL,
                                   PayrollID INT NOT NULL,
                                   WorkDays INT,
                                   PayDate DATE,
                                   FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                                   FOREIGN KEY (PayrollID) REFERENCES Payroll(ID)
);

CREATE TABLE Shifts (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        ShiftName VARCHAR(255) NOT NULL,
                        StartTime TIME NOT NULL,
                        EndTime TIME NOT NULL
);

CREATE TABLE WeeklySchedule (
                                ID INT IDENTITY(1,1) PRIMARY KEY,
                                WeekDay VARCHAR(255) NOT NULL,
                                ShiftsID INT NOT NULL,
                                EmployeesID INT NOT NULL,
                                FOREIGN KEY (ShiftsID) REFERENCES Shifts(ID),
                                FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

CREATE TABLE Attendence (
                            ID INT IDENTITY(1,1) PRIMARY KEY,
                            WorkDate DATE NOT NULL,
                            isPresent INT NOT NULL,
                            EmployeesID INT NOT NULL,
                            ShiftsID INT NOT NULL,
                            FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                            FOREIGN KEY (ShiftsID) REFERENCES Shifts(ID)
);

CREATE TABLE Vouchers (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          Code INT NOT NULL,
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

CREATE TABLE Orders (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        OrderDate DATE NOT NULL,
                        TotalAmount INT NOT NULL,
                        CustomerID INT NOT NULL,
                        EmployeesID INT NOT NULL,
                        PaymentsID INT NOT NULL,
                        VouchersID INT NOT NULL,
                        FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
                        FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                        FOREIGN KEY (PaymentsID) REFERENCES Payments(ID),
                        FOREIGN KEY (VouchersID) REFERENCES Vouchers(ID)
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

CREATE TABLE Returns (
                         ID INT IDENTITY(1,1) PRIMARY KEY,
                         Quantity INT NOT NULL,
                         Reason VARCHAR(255),
                         ReturnDate DATE NOT NULL,
                         OrdersID INT NOT NULL,
                         EmployeesID INT NOT NULL,
                         FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                         FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

CREATE TABLE Suppliers (
                           ID INT IDENTITY(1,1) PRIMARY KEY,
                           SupplierName VARCHAR(255) NOT NULL,
                           Phone VARCHAR(255) NOT NULL,
                           Address VARCHAR(255) NOT NULL,
                           Email VARCHAR(255)
);

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
                                    ExpirationDate DATE,
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
                                  SupplierDebtID INT NOT NULL,
                                  FOREIGN KEY (SupplierDebtID) REFERENCES SupplierDebt(ID)
);
