create schema if not exists bt4;
set search_path to bt4;

DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer
(
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(100),
    region      VARCHAR(50)
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customer (customer_id),
    total_amount DECIMAL(10, 2),
    order_date   DATE,
    status       VARCHAR(20)
);

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10, 2),
    category   VARCHAR(50)
);

CREATE TABLE order_detail
(
    order_id   INT REFERENCES orders (order_id),
    product_id INT REFERENCES product (product_id),
    quantity   INT
);

INSERT INTO customer (full_name, region)
VALUES ('Nguyen Van An', 'North'),
       ('Tran Thi Binh', 'South'),
       ('Le Van Cuong', 'Central'),
       ('Pham Thi Dung', 'North'),
       ('Hoang Van Em', 'South'),
       ('Doan Thi Phuong', 'West'),
       ('Vo Van Giap', 'North'),
       ('Ngo Thi Hanh', 'Central');

INSERT INTO product (name, price, category)
VALUES ('Laptop Dell XPS', 1500.00, 'Electronics'),
       ('iPhone 15 Pro', 1200.00, 'Electronics'),
       ('Samsung Galaxy S24', 1100.00, 'Electronics'),
       ('Ao Thun Basic', 15.00, 'Fashion'),
       ('Quan Jean Levi', 50.00, 'Fashion'),
       ('Giay Nike Air', 120.00, 'Fashion'),
       ('Sach SQL Database', 30.00, 'Books'),
       ('Ban Phim Co', 80.00, 'Electronics');

INSERT INTO orders (customer_id, total_amount, order_date, status)
VALUES (1, 1530.00, '2023-10-01', 'Completed'),
       (2, 1200.00, '2023-10-02', 'Pending'),
       (3, 50.00, '2023-10-03', 'Completed'),
       (1, 15.00, '2023-10-05', 'Cancelled'),
       (4, 2400.00, '2023-10-06', 'Completed'),
       (5, 120.00, '2023-10-07', 'Shipping'),
       (2, 65.00, '2023-10-08', 'Completed'),
       (6, 1100.00, '2023-10-09', 'Completed'),
       (7, 80.00, '2023-10-10', 'Pending'),
       (3, 1500.00, '2023-10-11', 'Processing'),
       (1, 1200.00, '2023-10-12', 'Completed'),
       (8, 45.00, '2023-10-12', 'Completed'),
       (5, 30.00, '2023-10-13', 'Cancelled'),
       (4, 1500.00, '2023-10-14', 'Pending'),
       (6, 50.00, '2023-10-15', 'Completed');

INSERT INTO order_detail (order_id, product_id, quantity)
VALUES (1, 1, 1),
       (1, 7, 1),
       (2, 2, 1),
       (3, 5, 1),
       (4, 4, 1),
       (5, 2, 2),
       (6, 6, 1),
       (7, 4, 1),
       (7, 5, 1),
       (8, 3, 1),
       (9, 8, 1),
       (10, 1, 1),
       (11, 2, 1),
       (12, 4, 3),
       (13, 7, 1),
       (14, 1, 1),
       (15, 5, 1);



--1.  Tạo View tổng hợp doanh thu theo khu vực:
create view v_revenue_by_region as
select c.region, sum(case when o.total_amount isnull then 0 else o.total_amount end) as "sum_revenue"
from customer c left join orders o on c.customer_id = o.customer_id
group by c.region;

-- Viết truy vấn xem top 3 khu vực có doanh thu cao nhất
select *
from v_revenue_by_region v
order by v.sum_revenue desc
limit 3;

-- 2. Tạo View chi tiết đơn hàng có thể cập nhật được:
--(do chưa học trigger nên không thể cập nhật dc bảng có join)
drop view v_orders_detail_no_check;
drop view v_orders_detail_have_check;

create  view v_orders_detail_no_check as
select o.*
from orders o;

-- a. Cập nhật status của đơn hàng thông qua View này
update v_orders_detail_no_check
set status='pending'
where order_id=3;

-- b. Kiểm tra hành vi khi vi phạm điều kiện WITH CHECK OPTION
create  view v_orders_detail_have_check as
select o.*
from orders o
where status='Completed'
with check option ;
-- Sẽ bị lỗi vì sai điều kiện where của view
update v_orders_detail_have_check
set status='pending'
where order_id=5;


--3.  Tạo View phức hợp (Nested View):
-- Từ v_revenue_by_region, tạo View mới v_revenue_above_avg
-- hiển thị khu vực có doanh thu > trung bình toàn quốc
 create view v_revenue_above_avg as
select *
from v_revenue_by_region
where sum_revenue > (select avg(sum_revenue)
                     from v_revenue_by_region);



