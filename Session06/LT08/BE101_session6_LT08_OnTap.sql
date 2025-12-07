CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt8;

set search_path to lt8;

CREATE TABLE Customer
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES Customer (id),
    total_amount NUMERIC(10, 2),
    order_date   DATE
);


INSERT INTO Customer (name)
VALUES ('Nguyễn Văn Đại Gia'),
       ('Trần Thị Bình Dân'),
       ('Lê Văn Tiết Kiệm'),
       ('Phạm Thị Chỉ Ngắm');

INSERT INTO Orders (customer_id, total_amount, order_date)
VALUES (1, 5000000, '2024-01-10'),
       (1, 4000000, '2024-01-15'),
       (2, 2000000, '2024-02-01'),
       (2, 1000000, '2024-02-05'),
       (3, 500000, '2024-03-01');


-- 1. Hiển thị tên khách hàng và tổng tiền đã mua,
-- sắp xếp theo tổng tiền giảm dần
select c.id, c.name, sum(o.total_amount) as "Tổng tiền đã mua"
from Customer c
         join Orders O on c.id = O.customer_id
group by c.id;

-- 2. Tìm khách hàng có tổng chi tiêu cao nhất (dùng Subquery với MAX)
select c.id, c.name, sum(o.total_amount) as "Tổng tiền đã mua"
from Customer c
         join Orders O on c.id = O.customer_id
group by c.id
having sum(o.total_amount) = (select max(chi_tieu."Tổng tiền đã mua")
                              from (select sum(o.total_amount) as "Tổng tiền đã mua"
                                    from Customer c
                                             join Orders O on c.id = O.customer_id
                                    group by c.id) as chi_tieu);


-- 3. Liệt kê khách hàng chưa từng mua hàng (LEFT JOIN + IS NULL)
select c.*
from Customer c
         left join Orders O on c.id = O.customer_id
where o.customer_id isnull;


-- 4. Hiển thị khách hàng có tổng chi tiêu
-- > trung bình của toàn bộ khách hàng (dùng Subquery trong HAVING)
-- tính chi tiêu theo từng khách hàng --> tính trung bình --> so sánh having
select c.id, c.name, sum(o.total_amount) as "Tổng tiền đã mua"
from Customer c
         join Orders O on c.id = O.customer_id
group by c.id
having sum(o.total_amount) > (select avg(chi_tieu."Tổng tiền đã mua")
                              from (select sum(o.total_amount) as "Tổng tiền đã mua"
                                    from Customer c
                                             join Orders O on c.id = O.customer_id
                                    group by c.id) as chi_tieu);




