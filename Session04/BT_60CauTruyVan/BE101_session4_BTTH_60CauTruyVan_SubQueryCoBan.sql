CREATE database session05;

create schema if not exists BTTH;
set search_path to BTTH;

----- Subquery
--1. Liệt kê khách hàng có tổng doanh thu lớn hơn trung bình.
select c.CustomerID,
       c.CustomerName,
       SUM(od.Quantity * p.price) as "Tổng doanh thu"
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
         join Products p on od.ProductID = p.ProductID
group by c.CustomerID
having SUM(od.Quantity * p.price) >
       (select SUM(od.Quantity * p.price) / Count(distinct c.CustomerID)
        from Customers c
                 join Orders o on c.CustomerID = o.CustomerID
                 join OrderDetails od on o.OrderID = od.OrderID
                 join Products p on od.ProductID = p.ProductID);

--2. Liệt kê sản phẩm có giá cao hơn giá trung bình.
select p.*
from Products p
where p.Price > (select AVG(p.Price)
                 from Products p);

-- 3. Liệt kê nhân viên có số đơn hàng nhiều hơn trung bình.
select e.EmployeeID, e.EmployeeName, count(o.OrderID) as "Số đơn hàng"
from Employees e
         join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID
having count(o.OrderID) > (select (count(o.OrderID) * 1.0) / count(distinct e.EmployeeID) as "Trung bình số đơn hàng"
                           from Employees e
                                    join Orders o on e.EmployeeID = o.EmployeeID);


-- 4. Liệt kê khách hàng mua nhiều sản phẩm nhất (em hiểu là số lượng mua).
-- select c.CustomerID, c.CustomerName, od.ProductID, sum(od.Quantity)
-- from Customers c
--          join Orders o on c.CustomerID = o.CustomerID
--          join OrderDetails od on o.OrderID = od.OrderID
-- group by c.CustomerID, od.ProductID
-- order by c.CustomerID;
select c.CustomerID, c.CustomerName, sum(od.Quantity) as "Sản phẩm đã mua"
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
group by c.CustomerID
having sum(od.Quantity) = (select sum(od.Quantity) as "Sản phẩm đã mua"
                           from Customers c
                                    join Orders o on c.CustomerID = o.CustomerID
                                    join OrderDetails od on o.OrderID = od.OrderID
                           group by c.CustomerID
                           order by sum(od.Quantity) desc
                           limit 1)
order by c.CustomerID;


-- 5. Liệt kê sản phẩm được mua nhiều nhất.
select p.ProductID, p.ProductName, sum(od.Quantity)
from Products p
         join OrderDetails od on p.ProductID = od.ProductID
group by p.ProductID
having sum(od.Quantity) = (select sum(od.Quantity)
                           from Products p
                                    join OrderDetails od on p.ProductID = od.ProductID
                           group by p.ProductID
                           order by sum(od.Quantity) desc
                           limit 1);


--6. Liệt kê khách hàng có đơn hàng gần nhất.
select distinct c.*
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
where o.OrderDate = (select Max(o.OrderDate)
                     from Orders o);

-- 7. Liệt kê nhân viên xử lý đơn hàng gần nhất.
select distinct e.*
from Employees e
         join Orders o on e.EmployeeID = o.EmployeeID
where o.OrderDate = (select Max(o.OrderDate)
                     from Orders o);

-- 8. Liệt kê sản phẩm có số lượng bán ra nhiều hơn sản phẩm "Phone".
select p.ProductID, p.ProductName, SUM(Quantity)
from Products p
         join OrderDetails OD on p.ProductID = OD.ProductID
group by p.ProductID
having sum(Quantity) > (select SUM(Quantity)
                        from OrderDetails od
                        where od.ProductID = 2
                        group by od.ProductID)
order by p.ProductID;

-- 9.Liệt kê khách hàng có tổng số lượng mua nhiều hơn khách hàng "Tran Thi B".
select c.CustomerID, c.CustomerName, sum(Quantity)
from Customers c
         join Orders O on c.CustomerID = O.CustomerID
         join OrderDetails od on O.OrderID = od.OrderID
group by c.CustomerID
having sum(Quantity)> (select SUM(Quantity)
                       from Orders o
                                join OrderDetails od on o.OrderID = od.OrderID
                       where o.CustomerID = 2
                       group by o.CustomerID)
order by c.CustomerID;

-- 10.  Liệt kê sản phẩm có giá cao nhất trong từng loại.
select *
from Products
where (Category, Price) in (select p.category, max(p.Price)
                            from Products p
                            group by p.category);





