create schema if not exists bt5;
set search_path to bt5;

-- 1. Tạo bảng chính
CREATE TABLE customers
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    email   VARCHAR(255),
    phone   VARCHAR(20),
    address TEXT
);

-- 2. Tạo bảng Log
CREATE TABLE customers_log
(
    log_id      SERIAL PRIMARY KEY,
    customer_id INT,
    operation   VARCHAR(10),
    old_data    JSONB,
    new_data    JSONB,
    changed_by  VARCHAR(100),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Chèn dữ liệu mẫu
INSERT INTO customers (name, email, phone, address)
VALUES ('Nguyễn Văn A', 'vana@gmail.com', '0901234567', '123 Lê Lợi, TP.HCM'),
       ('Trần Thị B', 'thib@gmail.com', '0912345678', '456 Nguyễn Huệ, Hà Nội'),
       ('Lê Văn C', 'vanc@gmail.com', '0987654321', '789 Trần Hưng Đạo, Đà Nẵng');


-- 4. Tạo function trigger
create or replace function update_log()
returns trigger
as $$
   begin
        if (tg_op='INSERT') then
            insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
            values (new.id, tg_op,null,to_jsonb(new), current_user);
            return new;
        end if;

        if (tg_op='UPDATE') then
            insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
            values (new.id, tg_op,to_jsonb(old),to_jsonb(new), current_user);
            return new;
        end if;

        if (tg_op='DELETE') then
            insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
            values (old.id, tg_op,to_jsonb(old),null, current_user);
            return old;
        end if;
   end;
$$ language plpgsql;


-- 5. Tạo trigger
create or replace trigger trg_check_customer
after insert or update or delete on customers
for each row
execute function update_log();


--- TEST ---
-- Chèn 2 lần, sẽ có 2 log insert
INSERT INTO customers (name, email, phone, address)
VALUES ('Đoàn Văn S', 'vanS@gmail.com', '0905000298', '12 NXD, Lạng Sơn');

-- Cập nhật bản ghi Đoàn văn S thứ 2
UPDATE customers
set name = 'Doan Van S2'
where id= 4;

-- Xóa Bản ghi thứ 7 (bản ghi vừa cập nhật)
delete from customers where id=4;