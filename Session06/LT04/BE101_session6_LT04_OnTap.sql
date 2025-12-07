CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt4;

set search_path to lt4;

CREATE table if not exists OrderInfo
(
    id     serial primary key,
    customer_id int,
    order_date date,
    total numeric(10,2),
    status varchar(20)
);

-- 1. Thêm 5 đơn hàng mẫu với tổng tiền khác nhau
  insert into OrderInfo(customer_id, order_date, total, status)
  values (1,'2025-10-29',150000,'Pending'),
         (2,'2025-11-03',750500,'Pending'),
         (1,'2025-10-02',1250000,'Completed'),
         (3,'2025-11-11',825000,'notFinish'),
         (4,'2025-10-22',50000,'Completed');

-- 2. Truy vấn các đơn hàng có tổng tiền lớn hơn 500,000
select *
from OrderInfo
where total>500000.00;

-- 3. Truy vấn các đơn hàng có ngày đặt trong tháng 10 năm 2025
select *
from OrderInfo
where order_date between '2025-10-01' and '2025-10-31';

-- 4. Liệt kê các đơn hàng có trạng thái khác “Completed”
select *
from OrderInfo
where status='Completed';

-- 5. Lấy 2 đơn hàng mới nhất
select *
from OrderInfo
order by order_date desc
limit 2;