CREATE schema if not exists bt3;
set search_path to bt3;



CREATE TABLE customers
(
    customer_id   serial PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);


CREATE TABLE orders
(
    order_id    SERIAL PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    total_price NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE order_items
(
    item_id    SERIAL PRIMARY KEY,
    order_id   INT,
    product_id INT,
    quantity   INT,
    price      NUMERIC(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);


INSERT INTO customers (customer_name, city)
VALUES ('Nguyễn Văn A', 'Hà Nội'),
       ('Trần Thị B', 'Đà Nẵng'),
       ('Lê Văn C', 'Hồ Chí Minh'),
       ('Phạm Thị D', 'Hà Nội');


INSERT INTO orders (customer_id, order_date, total_price)
VALUES (1, '2024-12-20', 3000),
       (2, '2025-01-05', 1500),
       (1, '2025-02-10', 2500),
       (3, '2025-02-15', 4000),
       (4, '2025-03-01', 800);

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 1500),
       (2, 2, 1, 1500),
       (3, 3, 5, 500),
       (4, 2, 4, 1000);

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (5, 1, 2, 400);



-- 1.Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
-- Chỉ hiển thị khách hàng có tổng doanh thu > 2000
select c.customer_id,
       c.customer_name,
       sum(case when o.total_price isnull then 0 else o.total_price end),
       count(o.order_id)
from customers c
         left join orders o on c.customer_id = o.customer_id
         left join order_items oi on o.order_id = oi.order_id
group by c.customer_id
having sum(case when o.total_price isnull then 0 else o.total_price end) > 2000;

-- Dùng ALIAS: total_revenue và order_count
select c.customer_id,
       c.customer_name,
       sum(case when o.total_price isnull then 0 else o.total_price end) as "total_revenue",
       count(o.order_id)                                                 as "order_count"
from customers c
         left join orders o on c.customer_id = o.customer_id
         left join order_items oi on o.order_id = oi.order_id
group by c.customer_id
having sum(case when o.total_price isnull then 0 else o.total_price end) > 2000;


-- 2. Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
-- Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
select sum(o.total_price)
from orders o
group by o.customer_id
having sum(o.total_price) >
       (select avg(venue_by_customer.total_venue)
        from (select sum(o.total_price) as "total_venue"
              from orders o
              group by o.customer_id) as venue_by_customer);


select c.customer_id, c.customer_name, sum(o.total_price) as "total_venue"
from orders o
         join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) >
       (select avg(abc.total_venue)
        from (select sum(o.total_price) as "total_venue"
              from orders o
              group by o.customer_id) as abc)


-- 3. Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
select c.city, sum(o.total_price)
from customers c
         join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_price) = (select sum(o.total_price)
                             from customers c
                                      join orders o on c.customer_id = o.customer_id
                             group by c.city
                             order by sum(o.total_price) desc
                             limit 1);



-- 4. (Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
-- Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
select c.customer_id, c.customer_name,
       sum(case when oi.quantity isnull then 0 else oi.quantity end) as "Tổng sản phẩm đã mua",
       sum(case when o.total_price isnull  then 0 else o.total_price end) as "Tổng chi tiêu"
from customers c
         left join orders o on c.customer_id = o.customer_id
         left join order_items oi on o.order_id = oi.order_id
group by c.customer_id
order by c.customer_id;





