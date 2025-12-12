create schema if not exists bt4;

set search_path to bt4;

DROP TABLE IF EXISTS products;

CREATE TABLE products
(
    id               serial primary key,
    name             varchar(100),
    price            numeric,
    discount_percent int
);

INSERT INTO products (name, price, discount_percent)
VALUES ('Mechanical Keyboard', 100.00, 10),
       ('Gaming Mouse', 50.00, 60),
       ('Monitor 4K', 400.00, 50),
       ('USB Cable', 20.00, 0),
       ('Clearance Laptop', 1000.00, 80),
       ('Headset', 80.00, 25),
       ('Webcam', 45.00, 55);

-- 1/ Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
-- a) Lấy price và discount_percent của sản phẩm
-- b) Tính giá sau giảm: p_final_price = price - (price * discount_percent / 100)
-- c) Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
-- 2/ Cập nhật lại cột price trong bảng products thành giá sau giảm
create or replace procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC)
    language plpgsql
AS
$$
declare
    v_current_price    numeric;
    v_discount_percent int;
begin
    select price, discount_percent
    into v_current_price,v_discount_percent
    from products
    where id = p_id;

    if not FOUND then
        raise exception 'Không tồn tại sản phẩm với id:%',p_id;
    end if;

    if v_discount_percent > 50 then
        v_discount_percent := 50;
    end if;

    p_final_price = v_current_price - (v_current_price * v_discount_percent / 100);

    update products
    set price=p_final_price
    where id = p_id;

    raise notice 'Giá sau giảm của sản phẩm id:% là: %',p_id,p_final_price;
end;
$$;

-- 3/ Gọi thử:
-- CÁCH 1
call calculate_discount(2, null);


-- CÁCH 2
DO
$$
    DECLARE
        p_final_price NUMERIC;
    BEGIN
        CALL calculate_discount(2, p_final_price);
        RAISE NOTICE 'Giá sau giảm của sản phẩm là: %',p_final_price;
    END
$$;










