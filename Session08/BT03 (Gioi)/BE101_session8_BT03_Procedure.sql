create schema if not exists bt3;

set search_path to bt3;

DROP TABLE IF EXISTS employess;

CREATE TABLE employess
(
    emp_id    serial primary key,
    emp_name  varchar(100),
    job_level int,
    salary    numeric
);

INSERT INTO employess (emp_name, job_level, salary)
VALUES ('Nguyen Van An', 1, 800.00),
       ('Tran Thi Binh', 2, 1200.00),
       ('Le Van Cuong', 3, 2000.00),
       ('Pham Thi Dung', 4, 3500.00),
       ('Hoang Van Em', 5, 5000.00),
       ('Doan Thi Phuong', 1, 900.00),
       ('Vo Van Giap', 3, 2100.00);


-- 1/ Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
--  a) Nhận emp_id của nhân viên
--  b) Cập nhật lương theo quy tắc trên
--  c) Trả về p_new_salary (lương mới) sau khi cập nhật
create or replace procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
    language plpgsql
AS
$$
declare
    v_current_level  int;
    v_current_salary numeric;
begin
    select job_level, salary
    into v_current_level, v_current_salary
    from employess
    where emp_id = p_emp_id;

    if (not FOUND)
    then
        raise exception 'không tìm thấy nhân viên với id: %',p_emp_id;
    end if;

    if v_current_level = 1 then
        p_new_salary := v_current_salary * 1.05;
    elsif v_current_level = 2 then
        p_new_salary := v_current_salary * 1.1;
    else
        p_new_salary := v_current_salary * 1.15;
    end if;

    update employess
    set salary=p_new_salary
    where emp_id = p_emp_id;

    raise notice 'Đã cập nhật lương cho NV %. Lương cũ: %, Lương mới: %', p_emp_id, v_current_salary, p_new_salary;
end;
$$;
-- 2/ Thực thi thử:
-- CÁCH 1
call adjust_salary(3, null);


-- CÁCH 2
DO
$$
    DECLARE
        bien_hung_luong NUMERIC;
    BEGIN
        CALL adjust_salary(3, bien_hung_luong);
        RAISE NOTICE 'Kết quả lương mới lấy được là: %', bien_hung_luong;
    END
$$;










