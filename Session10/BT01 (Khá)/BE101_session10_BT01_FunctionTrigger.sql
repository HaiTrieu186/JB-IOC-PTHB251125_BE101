create schema if not exists bt1;
set search_path to bt1;

-- 1. Tạo bảng products
CREATE TABLE products
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(255)   NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, price)
VALUES ('Laptop Dell XPS', 2500.00),
       ('iPhone 15 Pro', 1200.00),
       ('Bàn phím cơ AKKO', 85.50);


-- Tạo function update_last_modified()
create or replace function update_last_modified()
returns trigger
as $$
    begin
        New.last_modified= current_timestamp;
        return new;
    end;
$$ language plpgsql;

-- Tạo trigger
create or replace trigger trg_update_last_modified
before update on products
for each row
execute function  update_last_modified();



