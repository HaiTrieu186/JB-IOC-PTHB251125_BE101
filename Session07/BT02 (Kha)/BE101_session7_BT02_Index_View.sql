create schema if not exists bt2;
set search_path to bt2;

drop table if exists  customer;
drop table if exists  orders;

create table if not exists customer
(
    customer_id serial primary key,
    full_name   varchar(100),
    email       varchar(100),
    phone       varchar(15)
);

create table if not exists orders
(
    order_id     serial primary key,
    customer_id  int references customer (customer_id),
    total_amount decimal(10, 2),
    order_date   Date
)


INSERT INTO customer (full_name, email, phone)
VALUES ('Nguyen Van An', 'an.nguyen@example.com', '0901234567'),
       ('Tran Thi Binh', 'binh.tran@example.com', '0912345678'),
       ('Le Van Cuong', 'cuong.le@example.com', '0987654321'),
       ('Pham Thi Dung', 'dung.pham@example.com', '0998877665'),
       ('Hoang Van Em', 'em.hoang@example.com', '0909090909');

INSERT INTO orders (customer_id, total_amount, order_date)
VALUES (1, 1500000.00, '2023-10-05'),
       (2, 2500000.00, '2023-10-10'),
       (1, 500000.00, '2023-10-15'),
       (3, 1200000.00, '2023-11-02'),
       (2, 800000.00, '2023-11-05'),
       (4, 3000000.00, '2023-11-20'),
       (5, 450000.00, '2023-12-01'),
       (1, 2000000.00, '2023-12-10'),
       (3, 600000.00, '2023-12-15'),
       (2, 1000000.00, '2023-12-25');


-- 1/ Tạo một View tên v_order_summary hiển thị:
-- full_name, total_amount, order_date
-- (ẩn thông tin email và phone)
create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c join orders o on c.customer_id = o.customer_id;

-- 2/ Viết truy vấn để xem tất cả dữ liệu từ View
select  *
from  v_order_summary;

-- 3/Cập nhật tổng tiền đơn hàng thông qua View (gợi ý: dùng WITH CHECK OPTION nếu cần)
-- Phần này chưa học triggers nên thầy Hùng kêu bỏ qua ạ.


-- 4/Tạo một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
create  view v_monthly_sales as
select extract(month from order_date) as "month",
       sum(total_amount) as "venue_by_month"
from orders
group by extract(month from order_date);

-- 5/ Thử DROP View và ghi chú sự khác biệt giữa DROP VIEW
-- và DROP MATERIALIZED VIEW trong PostgreSQL

-- View cơ bản: chỉ lưu trữ câu truy vấn, không tạo bảng vật lý
-- Materialized view: tạo bảng vật lý như bảng bình thường
create materialized view vm_test_sales as
select extract(month from order_date) as "month",
       sum(total_amount) as "venue_by_month"
from orders
group by extract(month from order_date);


-- Sẽ báo lỗi vì đây là xóa view thường
drop view vm_test_sales;

-- Sẽ ok vì đây là materialized view
drop view v_monthly_sales;