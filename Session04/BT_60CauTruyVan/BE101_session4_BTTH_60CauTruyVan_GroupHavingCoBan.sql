

create schema if not exists BTTH;
set search_path to BTTH;


--- GROUP BY HAVING
-- 1. Tính tổng số lượng sản phẩm bán ra theo từng sản phẩm.
--- C1: chỉ đếm các sp đã bán
select ProductID, SUM(Quantity) as "Số lượng bán ra"
from OrderDetails
group by ProductID
order by ProductID;

--- C2: Đếm tất cả sản phẩm (kể cả chưa bán)
select p.ProductID, p.ProductName, SUM(CASE WHEN od.Quantity isnull THEN 0 ELSE od.Quantity END) as "Số lượng bán ra"
from Products p
         left join OrderDetails od on p.ProductID = od.ProductID
group by p.ProductID
order by p.ProductID;


-- 2. Tính tổng doanh thu theo từng sản phẩm.
select p.ProductID,
       p.ProductName,
       p.Price,
       SUM((case when od.Quantity isnull then 0 else od.Quantity end))           as "Tổng số lượng bán",
       SUM(p.Price * (case when od.Quantity isnull then 0 else od.Quantity end)) as "Tổng doanh thu"
from Products p
         left join OrderDetails od on p.ProductID = od.ProductID
group by p.ProductID
order by p.ProductID;


-- 3. Tính tổng doanh thu theo từng khách hàng.
select c.CustomerID,
       c.CustomerName,
       SUM((case when od.Quantity isnull then 0 else od.Quantity end) *
           (case when p.Price isnull then 0 else p.price end)) as "Tổng doanh thu"
from Customers c
         left join Orders o on c.CustomerID = o.CustomerID
         left join OrderDetails od on o.OrderID = od.OrderID
         left join Products p on od.ProductID = p.ProductID
group by c.CustomerID
order by c.CustomerID;


-- 4. Tính tổng doanh thu theo từng nhân viên.
select e.EmployeeID,
       e.EmployeeName,
       SUM((case when od.Quantity isnull then 0 else od.Quantity end) *
           (case when p.Price isnull then 0 else p.price end)) as "Tổng doanh thu"
from Employees e
         left join Orders o on e.EmployeeID = o.EmployeeID
         left join OrderDetails od on o.OrderID = od.OrderID
         left join Products p on od.ProductID = p.ProductID
group by e.EmployeeID
order by e.EmployeeID;


-- 5. Liệt kê sản phẩm có doanh thu > 1000.
-- (do tìm >1000 nên không cần left join vì left join sẽ có sp không có doanh thu)
select p.ProductID,
       p.ProductName,
       SUM(od.Quantity * p.price) as "Tổng doanh thu"
from Products p
         join OrderDetails OD on p.ProductID = OD.ProductID
group by p.ProductID
having SUM(od.Quantity * p.price) > 1000
order by p.ProductID;


-- 6. Liệt kê khách hàng có tổng số lượng mua > 5.
--- (do tìm số lượng mua >5 nên không cần dùng left join)
select c.CustomerID, c.CustomerName, SUM(od.Quantity) as "Số lượng mua"
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
         join OrderDetails od on o.OrderID = od.OrderID
group by c.CustomerID
having SUM(od.Quantity) > 5
order by c.CustomerID;


-- 7. Liệt kê nhân viên có doanh thu trung bình > 500.

-- Kiểm tra xem lệnh bên dưới tính đúng chưa
-- select e.EmployeeID, e.EmployeeName,o.OrderID,
--        SUM( od.Quantity*p.price ) as "Tổng Doanh thu "
-- from Employees e
--          join Orders o on e.EmployeeID = o.EmployeeID
--          join OrderDetails od on o.OrderID = od.OrderID
--          join Products p on od.ProductID = p.ProductID
-- group by e.EmployeeID, o.OrderID
-- order by e.EmployeeID;

select e.EmployeeID,
       e.EmployeeName,
       SUM(od.Quantity * p.price)                             as "Tổng Doanh thu ",
       COUNT(distinct o.OrderID)                              as "Số dơn hàng",
       SUM(od.Quantity * p.price) / COUNT(distinct o.OrderID) as "Doanh thu trung bình"
from Employees e
         join Orders o on e.EmployeeID = o.EmployeeID
         join OrderDetails od on o.OrderID = od.OrderID
         join Products p on od.ProductID = p.ProductID
group by e.EmployeeID
having SUM(od.Quantity * p.price) / COUNT(distinct o.OrderID) > 500
order by e.EmployeeID;


-- 8. Liệt kê thành phố có nhiều khách hàng nhất.
-- TH1: dem so khach hang hien co theo thanh pho

select c.city, Count(c.CustomerID)
from Customers c
group by c.city
having count(c.CustomerID) = (select Count(c.CustomerID)
                              from Customers c
                              group by c.city
                              order by Count(c.CustomerID) desc
                              limit 1)
order by c.city;


-- TH2: em hieu la dem so khach hang da mua theo tung thanh pho
select c.city, COUNT(distinct c.CustomerID) as "Số khách hàng"
from Customers c
         join Orders O on c.CustomerID = O.CustomerID
group by c.city
having COUNT(distinct c.CustomerID) = (select COUNT(distinct c.CustomerID)
                                       from Customers c
                                                join Orders O on c.CustomerID = O.CustomerID
                                       group by c.city
                                       order by COUNT(distinct c.CustomerID) DESC
                                       limit 1);


-- 9. Liệt kê loại sản phẩm có tổng doanh thu cao nhất.
SELECT p.category, SUM(od.Quantity * p.price) as "Tổng doanh thu"
from Products p
         join OrderDetails OD on p.ProductID = OD.ProductID
group by p.category
having SUM(od.Quantity * p.price) = (SELECT SUM(od.Quantity * p.price)
                                     from Products p
                                              join OrderDetails OD on p.ProductID = OD.ProductID
                                     group by p.category
                                     order by SUM(od.Quantity * p.price) desc
                                     limit 1);

-- 10. Liệt kê khách hàng có nhiều đơn hàng nhất.
select c.CustomerID, c.CustomerName, count(o.OrderID)
from Customers c
         join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerID
having Count(o.OrderID) =
       (select Count(o.OrderID)
        from Customers c
                 join Orders o on c.CustomerID = o.CustomerID
        group by c.CustomerID
        order by Count(o.OrderID) desc
        limit 1)
order by c.CustomerID;


