CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt1;

set search_path to lt1;

CREATE table if not exists Product
(
    id       serial primary key,
    name     varchar(100),
    category varchar(50),
    price    numeric(10, 2),
    stock    int
);

-- 1.Thêm 5 sản phẩm vào bảng bằng lệnh INSERT
INSERT INTO Product(name, category, price, stock)
VALUES ('Laptop Dell XPS 15', 'Điện tử', 15000000.00, 10),
       ('Chuột Logitech G304', 'Phụ kiện', 450000.50, 50),
       ('Bàn phím cơ Keychron', 'Phụ kiện', 8500000.00, 20),
       ('Áo thun Coolmate', 'Thời trang', 1200000.00, 100),
       ('Tai nghe Sony WH-1000XM5', 'Điện tử', 3500000.00, 5);

drop  table  Product;

-- 2. Hiển thị danh sách toàn bộ sản phẩm
select *
from Product;

-- 3. Hiển thị 3 sản phẩm có giá cao nhất
select *
from Product
order by price desc
limit 3;

-- 4. Hiển thị các sản phẩm thuộc danh mục “Điện tử” có giá nhỏ hơn 10,000,000
select *
from Product
where category = 'Điện tử' and price<10000000;


-- 5.Sắp xếp sản phẩm theo số lượng tồn kho tăng dần
select *
from Product
order by stock;