
set search_path to BTTH;

-- JOIN CƠ BẢN
-- 1. Liệt kê tất cả đơn hàng cùng tên khách hàng.
select o.*, c.CustomerName
from Orders o
         join Customers c on o.CustomerID = c.CustomerID;

-- 2. Liệt kê đơn hàng kèm tên nhân viên xử lý.
select o.*, e.EmployeeName
from Orders o
         join Employees e on o.EmployeeID = e.EmployeeID;

-- 3. Liệt kê chi tiết đơn hàng (OrderID, ProductName, Quantity).
---- C1: bị thừa 1 bảng
select o.OrderID, p.ProductName, od.Quantity
from Orders o
         left join OrderDetails od on o.OrderID = od.OrderID
         left join Products p on od.ProductID = p.ProductID;
---- C2:
select od.OrderID, p.ProductName, od.Quantity
from OrderDetails od
         join Products p on od.ProductID = p.ProductID;

-- 4. Liệt kê khách hàng và sản phẩm họ đã mua.
select c.CustomerName, p.ProductName, od.Quantity
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
         join Products p on od.ProductID = p.ProductID;

-- 5. Liệt kê nhân viên và khách hàng mà họ phục vụ.
select e.*, c.CustomerName
from Employees e
         left join Orders o on e.EmployeeID = o.EmployeeID
         left join Customers c on o.CustomerID = c.CustomerID;

-- 6. Liệt kê khách hàng ở Hà Nội và sản phẩm họ mua.
select c.CustomerID, c.CustomerName, p.ProductName, od.Quantity
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
         join Products p on od.ProductID = p.ProductID
where c.City = 'Hanoi';

-- 7 Liệt kê tất cả đơn hàng cùng tên khách hàng và nhân viên.
select o.OrderID, e.EmployeeName, c.CustomerName
from Orders o
         join Employees e on o.EmployeeID = e.EmployeeID
         join Customers c on o.CustomerID = c.CustomerID;

-- 8. Liệt kê sản phẩm và số lượng bán ra trong từng đơn hàng.
select od.OrderID, p.ProductName, od.Quantity
from OrderDetails od
         join Products p on od.ProductID = p.ProductID
order by od.OrderID;

-- 9. Liệt kê khách hàng và số lượng sản phẩm họ đã mua.
select c.CustomerID, c.CustomerName, SUM(od.Quantity) as "Số lượng đã mua"
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
         join Products p on od.ProductID = p.ProductID
group by c.CustomerID
order by c.CustomerID;

-- 10.  Liệt kê nhân viên và tổng số đơn hàng họ xử lý.
select o.EmployeeID, count(o.OrderID) as "Số đơn xử lý"
from Orders o
group by o.EmployeeID
order by o.EmployeeID;


-- tính tổng slg sp theo từng sp
select p.ProductID, p.ProductName, SUm(o.Quantity)
from OrderDetails o
         join Products p on o.ProductID = p.ProductID
group by p.ProductID
order by p.ProductID;

