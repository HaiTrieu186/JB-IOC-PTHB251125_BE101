create database session12;
create schema if not exists lt5;

set search_path to lt5;

drop table employees, employee_log;

CREATE TABLE employees
(
    emp_id   SERIAL PRIMARY KEY,
    name     VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE employee_log
(
    log_id      SERIAL PRIMARY KEY,
    emp_name    VARCHAR(50),
    action_time TIMESTAMP DEFAULT NOW()
);

-- Thêm dữ liệu mẫu
INSERT INTO employees (name, position)
VALUES ('Nguyen Van A', 'Developer'),
       ('Tran Thi B', 'Tester'),
       ('Le Van C', 'Manager');

create or replace function update_log()
    returns trigger
as
$$
begin
    insert into employee_log(emp_name)
    VALUES (new.name);
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_log
    after update
    on employees
    for each row
execute function update_log();

update employees
set position = 'HR'
where emp_id = 1;