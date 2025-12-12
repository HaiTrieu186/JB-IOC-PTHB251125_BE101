create database session09;
create schema if not exists lt8;

set search_path to lt8;

create table if not exists Customers
(
    customer_id serial primary key,
    name        varchar(100),
    total_spent numeric(10, 2) default 0
);

create table if not exists Orders
(
    order_id     serial primary key,
    customer_id  int references Customers (customer_id),
    total_amount numeric(10, 2)
);

INSERT INTO Customers (name, total_spent)
VALUES ('Nguyen Van A', 300.00),
       ('Tran Thi B', 0.00),
       ('Le Van C', 0.00);

INSERT INTO Orders (customer_id, total_amount)
VALUES (1, 100.00),
       (1, 200.00);


--1/ Tạo Procedure add_order_and_update_customer(p_customer_id INT, p_amount NUMERIC) để:
--   a.Thêm đơn hàng mới vào bảng Orders
--   b.Cập nhật total_spent trong bảng Customers
-- 2/ Sử dụng biến và xử lý điều kiện để đảm bảo khách hàng tồn tại
-- 3/ Sử dụng EXCEPTION để báo lỗi nếu thêm đơn hàng thất bại
-- 4/ Gọi Procedure với tham số mẫu và kiểm tra kết quả trên cả hai bảng

create or replace procedure add_order_and_update_customer(
    p_customer_id INT,
    p_amount NUMERIC
)
    language plpgsql
AS
$$
begin
    if not exists(select 1 from Customers where customer_id = p_customer_id) then
        raise exception 'Khách hàng với id % không tồn tại!',p_customer_id;
    end if;

    insert into orders(customer_id, total_amount)
    values (p_customer_id, p_amount);

    update Customers
    set total_spent= total_spent + p_amount
    where customer_id = p_customer_id;

exception
    when others then
        raise notice 'Lỗi xảy ra: %',SQLERRM;
        RAISE;

end;
$$;

call add_order_and_update_customer(2, 50000); -- tồn tại
call add_order_and_update_customer(12, 25700); -- không tồn tại
select *
from orders;
select *
from Customers
