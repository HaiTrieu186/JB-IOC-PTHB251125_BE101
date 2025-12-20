create database session12;
create schema if not exists lt7;

set search_path to lt7;

drop table products, orders, order_log;

CREATE TABLE products
(
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(50)    NOT NULL,
    price      NUMERIC(10, 2) NOT NULL,
    stock      INT            NOT NULL
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    product_id   INT REFERENCES products (product_id),
    quantity     INT NOT NULL,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE order_log
(
    log_id      SERIAL PRIMARY KEY,
    order_id    INT,
    action_time TIMESTAMP DEFAULT NOW()
);

INSERT INTO products (name, price, stock)
VALUES ('Laptop Dell', 15000000.00, 10),
       ('iPhone 15', 25000000.00, 2),
       ('Tai nghe Sony', 2000000.00, 5);


create or replace procedure check_order(
    in_product_id int,
    in_quantity int
)
    language plpgsql
as
$$
declare
    v_stock        int;
    v_price        numeric(10, 2);
    v_new_order_id int;
begin
    select stock, price
    into v_stock, v_price
    from products
    where product_id = in_product_id;

    IF NOT FOUND THEN
        ROLLBACK;
        RAISE EXCEPTION 'San pham khong ton tai!';
    END IF;

    IF in_quantity <= 0 THEN
        ROLLBACK;
        RAISE EXCEPTION 'So luong phai lon hon 0!';
    END IF;

    if v_stock < in_quantity then
        rollback;
        raise exception 'Khong du so luong ton kho!';
    end if;

    update products
    set stock = stock - in_quantity
    where product_id = in_product_id;

    insert into orders(product_id, quantity, total_amount)
    values (in_product_id, in_quantity, v_price * in_quantity)
    returning order_id into v_new_order_id;

    insert into order_log(order_id)
    values (v_new_order_id);

    commit;
end;
$$;

call check_order(1, 2);
call check_order(1, 12);

