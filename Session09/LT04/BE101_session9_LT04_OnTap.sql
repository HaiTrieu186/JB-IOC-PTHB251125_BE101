create database session09;
create schema if not exists lt4;

set search_path to lt4;

create table if not exists Sales
(
    sale_id     serial primary key,
    customer_id int,
    product_id  int,
    sale_date   DATE,
    amount      int
);

INSERT INTO Sales (customer_id, product_id, sale_date, amount)
VALUES (1, 101, '2023-01-01', 500),
       (1, 102, '2023-01-15', 600),
       (2, 103, '2023-02-01', 100),
       (2, 104, '2023-02-05', 200),
       (3, 105, '2023-03-10', 1200),
       (1, 106, '2023-03-12', 300),
       (4, 101, '2023-04-01', 450),
       (4, 102, '2023-04-02', 450),
       (5, 107, '2023-05-05', 2000),
       (2, 101, '2023-05-06', 150),
       (6, 108, '2023-06-01', 900),
       (3, 109, '2023-06-10', 50),
       (5, 110, '2023-07-01', 100),
       (7, 111, '2023-07-15', 800),
       (1, 103, '2023-08-01', 200);


-- 1/Tạo View CustomerSales tổng hợp tổng amount theo từng customer_id
create or replace view view_CustomerSales as
select customer_id, sum(amount) as "total_amount"
from Sales
group by customer_id;

drop view view_CustomerSales;
-- 2/Viết truy vấn SELECT * FROM CustomerSales WHERE total_amount > 1000; để xem khách hàng mua nhiều
select *
from view_CustomerSales
where total_amount > 1000;

-- 3/Thử cập nhật một bản ghi qua View và quan sát kết quả
-- DO CHƯA HỌC TRIGGER NÊN THẦY HÙNG BẢO KO CẦN LÀM DẠNG NÀY Ạ
-- VỚI LẠI CÓ GROUP BY NÊN KHÔNG THỂ UPDATE BÌNH THƯỜNG Ạ