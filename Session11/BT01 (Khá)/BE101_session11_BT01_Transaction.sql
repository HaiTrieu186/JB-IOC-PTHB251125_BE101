create schema if not exists bt6;
set search_path to bt6;

CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    stock INT          NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    product_id   INT REFERENCES products (id),
    quantity     INT NOT NULL CHECK (quantity > 0),
    order_status VARCHAR(50) DEFAULT 'Pending'
);

INSERT INTO products (name, stock)
VALUES ('Samsung Galaxy S23', 20),
       ('Sony WH-1000XM5', 15),
       ('Kindle Paperwhite', 5);


-- tạo trigger function ---
create or replace function check_orders()
    returns trigger
as
$$
declare
    current_stock int;
begin
    if (tg_op = 'INSERT') then
        select stock into current_stock from products where id = new.product_id;

        current_stock := current_stock - new.quantity;

        if (current_stock < 0) then
            raise exception 'Số lượng tồn kho không đủ, không thể tạo mới !';
        end if;

        update products
        set stock = current_stock
        where id = new.product_id;

        return new;

    elsif (tg_op = 'UPDATE') then
        select stock into current_stock from products where id = new.product_id;

        current_stock := current_stock + old.quantity - new.quantity;

        if (current_stock < 0) then
            raise exception 'Số lượng tồn kho không đủ, không thể cập nhật !';
        end if;

        update products
        set stock = current_stock
        where id = new.product_id;

        return new;

    elsif (tg_op = 'DELETE') then
        select stock into current_stock from products where id = old.product_id;
        current_stock := current_stock + old.quantity;

        update products
        set stock = current_stock
        where id = old.product_id;

        return old;

    end if;
end;
$$ language plpgsql;

create or replace trigger trg_orders
    before insert or update or delete
    on orders
    for each row
execute function check_orders();


---- TEST ---
--Insert đơn mới: stock của produc_id: 1 --> 17
insert into orders(product_id, quantity)
values (1, 3);

-- Update đơn: stock của produc_id: 1  ---> 5
update orders
set quantity = 5
where id = 1;

-- Xóa đơn: stock của product_id: 1 --> 20
delete
from orders
where id = 1;


-- Insert đơn mới quá stock
insert into orders(product_id, quantity)
values (2, 30);

-- Update đơn cũ quá stock
update orders
set quantity= 50
where id = 2;
