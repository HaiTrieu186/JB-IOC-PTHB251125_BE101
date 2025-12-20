create database session11;

create schema if not exists bt3;
set search_path to bt3;


CREATE TABLE products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    stock        INT CHECK (stock >= 0),
    price        NUMERIC(10, 2)
);

CREATE TABLE orders
(
    order_id      SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    total_amount  NUMERIC(10, 2) DEFAULT 0,
    created_at    TIMESTAMP      DEFAULT NOW()
);

CREATE TABLE order_items
(
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders (order_id),
    product_id    INT REFERENCES products (product_id),
    quantity      INT,
    subtotal      NUMERIC(10, 2)
);

--  Chèn dữ liệu mẫu
INSERT INTO products (product_name, stock, price)
VALUES ('Laptop Dell', 10, 1500.00),
       ('Chuột Logitech', 5, 25.00),
       ('Bàn phím Cơ', 2, 80.00);



--Viết Transaction thực hiện toàn bộ quy trình đặt hàng cho khách "Nguyen Van A" gồm:
-- Mua 2 sản phẩm:
-- product_id = 1, quantity = 2
-- product_id = 2, quantity = 1
-- Nếu một trong hai sản phẩm không đủ hàng, toàn bộ giao dịch phải bị ROLLBACK
--     Nếu thành công, COMMIT và cập nhật chính xác số lượng tồn kho


-- Do trong transaction không thể dùng lệnh if --> em thêm check vào cột stock
-- ==> tự trả về lỗi nếu tồn kho không đủ
begin;
--Kiểm tra và giảm số lượng tồn kho
update products
set stock=stock - 2
where product_id = 1;

update products
set stock=stock - 1
where product_id = 2;

-- Thêm vào order , total= 1500*2 +25*1 - 3025.00
insert into orders(customer_name)
values ('Nguyen Van A');

-- Thêm chi tiết sản phẩm
insert into order_items(order_id, product_id, quantity, subtotal)
values (1, 1, 2, 3000.00); -- 1500*2

insert into order_items(order_id, product_id, quantity, subtotal)
values (1, 2, 1, 25.00); -- 1500*2

update orders
set total_amount = (select sum(subtotal)
                    from order_items oi
                    where oi.order_id = 1
                    group by oi.order_id)
where order_id = 1;

commit;
end;


-- Hiện tại đang là 8 ---> 0
update products
set stock=0
where product_id = 1;

-- LỖi khi chạy transaction
--- [23514] ERROR: new row for relation "products" violates check constraint "products_stock_check"
--Detail: Failing row contains (1, Laptop Dell, -2, 1500.00).