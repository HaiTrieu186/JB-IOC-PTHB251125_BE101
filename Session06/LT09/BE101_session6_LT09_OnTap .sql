CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt9;

set search_path to lt9;

DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS Product;

CREATE TABLE Product
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(100),
    category VARCHAR(50),
    price    NUMERIC(10, 2)
);

CREATE TABLE OrderDetail
(
    id         SERIAL PRIMARY KEY,
    order_id   INT,
    product_id INT references Product (id),
    quantity   INT
);

INSERT INTO Product (name, category, price)
VALUES ('Laptop Dell XPS', 'Electronics', 25000000),
       ('iPhone 15 Pro', 'Electronics', 30000000),
       ('Samsung TV 4K', 'Electronics', 12000000),
       ('Áo Thun Coolmate', 'Fashion', 200000),
       ('Quần Jean Levi', 'Fashion', 1500000),
       ('Giày Nike Air', 'Fashion', 3000000),
       ('Nồi Cơm Điện', 'Home Appliance', 1800000),
       ('Máy Lọc Không Khí', 'Home Appliance', 4000000),
       ('Ghế Gaming', 'Furniture', 5000000);

INSERT INTO OrderDetail (order_id, product_id, quantity)
VALUES (101, 1, 2),
       (101, 4, 10),
       (102, 2, 1),
       (102, 5, 2),
       (103, 1, 1),
       (103, 3, 5),
       (104, 7, 2),
       (105, 2, 3),
       (106, 6, 1);


-- 1.Tính tổng doanh thu từng sản phẩm,
-- hiển thị product_name, total_sales (SUM(price * quantity))
select p.id,
       p.name,
       sum(p.price * od.quantity) as "total_sales"
from Product p
         join OrderDetail od on p.id = od.product_id
group by p.id
order by p.id;

-- 2. Tính doanh thu trung bình theo từng loại sản phẩm
-- (GROUP BY category)
select p.category, avg(p.price * od.quantity) as "doanh thu trung bình"
from Product p
         join OrderDetail OD on p.id = OD.product_id
group by p.category;

-- 3. Chỉ hiển thị các loại
-- sản phẩm có doanh thu trung bình > 20 triệu (HAVING)
select p.*
from Product p
         join OrderDetail od on p.id = od.product_id
group by p.id
having avg(p.price * od.quantity) > 20000000
order by p.id;


-- 4. Hiển thị tên sản phẩm có doanh thu cao hơn
-- doanh thu trung bình toàn bộ sản phẩm (dùng Subquery)
select p.name, sum(p.price * od.quantity)
from Product p
         join OrderDetail od on p.id = od.product_id
group by p.id
having sum(p.price * od.quantity) >
       (select avg(doanh_thu."doanh thu")
        from (select sum(p.price * od.quantity) as "doanh thu"
              from Product p
                       join OrderDetail od on p.id = od.product_id
              group by p.id) as doanh_thu);

-- 5.Liệt kê toàn bộ sản phẩm và số lượng bán được (nếu có)
--– kể cả sản phẩm chưa có đơn hàng (LEFT JOIN)
select p.id, p.name,
       sum(case when od.quantity isnull then 0 else od.quantity end) as "Số lượng bán"
from Product p left join OrderDetail od on p.id = od.product_id
group by p.id;





