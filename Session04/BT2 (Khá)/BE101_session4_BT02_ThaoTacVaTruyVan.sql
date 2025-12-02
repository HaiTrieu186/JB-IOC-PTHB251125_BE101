CREATE SCHEMA if not exists BT2;
set search_path to BT2;

CREATE table if not exists products
(
    id       serial,
    name     varchar(50),
    category varchar(50),
    price    decimal(10, 2),
    stock    int,
    constraint pk_products primary key (id)
);

INSERT INTO products (name, category, price, stock)
values ('Laptop Dell', 'Electronics', 1500.00, 5),
       ('Chuột logitech', 'Electronics', 25.50, 50),
       ('Bàn phím Razer', 'Electronics', 120.00, 20),
       ('Tủ lạnh LG', 'Home Appliances', 800.00, 3),
       ('Máy giặt Samsung', 'Home Appliances', 600.00, 2);


-- 1. Thêm sản phẩm mới
INSERT INTO products (name, category, price, stock)
values ('Điều hòa Panasonic','Home Appliances',400.00,10);

-- 2. Cập nhật stock của 'Laptop Dell'
UPDATE products
set stock=7
where name='Laptop Dell'

-- 3. Xóa sản phẩm stock =0
Delete from products
where  stock=0;

-- 4.Liệt k tất cả sản phẩm theo giá tăng dần
select *
from products
order by price asc;

-- 5. Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
SELECT  distinct category
from products;

-- 6. Liệt kê sản phẩm có giá từ 100 đến 1000
select *
from products
where price between 100.00 and 1000.00;

-- 7. Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng LIKE/ILIKE)
select *
from products
where  name ILIKE '%LG%' Or name ilike '%Samsung%';


-- 8a. Hiển thị 2 sản phẩm đầu tiên theo giá giảm dần,
select *
from products
order by price desc
limit 2;

-- 8b. Hiển thị sản phẩm thứ 2 đến thứ 3 bằng LIMIT và OFFSET (theo giá giảm dần)
select *
from products
order by price desc
limit 2
offset 1;