create database session09;
create schema if not exists lt5;

set search_path to lt5;

create table if not exists Sales
(
    sale_id     serial primary key,
    customer_id int,
    amount      int,
    sale_date   DATE
);

INSERT INTO Sales (customer_id, amount, sale_date)
VALUES (101, 500, '2024-01-05'),
       (102, 1200, '2024-01-15'),
       (101, 300, '2024-01-20'),
       (103, 800, '2024-02-01'),
       (104, 1500, '2024-02-10'),
       (102, 450, '2024-02-14'),
       (105, 2000, '2024-03-01');



-- Tạo Procedure calculate_total_sales(start_date DATE, end_date DATE, OUT total NUMERIC) để tính tổng amount trong khoảng start_date đến end_date
-- Gọi Procedure với các ngày mẫu và hiển thị kết quả
create or replace procedure calculate_total_sales(
    start_date DATE,
    end_date DATE,
    OUT total NUMERIC
)
    language plpgsql
AS
$$
begin
    select sum(amount)
    into total
    from Sales
    where sale_date between start_date and end_date;
end;
$$;

CALL calculate_total_sales('2024-01-01', '2024-01-31', null);
