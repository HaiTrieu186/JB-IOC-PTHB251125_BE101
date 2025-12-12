create schema if not exists bt6;

set search_path to bt6;

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


-- Tạo procedure calculate_bonus để:
--
-- Tham số vào:
-- p_emp_id INT — mã nhân viên
-- p_percent NUMERIC — phần trăm thưởng
-- Tham số ra:
-- p_bonus NUMERIC — giá trị thưởng tính được

create or replace procedure calculate_bonus(
    p_emp_id INT,
    p_percent NUMERIC,
    OUT p_bonus numeric
)
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

    if p_percent > 0 then
        p_bonus := v_curr_salary * p_percent / 100;
    else
        p_bonus := 0;
    end if;

    update employess
    set bonus=p_bonus
    where id = p_emp_id;

    raise notice 'Bonus của nhân viên có id % là: %',p_emp_id, p_bonus;
end;
$$;
--  Thực thi thử:
call calculate_bonus(2, 15, null);











