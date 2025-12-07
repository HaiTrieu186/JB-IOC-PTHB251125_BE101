CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt6;

set search_path to lt6;

CREATE table if not exists Ordes
(
    id           serial primary key,
    customer_id  int,
    order_date   date,
    total_amount numeric(10, 2)
);


INSERT INTO Ordes (customer_id, order_date, total_amount)
VALUES (1, '2023-01-15', 35000000),
       (2, '2023-06-20', 25000000),
       (3, '2023-12-10', 2000000),
       (1, '2024-02-14', 15000000),
       (4, '2024-05-05', 10000000),
       (2, '2024-09-09', 5000000),
       (5, '2025-01-01', 60000000),
       (3, '2025-02-15', 40000000),
       (1, '2025-03-08', 5500000),
       (4, '2025-03-10', 12000000);


-- 1.Hiển thị tổng doanh thu, số đơn hàng, giá trị trung bình mỗi đơn (dùng SUM, COUNT, AVG)
-- Đặt bí danh cột lần lượt là total_revenue, total_orders, average_order_value
SELECT SUM(total_amount) AS total_revenue,
       COUNT(id)         AS total_orders,
       AVG(total_amount) AS average_order_value
FROM Ordes;


-- 2.Nhóm dữ liệu theo năm đặt hàng,
-- hiển thị doanh thu từng năm (GROUP BY EXTRACT(YEAR FROM order_date))
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       SUM(total_amount)             AS yearly_revenue
FROM Ordes
GROUP BY EXTRACT(YEAR FROM order_date);


-- 3.Chỉ hiển thị các năm có doanh thu trên 50 triệu (HAVING)
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       SUM(total_amount)             AS yearly_revenue
FROM Ordes
GROUP BY EXTRACT(YEAR FROM order_date)
HAVING SUM(total_amount) > 50000000;


-- 4.Hiển thị 5 đơn hàng có giá trị cao nhất (dùng ORDER BY + LIMIT)
SELECT *
FROM Ordes
ORDER BY total_amount DESC
LIMIT 5;