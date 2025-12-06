CREATE schema if not exists bt6;
set search_path to bt6;


DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments
(
    dept_id   SERIAL PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees
(
    emp_id    SERIAL PRIMARY KEY,
    emp_name  VARCHAR(100),
    dept_id   INT REFERENCES departments (dept_id),
    salary    NUMERIC(10, 2),
    hire_date DATE
);

CREATE TABLE projects
(
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id      INT REFERENCES departments (dept_id)
);

INSERT INTO departments (dept_name)
VALUES ('Phòng IT'),
       ('Phòng Nhân sự'),
       ('Phòng Marketing'),
       ('Phòng Kế toán');

INSERT INTO employees (emp_name, dept_id, salary, hire_date)
VALUES ('Nguyễn Dev', 1, 2000.00, '2023-01-15'),
       ('Trần Coder', 1, 2500.00, '2022-05-20'),
       ('Lê HR', 2, 1500.00, '2024-01-10'),
       ('Phạm Sale', 3, 1800.00, '2023-11-05'),
       ('Hoàng Newbie', NULL, 1000.00, '2025-03-01'),
       ('Đỗ Manager', 1, 5000.00, '2020-01-01');

INSERT INTO projects (project_name, dept_id)
VALUES ('Website E-commerce', 1),
       ('App Mobile', 1),
       ('Tuyển dụng 2025', 2),
       ('Chiến dịch Mùa hè', 3),
       ('Dự án Bí mật', NULL);


-- 1.ALIAS:
-- Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
-- dùng bí danh bảng ngắn (employees as e,departments as d).
select e.emp_id, e.emp_name, d.dept_name, e.salary
from employees e
         join departments d on e.dept_id = d.dept_id;


-- 2. Aggregate Functions:
-- Tính:
-- Tổng quỹ lương toàn công ty
-- Mức lương trung bình
-- Lương cao nhất, thấp nhất
-- Số nhân viên
select sum(salary)   as "Tổng quỹ lương",
       avg(salary)   as "Mức lương trung bình",
       max(salary)   as "Lương cao nhất",
       min(salary)   as "Lương thấp nhất",
       count(emp_id) as "Số nhân viên"
from employees;


-- 3. GROUP BY / HAVING:
-- Tính mức lương trung bình của từng phòng ban
-- chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
select d.dept_id, d.dept_name, avg(e.salary) as "Lương TB"
from departments d
         join employees e on d.dept_id = e.dept_id
group by d.dept_id
having avg(e.salary) > 15000000;


-- 4. JOIN:
-- Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách
-- và nhân viên thuộc phòng ban đó
select p.project_name, d.dept_name, e.emp_name
from departments d
         join projects p on d.dept_id = p.dept_id
         join employees e on d.dept_id = e.dept_id


-- 5.Subquery:
-- Tìm nhân viên có lương cao nhất trong mỗi phòng ban
-- Gợi ý: Subquery lồng trong WHERE salary = (SELECT MAX(...))

-- Cách 1
select *
from employees
where (dept_id, salary) in (select e.dept_id, max(e.salary)
                            from employees e
                            group by e.dept_id);

-- Cách 2
SELECT *
FROM employees e1
WHERE salary = (SELECT MAX(salary)
                FROM employees e2
                WHERE e2.dept_id = e1.dept_id);

-- 6. UNION và INTERSECT:
-- UNION: Liệt kê danh sách tất cả các phòng ban có nhân viên hoặc có dự án
select distinct d.*
from departments d
         join employees e on d.dept_id = e.dept_id
union
select distinct d.*
from departments d
         join projects on d.dept_id = projects.dept_id;

-- INTERSECT: Liệt kê các phòng ban vừa có nhân viên vừa có dự án
select distinct d.*
from departments d
         join employees e on d.dept_id = e.dept_id
intersect
select distinct d.*
from departments d
         join projects on d.dept_id = projects.dept_id;
