create database session09;
create schema if not exists lt7;
set search_path to lt7;

create table if not exists Customers
(
    customer_id serial primary key,
    name        varchar(100),
    email       varchar(100)
);

create table if not exists Orders
(
    order_id    serial primary key,
    customer_id int references Customers (customer_id),
    amount      numeric(10, 2),
    order_date  DATE
);

INSERT INTO Customers (name, email)
VALUES ('Nguyen Van A', 'nguyena@example.com'),
       ('Tran Thi B', 'tranb@example.com'),
       ('Le Van C', 'lec@example.com'),
       ('Pham Thanh Huy', 'Huypham@example.com');


-- 1/ Tạo Procedure add_order(p_customer_id INT, p_amount NUMERIC) để thêm đơn hàng
-- 2/ Kiểm tra nếu customer_id không tồn tại trong bảng Customers, sử dụng RAISE EXCEPTION để báo lỗi
-- 3/ Nếu khách hàng tồn tại, thêm bản ghi mới vào bảng Orders


create or replace procedure add_order(
    p_customer_id INT,
    p_amount NUMERIC
)
    language plpgsql
AS
$$
begin
    if not exists(select 1 from Customers where customer_id = p_customer_id) then
        RAISE EXCEPTION 'Khách hàng ID % không tồn tại', p_customer_id;
    end if;
    insert into orders(customer_id, amount, order_date)
    VALUES (p_customer_id, p_amount, current_date);

end;
$$;

call add_order(2, 50000); -- tồn tại
call add_order(12, 25700); -- không tồn tại
select *
from orders;
