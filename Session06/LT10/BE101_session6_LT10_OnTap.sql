CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt10;

set search_path to lt10;

DROP TABLE IF EXISTS OldCustomers;
DROP TABLE IF EXISTS NewCustomers;

CREATE TABLE OldCustomers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE NewCustomers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO OldCustomers (name, city)
VALUES ('Nguyen Van A', 'Ha Noi'),
       ('Tran Thi B', 'Da Nang'),
       ('Le Van C', 'Ho Chi Minh'),
       ('Pham Van D', 'Ha Noi'),
       ('Hoang Thi E', 'Hai Phong');

INSERT INTO NewCustomers (name, city)
VALUES ('Le Van C', 'Ho Chi Minh'),
       ('Nguyen Van A', 'Ha Noi'),
       ('Doan Van F', 'Ho Chi Minh'),
       ('Vu Thi G', 'Can Tho'),
       ('Ngo Van H', 'Ho Chi Minh');


-- 1.Lấy danh sách tất cả khách hàng (cũ + mới) không trùng lặp (UNION)
select name, city
from OldCustomers
union
select name, city
from NewCustomers;

-- 2.Tìm khách hàng vừa thuộc bảng OldCustomers
-- vừa thuộc bảng NewCustomers (INTERSECT)
select name, city
from OldCustomers
intersect
select name, city
from NewCustomers;

-- 3. Tính số lượng khách hàng ở từng thành phố (dùng GROUP BY city)
select customer_union.city, count(customer_union.id)
from (select *
      from OldCustomers
      union
      select *
      from NewCustomers) as customer_union
group by customer_union.city;

-- 4. Tìm thành phố có nhiều khách hàng nhất (dùng Subquery và MAX)
select customer_union.city, count(customer_union.id) as "Số lượng"
from (select *
      from OldCustomers
      union
      select *
      from NewCustomers) as customer_union
group by customer_union.city
having count(customer_union.id) = (select max(customer_by_city."Số lượng")
                                   from (select count(customer_union.id) as "Số lượng"
                                         from (select *
                                               from OldCustomers
                                               union
                                               select *
                                               from NewCustomers) as customer_union
                                         group by customer_union.city) as customer_by_city);



