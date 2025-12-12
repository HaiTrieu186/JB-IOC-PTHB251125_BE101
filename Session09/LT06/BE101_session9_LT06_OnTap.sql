create database session09;
create schema if not exists lt6;

set search_path to lt6;

create table if not exists Products
(
    product_id  serial primary key,
    name        varchar(100),
    price       numeric(10, 2),
    category_id int
);

INSERT INTO Products (name, price, category_id)
VALUES ('Laptop Gaming', 1000.00, 1),
       ('Chuột không dây', 20.00, 1),
       ('Bàn phím cơ', 50.00, 1),
       ('Áo thun', 10.00, 2),
       ('Quần Jeans', 30.00, 2),
       ('Sách Harry Potter', 15.00, 3);

-- 1/ Tạo Procedure update_product_price(p_category_id INT, p_increase_percent NUMERIC) để tăng giá tất cả sản phẩm trong một category_id theo phần trăm
-- 2/ Sử dụng biến để tính giá mới cho từng sản phẩm trong vòng lặp
-- 3/ Thử gọi Procedure với các tham số mẫu và kiểm tra kết quả trong bảng Products


create or replace procedure update_product_price(
    p_category_id INT,
    p_increase_percent NUMERIC
)
    language plpgsql
AS
$$
declare
    crr_id    int;
    crr_price numeric(10, 2);
begin
    for crr_id, crr_price in
        select Products.product_id, price
        from Products
        where category_id = p_category_id
        loop
            update Products
            set price=price * (1 + p_increase_percent / 100)
            where product_id = crr_id;
        end loop;
end;
$$;

CALL update_product_price(1, 10);
select *
from Products
where category_id = 1;
