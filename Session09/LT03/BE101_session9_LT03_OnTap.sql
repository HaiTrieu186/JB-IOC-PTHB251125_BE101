create database session09;
create schema if not exists lt3;

set search_path to lt3;

create table if not exists Products
(
    product_id     serial primary key,
    category_id    int,
    price          numeric(10, 2),
    stock_quantity int
);

INSERT INTO Products (category_id, price, stock_quantity)
SELECT (random() * 50 + 1)::int,
       (random() * 1000 + 10)::numeric(10, 2),
       (random() * 100)::int
FROM generate_series(1, 10000);

INSERT INTO Products (category_id, price, stock_quantity)
VALUES (1, 50.00, 100),
       (1, 150.00, 50),
       (1, 999.99, 10),
       (100, 5000.00, 1);


-- 1/ Tạo Clustered Index trên cột category_id
create index idx_products_category on products (category_id);
cluster products using idx_products_category;

drop index idx_products_category;
-- 2/ Tạo Non-clustered Index trên cột price
create index idx_products_price on products (price);

drop index idx_products_price
-- 3/ Thực hiện truy vấn SELECT * FROM Products WHERE category_id = X ORDER BY price; và giải thích cách Index hỗ trợ tối ưu
create index idx_products_category_by_price on products (category_id, price asc);
-- em dùng index kết hợp vì đề bài không chỉ lọc theo category_id mà còn sắp xếp theo giá


SET enable_seqscan = OFF;
RESET enable_seqscan;

