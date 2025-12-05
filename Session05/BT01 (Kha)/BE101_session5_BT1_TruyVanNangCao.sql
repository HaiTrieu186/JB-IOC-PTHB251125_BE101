create schema if not exists bt1;
set search_path  to bt1;

create table if not exists products(
    product_id serial primary key ,
    product_name varchar(100) not null ,
    category varchar(50)
);

create  table if not exists  orders(
   order_id serial primary key ,
   quantity int check ( quantity >0 ),
   total_price numeric(10,2) not null,
   product_id int references products(product_id)
);

insert into products(product_name, category)
values ('Laptop Dell','Electronics'),
       ('IPhone 15','Electronics'),
       ('Bàn học gỗ','Eurniture'),
       ('Ghế xoay','Furniture');

insert into  orders(quantity, total_price, product_id) values
( 2,2200.00,1),
( 3,3300.00,2),
( 5,2500.00,3),
( 4,1600.00,4),
( 1,1100.00,1);

-- 1. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price))
-- và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
select p.category,
       sum(case when o.total_price isnull then 0 else o.total_price end) as "total_sales",
       sum(case when o.quantity isnull then 0 else o.quantity end) as "total_quanity"

from products p left join orders o on p.product_id = o.product_id
group by p.category;

-- 2. Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select p.category,
       sum(case when o.total_price isnull then 0 else o.total_price end) as "total_sales"
from products p left join orders o on p.product_id = o.product_id
group by category
having sum(case when o.total_price isnull then 0 else o.total_price end) >2000;


-- 3. Sắp xếp kết quả theo tổng doanh thu giảm dần
select p.category,
       sum(case when o.total_price isnull then 0 else o.total_price end) as "total_sales"
from products p left join orders o on p.product_id = o.product_id
group by category
order by sum(case when o.total_price isnull then 0 else o.total_price end) desc;
