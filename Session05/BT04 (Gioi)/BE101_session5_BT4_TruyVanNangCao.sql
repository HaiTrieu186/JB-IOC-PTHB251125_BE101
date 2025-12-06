CREATE schema if not exists bt4;
set search_path to bt4;


CREATE TABLE customers
(
    customer_id   serial PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);


CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    total_amount NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE order_items
(
    item_id      SERIAL PRIMARY KEY,
    order_id     INT,
    product_name varchar(100),
    quantity     INT,
    price        NUMERIC(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

INSERT INTO customers (customer_name, city)
VALUES ('Nguyễn Văn An', 'Hà Nội'),
       ('Trần Thị Bình', 'Đà Nẵng'),
       ('Lê Văn Cường', 'Hồ Chí Minh'),
       ('Phạm Thị Dung', NULL),
       ('Hoàng Văn Em', 'Hà Nội'),
       ('Nguyễn Văn An', 'Hải Phòng'),
       ('Bảo Bảo', 'Long Xuyên');



INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2024-01-15', 25500000),
       (2, '2023-12-20', 5000000),
       (2, '2024-02-10', 500000),
       (2, '2024-02-25', 1500000),
       (3, '2024-03-08', 350000),
       (4, '2024-03-15', 1200000),
       (6, '2024-04-01', 100000);


INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES (1, 'Laptop Dell XPS', 1, 25500000),
       (1, 'Balo Laptop', 1, 0),
       (2, 'Ghế Công Thái Học', 1, 5000000),
       (3, 'Chuột Logitech', 2, 250000),
       (4, 'Bàn phím cơ Keychron', 1, 1500000),
       (5, 'Tai nghe Sony', 1, 350000),
       (6, 'Màn hình LG 24 inch', 1, 1200000),
       (7, 'Lót chuột size lớn', 2, 50000);



-- 1.ALIAS:
-- Hiển thị danh sách tất cả các đơn hàng với các cột:
-- Tên khách (customer_name)
-- Ngày đặt hàng (order_date)
-- Tổng tiền (total_amount)

select c.customer_name,
       o.order_date,
       o.total_amount
from orders o
         join customers c on o.customer_id = c.customer_id;



-- 2. Aggregate Functions:
-- Tính các thông tin tổng hợp:
-- Tổng doanh thu (SUM(total_amount))
-- Trung bình giá trị đơn hàng (AVG(total_amount))
-- Đơn hàng lớn nhất (MAX(total_amount))
-- Đơn hàng nhỏ nhất (MIN(total_amount))
-- Số lượng đơn hàng (COUNT(order_id))

select sum(o.total_amount) as "Tổng doanh thu",
       avg(o.total_amount) as "Trung bình giá trị đơn hàng",
       max(o.total_amount) as "Đơn hàng lớn nhất",
       min(o.total_amount) as "Đơn hàng nhỏ nhất",
       count(o.order_id)   as "Số lượng đơn hàng"
from orders o;


-- 3. GROUP BY / HAVING:
-- Tính tổng doanh thu theo từng thành phố
-- chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
select c.city, sum(total_amount)
from customers c
         join orders o on c.customer_id = o.customer_id
where c.city is not null
group by c.city
having sum(total_amount) > 10000;

-- 4. JOIN:
-- Liệt kê tất cả các sản phẩm đã bán, kèm:
-- Tên khách hàng
-- Ngày đặt hàng
-- Số lượng và giá
-- (JOIN 3 bảng customers, orders, order_items)
select oi.product_name, c.customer_name, o.order_date, oi.quantity, oi.price
from customers c
         join orders o on c.customer_id = o.customer_id
         join order_items oi on o.order_id = oi.order_id
order by oi.product_name;


-- 5. Subquery:
-- Tìm tên khách hàng có tổng doanh thu cao nhất.
-- Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX

select c.customer_name, sum(o.total_amount)
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.customer_id
having sum(o.total_amount) = (select sum(o.total_amount)
                              from customers c
                                       join orders o on c.customer_id = o.customer_id
                              group by c.customer_id
                              order by sum(o.total_amount) desc
                              limit 1);

-- 6. UNION và INTERSECT:
-- Dùng UNION để hiển thị danh sách tất cả thành phố có khách hàng hoặc có đơn hàng
select distinct c.city
from customers c
where c.city is not null

union

select distinct c.city
from customers c
         join orders o on c.customer_id = o.customer_id
where c.city is not null;

-- Dùng INTERSECT để hiển thị các thành phố vừa có khách hàng vừa có đơn hàng
select distinct c.city
from customers c
where c.city is not null

intersect

select distinct c.city
from customers c
         join orders o on c.customer_id = o.customer_id
where c.city is not null;
