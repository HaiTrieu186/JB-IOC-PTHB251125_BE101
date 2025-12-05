CREATE database session05;

create schema if not exists BTTH;
set search_path to BTTH;

-- Bảng khách hàng
CREATE TABLE Customers
(
    CustomerID   serial PRIMARY KEY,
    CustomerName VARCHAR(100),
    City         VARCHAR(50),
    Country      VARCHAR(50)
);

-- Bảng nhân viên
CREATE TABLE Employees
(
    EmployeeID   serial PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department   VARCHAR(50)
);

-- Bảng sản phẩm
CREATE TABLE Products
(
    ProductID   serial PRIMARY KEY,
    ProductName VARCHAR(100),
    Category    VARCHAR(50),
    Price       DECIMAL(10, 2)
);

-- Bảng đơn hàng
CREATE TABLE Orders
(
    OrderID    serial PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate  DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE OrderDetails
(
    OrderDetailID serial PRIMARY KEY,
    OrderID       INT,
    ProductID     INT,
    Quantity      INT,
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

-- Dữ liệu mẫu
INSERT INTO Customers (CustomerName, City, Country)
VALUES ('Nguyen Van A', 'Hanoi', 'Vietnam'),
       ('Tran Thi B', 'HCM', 'Vietnam'),
       ('Le Van C', 'Da Nang', 'Vietnam'),
       ('Pham Thi D', 'Hue', 'Vietnam'),
       ('Hoang Van E', 'Hai Phong', 'Vietnam'),
       ('Do Thi F', 'Can Tho', 'Vietnam'),
       ('Nguyen Van G', 'Hanoi', 'Vietnam'),
       ('Tran Van H', 'HCM', 'Vietnam'),
       ('Le Thi I', 'Da Nang', 'Vietnam'),
       ('Pham Van J', 'Hue', 'Vietnam');

INSERT INTO Employees (EmployeeName, Department)
VALUES ('Nguyen Van K', 'Sales'),
       ('Tran Van L', 'Support'),
       ('Le Thi M', 'Sales'),
       ('Pham Van N', 'IT'),
       ('Hoang Thi O', 'Sales');

INSERT INTO Products (ProductName, Category, Price)
VALUES ('Laptop', 'Electronics', 1200),
       ('Phone', 'Electronics', 800),
       ('Tablet', 'Electronics', 600),
       ('Desktop', 'Electronics', 1500),
       ('Monitor', 'Electronics', 300),
       ('Desk', 'Furniture', 200),
       ('Chair', 'Furniture', 100),
       ('Bookshelf', 'Furniture', 250),
       ('Printer', 'Office', 400),
       ('Scanner', 'Office', 350);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate)
VALUES (1, 1, '2025-11-01'),
       (2, 1, '2025-11-02'),
       (3, 2, '2025-11-03'),
       (4, 3, '2025-11-04'),
       (5, 4, '2025-11-05'),
       (6, 5, '2025-11-06'),
       (7, 1, '2025-11-07'),
       (8, 2, '2025-11-08'),
       (9, 3, '2025-11-09'),
       (10, 4, '2025-11-10');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES (1, 1, 2),   -- Laptop
       (1, 2, 1),   -- Phone
       (2, 3, 3),   -- Tablet
       (2, 6, 2),   -- Desk
       (3, 4, 1),   -- Desktop
       (3, 7, 5),   -- Chair
       (4, 5, 2),   -- Monitor
       (4, 8, 1),   -- Bookshelf
       (5, 9, 4),   -- Printer
       (5, 10, 2),  -- Scanner
       (6, 2, 5),   -- Phone
       (6, 3, 2),   -- Tablet
       (7, 1, 1),   -- Laptop
       (7, 7, 10),  -- Chair
       (8, 4, 2),   -- Desktop
       (8, 6, 3),   -- Desk
       (9, 5, 4),   -- Monitor
       (9, 9, 1),   -- Printer
       (10, 10, 5), -- Scanner
       (10, 8, 2);
-- Bookshelf


