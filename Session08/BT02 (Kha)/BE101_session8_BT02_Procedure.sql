create schema if not exists bt2;

set search_path to bt2;

DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory
(
    product_id   serial primary key,
    product_name varchar(100),
    quantity     int
);

INSERT INTO inventory (product_name, quantity)
VALUES ('iPhone 15 Pro Max', 50),
       ('AirPods Pro 2', 5),
       ('PlayStation 5 Pro', 0),
       ('Dell XPS 13', 20),
       ('Logitech MX Master 3', 10);


-- 1/ Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
-- a) Kiểm tra xem sản phẩm có đủ hàng không
-- b) Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’
create or replace procedure check_stock(p_id INT, p_qty INT)
    language plpgsql
AS
$$
declare
    quantiy_now int;
begin
    select quantity into quantiy_now from inventory where product_id = p_id;
    if quantiy_now is not null
    then
        if quantiy_now >= p_qty then
            raise notice 'Đủ hàng';
        else
            RAISE EXCEPTION 'Không đủ hàng trong kho';
        end if;
    else
        raise exception 'Sản phẩm không tồn tại';
    end if;
end;
$$;


-- 2/ Gọi Procedure với các trường hợp:
-- a) Một sản phẩm có đủ hàng
-- b) Một sản phẩm không đủ hàng

call check_stock(2, 5); -- đủ hàng
call check_stock(2, 15);-- thiếu hàng
call check_stock(10, 1); -- không tồn tại




