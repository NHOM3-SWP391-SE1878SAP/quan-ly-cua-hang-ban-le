CREATE DATABASE slimDB;
GO
USE slimDB;

CREATE TABLE Roles (
                       ID INT PRIMARY KEY,
                       RoleName VARCHAR(255) NOT NULL
);

CREATE TABLE Accounts (
                          ID INT PRIMARY KEY,
                          UserName VARCHAR(255) NOT NULL,
                          Password VARCHAR(255) NOT NULL,
                          Email VARCHAR(255) NOT NULL,
                          Phone INT NOT NULL,
                          Address VARCHAR(255) NOT NULL,
                          RoleID INT,
                          FOREIGN KEY (RoleID) REFERENCES Roles(ID)
);

CREATE TABLE Employees (
                           ID INT PRIMARY KEY,
                           EmployeeName VARCHAR(255) NOT NULL,
                           Salary INT,
                           CCD INT,
                           Avatar VARCHAR(255),
                           AccountsID INT,
                           FOREIGN KEY (AccountsID) REFERENCES Accounts(ID)
);

CREATE TABLE WorkSchedule (
                              ID INT PRIMARY KEY,
                              WorkDate DATE,
                              StartTime TIME,
                              EndTime TIME,
                              CheckIn DATETIME,
                              CheckOut DATETIME,
                              EmployeesID INT,
                              FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

CREATE TABLE Customer (
                          ID INT PRIMARY KEY,
                          CustomerName VARCHAR(255) NOT NULL,
                          Phone INT NOT NULL,
                          Address VARCHAR(255) NOT NULL,
                          Points INT NOT NULL
);

CREATE TABLE Vouchers (
                          ID INT PRIMARY KEY,
                          Code INT,
                          MinOrder INT,
                          DiscountRate INT,
                          MaxValue INT,
                          StartDate DATE,
                          EndDate DATE
);

CREATE TABLE Orders (
                        ID INT PRIMARY KEY,
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

CREATE TABLE Payments (
                          ID INT PRIMARY KEY,
                          PaymentDate DATE,
                          PaymentMethods VARCHAR(255) NOT NULL
);

CREATE TABLE OrderDetails (
                              ID INT PRIMARY KEY,
                              Quantity INT,
                              OrdersID INT,
                              ProductsID INT,
                              FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                              FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);

CREATE TABLE Returns (
                         ID INT PRIMARY KEY,
                         Quantity INT,
                         Reason VARCHAR(255),
                         ReturnDate DATE,
                         OrdersID INT,
                         EmployeesID INT,
                         FOREIGN KEY (OrdersID) REFERENCES Orders(ID),
                         FOREIGN KEY (EmployeesID) REFERENCES Employees(ID)
);

CREATE TABLE Products (
                          ID INT PRIMARY KEY,
                          ProductName VARCHAR(255) NOT NULL,
                          ProductCode VARCHAR(255),
                          Price INT,
                          StockQuantity INT,
                          IsAvailable BIT,
                          ImageURL VARCHAR(255),
                          CategoryID INT,
                          FOREIGN KEY (CategoryID) REFERENCES Categories(ID)
);

CREATE TABLE Categories (
                            ID INT PRIMARY KEY,
                            CategoryName VARCHAR(255) NOT NULL,
                            Description VARCHAR(255),
                            Image VARCHAR(255)
);

CREATE TABLE Suppliers (
                           ID INT PRIMARY KEY,
                           SupplierName VARCHAR(255),
                           Phone INT,
                           Address VARCHAR(255),
                           Email VARCHAR(255)
);

CREATE TABLE GoodReceiptDetails (
                                    ID INT PRIMARY KEY,
                                    BatchNumber VARCHAR(255),
                                    QuantityReceived INT,
                                    UnitCost INT,
                                    ExpirationDate DATE,
                                    GoodsReceiptID INT,
                                    ProductsID INT,
                                    FOREIGN KEY (ProductsID) REFERENCES Products(ID)
);

CREATE TABLE GoodsReceipt (
                              ID INT PRIMARY KEY,
                              ReceivedDate DATE,
                              TotalCost INT,
                              SuppliersID INT,
                              FOREIGN KEY (SuppliersID) REFERENCES Suppliers(ID)
);

CREATE TABLE SupplierPayments (
                                  ID INT PRIMARY KEY,
                                  AmountPaid INT,
                                  PaymentDate DATE,
                                  PaymentMethod VARCHAR(255),
                                  Notes VARCHAR(255),
                                  SupplierID INT,
                                  FOREIGN KEY (SupplierID) REFERENCES Suppliers(ID)
);

CREATE TABLE SupplierDebt (
                              ID INT PRIMARY KEY,
                              TotalDebt INT,
                              LastUpdate DATE,
                              GoodsReceiptID INT,
                              FOREIGN KEY (GoodsReceiptID) REFERENCES GoodsReceipt(ID)
);

CREATE TABLE EmployeesPayroll (
                                  ID INT PRIMARY KEY,
                                  EmployeesID INT,
                                  PayRollID INT,
                                  WorkDays INT,
                                  PayDate DATE,
                                  FOREIGN KEY (EmployeesID) REFERENCES Employees(ID),
                                  FOREIGN KEY (PayRollID) REFERENCES Payroll(ID)
);

CREATE TABLE Payroll (
                         ID INT PRIMARY KEY,
                         MonthYear VARCHAR(255),
                         StartDate DATE,
                         EndDate DATE
);
