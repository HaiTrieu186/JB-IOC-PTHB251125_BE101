create schema if not exists bt4;
set search_path to bt4;

-- Tạo bảng sản phẩm
CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    stock INT          NOT NULL DEFAULT 0
);

-- Tạo bảng đơn hàng
CREATE TABLE orders
(
    id         SERIAL PRIMARY KEY,
    product_id INT REFERENCES products (id),
    quantity   INT NOT NULL CHECK (quantity > 0)
);

INSERT INTO products (name, stock)
VALUES ('iPhone 15', 50),
       ('MacBook Air M2', 30),
       ('AirPods Pro', 100);

SELECT *
FROM products;

create or replace function change_stock()
    returns trigger
as
$$
begin
    if (tg_op = 'INSERT') then
        update products
        set stock = stock - new.quantity
        where id = new.id;
        return new;

    elsif (tg_op = 'UPDATE') then
        update products
        set stock = stock + old.quantity - new.quantity
        where id = new.product_id;
        return new;

    elsif (tg_op = 'DELETE') then
        update products
        set stock = stock + old.quantity
        where id = old.product_id;
        return old;
    end if;

    return null;
end;
$$ language plpgsql;

create or replace trigger check_stock
    after insert or delete or update
    on orders
    for each row
execute function change_stock();


-- TEST
INSERT INTO orders (product_id, quantity)
VALUES (1, 3);
INSERT INTO orders (product_id, quantity)
VALUES (2, 10);
UPDATE orders
SET quantity = 8
WHERE id = 2;
DELETE
FROM orders
WHERE product_id = 1;