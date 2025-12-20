create database session12;
create schema if not exists lt4;

set search_path to lt4;

drop table products, orders;

CREATE TABLE products
(
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      NUMERIC(12, 2)
);

INSERT INTO products (name, price)
VALUES ('Laptop Dell', 15000000),
       ('Chuột Logitech', 250000),
       ('Bàn phím cơ', 800000),
       ('Màn hình LG', 4500000);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    product_id   INT REFERENCES products (product_id),
    quantity     INT,
    total_amount NUMERIC(12, 2)
);

create or replace function calculate_amount()
    returns trigger
as
$$
declare
    v_price numeric(12, 2);
begin
    select price into v_price from products where product_id = new.product_id;

    if (not found) then
        raise exception 'Sản phẩm id: % không tồn tại',new.product_id;
    end if;

    new.total_amount = v_price * new.quantity;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_cal_amount
    before insert
    on orders
    for each row
execute function calculate_amount();

insert into orders(product_id, quantity)
values (1, 20);

insert into orders(product_id, quantity)
values (5, 10);