-- Thêm danh mục sản phẩm
INSERT INTO Categories (CategoryName, Description) VALUES 
('Đồ uống', 'Các loại nước giải khát, cà phê, trà sữa'),
('Đồ ăn nhanh', 'Các món ăn nhanh, tiện lợi'),
('Bánh kẹo', 'Các loại bánh, kẹo, snack'),
('Kem', 'Các loại kem các vị');

-- Thêm sản phẩm cho từng danh mục
-- Đồ uống (CategoryID: 1)
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, CategoryID) VALUES
('Trà sữa trân châu', 'TS001', 35000, 100, 1, 1),
('Cà phê sữa đá', 'CF001', 25000, 100, 1, 1),
('Sinh tố dâu', 'ST001', 40000, 50, 1, 1),
('Nước cam ép', 'NC001', 30000, 50, 1, 1);

-- Đồ ăn nhanh (CategoryID: 2)
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, CategoryID) VALUES
('Hamburger bò', 'HB001', 45000, 30, 1, 2),
('Gà rán', 'GR001', 65000, 40, 1, 2),
('Khoai tây chiên', 'KT001', 25000, 50, 1, 2),
('Xúc xích chiên', 'XX001', 30000, 45, 1, 2);

-- Bánh kẹo (CategoryID: 3)
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, CategoryID) VALUES
('Bánh mì ngọt', 'BM001', 15000, 60, 1, 3),
('Bánh quy socola', 'BQ001', 25000, 70, 1, 3),
('Kẹo dẻo', 'KD001', 20000, 80, 1, 3),
('Snack khoai tây', 'SK001', 15000, 100, 1, 3);

-- Kem (CategoryID: 4)
INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, CategoryID) VALUES
('Kem vani', 'KEM001', 20000, 50, 1, 4),
('Kem socola', 'KEM002', 20000, 50, 1, 4),
('Kem dâu', 'KEM003', 25000, 40, 1, 4),
('Kem matcha', 'KEM004', 25000, 40, 1, 4);

-- Thêm khách hàng
INSERT INTO Customer (CustomerName, Phone, Address, Points) VALUES
('Nguyễn Văn A', '0901234567', '123 Đường A, Quận 1, TP.HCM', 100),
('Trần Thị B', '0912345678', '456 Đường B, Quận 2, TP.HCM', 50),
('Lê Văn C', '0923456789', '789 Đường C, Quận 3, TP.HCM', 75),
('Phạm Thị D', '0934567890', '321 Đường D, Quận 4, TP.HCM', 25);

-- Thêm phương thức thanh toán
INSERT INTO Payments (PaymentDate, PaymentMethods) VALUES
('2024-03-16', 'Tiền mặt'),
('2024-03-16', 'Chuyển khoản'),
('2024-03-16', 'Thẻ tín dụng');

-- Thêm Orders và OrderDetails cho ngày 16/03/2024
-- Đơn hàng buổi sáng
INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 07:30:00', 85000, 1, 1, 1);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(2, 35000, @@IDENTITY, 1), -- 2 trà sữa
(1, 15000, @@IDENTITY, 9); -- 1 bánh mì

INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 08:45:00', 110000, 2, 2, 2);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(1, 45000, @@IDENTITY, 5), -- 1 hamburger
(2, 25000, @@IDENTITY, 2), -- 2 cà phê sữa đá
(1, 15000, @@IDENTITY, 12); -- 1 snack

-- Đơn hàng buổi trưa
INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 11:30:00', 155000, 3, 1, 1);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(1, 65000, @@IDENTITY, 6), -- 1 gà rán
(2, 30000, @@IDENTITY, 8), -- 2 xúc xích
(2, 15000, @@IDENTITY, 9); -- 2 bánh mì

INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 12:45:00', 130000, 4, 2, 3);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(2, 35000, @@IDENTITY, 1), -- 2 trà sữa
(2, 30000, @@IDENTITY, 4); -- 2 nước cam

-- Đơn hàng buổi chiều
INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 14:30:00', 95000, 1, 1, 2);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(1, 45000, @@IDENTITY, 5), -- 1 hamburger
(2, 25000, @@IDENTITY, 10); -- 2 bánh quy

INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 16:15:00', 185000, 2, 2, 1);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(2, 35000, @@IDENTITY, 1), -- 2 trà sữa
(1, 65000, @@IDENTITY, 6), -- 1 gà rán
(2, 25000, @@IDENTITY, 13); -- 2 kem dâu

-- Đơn hàng buổi tối
INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 18:30:00', 160000, 3, 1, 3);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(2, 45000, @@IDENTITY, 5), -- 2 hamburger
(2, 35000, @@IDENTITY, 1); -- 2 trà sữa

INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 20:00:00', 115000, 4, 2, 2);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(1, 65000, @@IDENTITY, 6), -- 1 gà rán
(2, 25000, @@IDENTITY, 14); -- 2 kem matcha

-- Đơn hàng cuối ngày
INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID) VALUES 
('2024-03-16 21:45:00', 140000, 1, 1, 1);
INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) VALUES 
(2, 35000, @@IDENTITY, 1), -- 2 trà sữa
(1, 45000, @@IDENTITY, 5), -- 1 hamburger
(1, 25000, @@IDENTITY, 10); -- 1 bánh quy
