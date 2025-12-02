CREATE SCHEMA if not exists BT5;
set search_path to BT5;

CREATE table if not exists employees
(
    id         serial,
    full_name  varchar(100) not null,
    department varchar(50)  not null,
    position   varchar(50),
    salary     numeric(10, 2),
    bonus      numeric(10, 2),
    join_year  int check ( join_year <= EXTRACT(YEAR from current_date)),
    constraint pk_products primary key (id)
);

INSERT INTO employees (full_name, department, position, salary, bonus, join_year)
VALUES ('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021),
       ('Trần Thị Mai', 'HR', 'Recruiter', 12000000, NULL, 2020),
       ('Lê Quốc Trung', 'IT', 'Tester', 15000000, 800000, 2023),
       ('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021),
       ('Phạm Ngọc Hân', 'Finance', 'Accountant', 14000000, NULL, 2019),
       ('Bùi Thị Lan', 'HR', 'HR Manager', 20000000, 3000000, 2018),
       ('Đặng Hữu Tài', 'IT', 'Developer', 17000000, NULL, 2022);

TRUNCATE employees;

-- 1. Xóa các bản ghi trùng nhau hoàn toàn về tên, phòng ban và vị trí
DELETE
from employees
where id not in (SELECT min(id)
                 from employees
                 GROUP BY full_name, department, position, salary, bonus, join_year);

-- 2.Cập nhật lương thưởng:
-- Tăng 10% lương cho những nhân viên làm trong phòng IT có mức lương dưới 18,000,000
UPDATE employees
set salary = salary * 1.1
where department = 'IT'
  and salary < 18000000.00;

-- Với nhân viên có bonus IS NULL, đặt giá trị bonus = 500000
update employees
set bonus=500000
where bonus isnull;


-- 3.Truy vấn:
-- Hiển thị danh sách nhân viên thuộc phòng IT hoặc HR, gia nhập sau năm 2020, và có tổng thu nhập (salary + bonus) lớn hơn 15,000,000
select *
from employees
where department in ('IT', 'HR')
  and join_year >= 2020
  and (salary + bonus) > 15000000.00;

-- Chỉ lấy 3 nhân viên đầu tiên sau khi sắp xếp giảm dần theo tổng thu nhập
select *
from employees
order by (salary + bonus) desc
limit 3;


-- 4.Tìm tất cả nhân viên có tên bắt đầu bằng “Nguyễn” hoặc kết thúc bằng “Hân”
select *
from employees
where full_name ilike 'Nguyễn%'
   or full_name ilike '%Hân';

-- 5.Liệt kê các phòng ban duy nhất có ít nhất một nhân viên có bonus IS NOT NULL
select distinct department
from employees
where bonus is not null;

-- 6. Hiển thị nhân viên gia nhập trong khoảng từ 2019 đến 2022 (BETWEEN)
select *
from employees
where join_year BETWEEN 2019 and 2022;