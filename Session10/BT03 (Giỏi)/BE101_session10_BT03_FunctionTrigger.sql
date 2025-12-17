create schema if not exists bt3;
set search_path to bt3;

-- 1. Tạo bảng employees và employees_log
CREATE TABLE employees
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    salary   DECIMAL(15, 2)
);

CREATE TABLE employees_log
(
    log_id      SERIAL PRIMARY KEY,
    employee_id INT,
    operation   VARCHAR(10),
    old_data    JSONB,
    new_data    JSONB,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. Viết function
create or replace function check_updated()
    returns trigger
as
$$
begin
    if (tg_op = 'INSERT') then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (new.id, 'Insert', null, to_jsonb(new));
        return new;
    end if;

    if (tg_op = 'UPDATE') then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (new.id, 'Update', to_jsonb(old), to_jsonb(new));
        return new;
    end if;

    if (tg_op = 'DELETE') then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (old.id, 'Delete', to_jsonb(old), null);
        return old;
    end if;
end;
$$ language plpgsql;

-- 3. tạo Trigger
create or replace trigger check_updated
    after insert or update or delete
    on employees
    for each row
execute function check_updated();

-- 4. Thực hành: Chèn, Cập nhật và Xóa
INSERT INTO employees (name, position, salary)
VALUES ('Nguyen Van A', 'Developer', 1500.00);
INSERT INTO employees (name, position, salary)
VALUES ('Tran Thi B', 'Designer', 1200.00);

UPDATE employees
SET salary = 1700.00
WHERE name = 'Nguyen Van A';

DELETE
FROM employees
WHERE name = 'Tran Thi B';

