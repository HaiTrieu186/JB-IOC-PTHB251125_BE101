create schema if not exists bt1;

set search_path to bt1;

DROP TABLE IF EXISTS order_detail;

CREATE TABLE order_detail
(
    id           serial,
    order_id     int,
    product_name varchar(100),
    quantity     int,
    unit_price   numeric(10, 2),
    constraint pk_order_detail primary key (id)
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price)
VALUES
    (101, 'Logitech MX Master 3S', 1, 99.99),
    (101, 'Mechanical Keyboard Keychron', 1, 85.50),
    (101, 'USB-C Cable 2m', 3, 5.99),
    (102, 'Samsung Galaxy S24 Ultra', 1, 1299.00),
    (102, 'Screen Protector', 2, 12.50),
    (103, 'Milk Tea Full Topping', 5, 4.50),
    (103, 'Fried Chicken Combo', 2, 12.99),
    (103, 'Tissue Paper', 10, 1.25),
    (104, 'Dell XPS 15', 1, 1850.00),
    (105, 'Book: Clean Code', 1, 45.00),
    (105, 'Book: The Pragmatic Programmer', 1, 38.75),
    (105, 'Notebook A5', 4, 2.50),
    (105, 'Pen Set', 2, 5.20),
    (106, 'Gaming Chair Herman Miller', 1, 1450.00),
    (107, 'Mineral Water 500ml', 24, 0.40);


-- 1/ Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
-- a. Tham số order_id_input: mã đơn hàng cần tính
-- b. Tham số total: tổng giá trị đơn hàng
create or replace procedure calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC
)
    language plpgsql
AS
$$
begin
    select sum(quantity*unit_price) into total from order_detail where order_id=order_id_input;
    raise notice 'Tổng giá trị của đơn là: %',total;
end;
$$;


-- 2/ Trong Procedure:
-- a. Viết câu lệnh tính tổng tiền theo order_id
create or replace procedure calculate_total_by_orderid(
    order_id_input INT
)
    language plpgsql
AS
$$
    declare
        total numeric(10,2);
begin
    select sum(quantity*unit_price) into total from order_detail where order_id=order_id_input;
    raise notice 'Tổng giá trị của đơn là: %',total;
end;
$$;



-- 3/ Gọi Procedure để kiểm tra hoạt động với một order_id cụ thể
call calculate_total_by_orderid(101);
call calculate_order_total(101,null);


