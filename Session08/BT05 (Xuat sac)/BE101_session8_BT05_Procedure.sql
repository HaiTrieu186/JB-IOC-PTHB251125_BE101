create schema if not exists bt5;

set search_path to bt5;

DROP TABLE IF EXISTS employess;

CREATE TABLE if not exists employess
(
    id         serial primary key,
    name       varchar(100),
    department varchar(50),
    salary     numeric(10, 2),
    bonus      numeric(10, 2) default 0
);

insert into employess(name, department, salary)
values ('Nguyen Van A', 'HR', 4000),
       ('Tran Thi B', 'IT', 6000),
       ('Le Van C', 'Finance', 10500),
       ('Pham Thi D', 'IT', 8000),
       ('Do Van E', 'HR', 12000);


-- Tạo procedure update_employee_status với yêu cầu sau:
--
-- Tham số vào:
-- p_emp_id INT — mã nhân viên
-- Tham số ra:
-- p_status TEXT — trạng thái sau khi cập nhật

create or replace procedure update_employee_status(p_emp_id INT, OUT p_status TEXT)
    language plpgsql
AS
$$
declare
    v_curr_salary numeric(10, 2);
begin
    select salary into v_curr_salary from employess where id = p_emp_id;
    if not FOUND then
        raise exception 'Employee not found';
    end if;

    if v_curr_salary < 5000 then
        p_status := 'Junior';
    elsif v_curr_salary <= 10000 then
        p_status := 'Mid-level';
    else
        p_status := 'Senior';
    end if;

    raise notice 'Status của employee với id:% là: %',p_emp_id, p_status;
end;
$$;
--  Thực thi thử:
call update_employee_status(6, null);











