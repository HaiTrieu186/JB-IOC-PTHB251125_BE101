create schema if not exists bt2;
set search_path to bt2;

-- 1. Tạo bảng
CREATE TABLE customers
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(255)   NOT NULL,
    credit_limit DECIMAL(15, 2) NOT NULL
);

CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (id),
    order_amount DECIMAL(10, 2) NOT NULL
);

-- 2. Chèn dữ liệu mẫu cho khách hàng
INSERT INTO customers (name, credit_limit)
VALUES ('Nguyễn Văn A', 1000.00),
       ('Trần Thị B', 500.00);


create or replace function check_credit_limit()
returns trigger
as $$
    declare
        v_credit_limit decimal(10,2);
        v_current_amount decimal(10,2);
    begin
        select credit_limit into v_credit_limit from customers where id = new.customer_id;
        select sum(case when order_amount isnull then 0 else order_amount end)
            into v_current_amount
            from orders
            where customer_id= new.customer_id;

        if ((new.order_amount+v_current_amount) > v_credit_limit) then
            raise exception 'Vượt hạn mức tín dụng cho phép !';
        end if;
        return new;
end;
$$ language plpgsql;

create or replace trigger trg_check_credit
before insert on orders
for each row
execute function check_credit_limit();


-- Test
INSERT INTO orders (customer_id, order_amount) VALUES (1, 400.00);
INSERT INTO orders (customer_id, order_amount) VALUES (1, 300.00);
INSERT INTO orders (customer_id, order_amount) VALUES (1, 400.00); -- lỗi
INSERT INTO orders (customer_id, order_amount) VALUES (2, 1000.00); -- lỗi



