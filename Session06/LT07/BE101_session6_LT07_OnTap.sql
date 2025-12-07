CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt7;

set search_path to lt7;

CREATE table if not exists Department
(
    id   serial primary key,
    name varchar(50)
);

create table if not exists Employee
(
    id            serial primary key,
    full_name     varchar(100),
    department_id int references Department (id),
    salary        numeric(10, 2)
);

drop table Employee, Department;

INSERT INTO Department (name)
VALUES ('Phòng IT'),
       ('Phòng Kinh doanh'),
       ('Phòng Kho vận'),
       ('Phòng Hành chính');

INSERT INTO Employee (full_name, department_id, salary)
VALUES ('Nguyễn Văn An', 1, 25000000),
       ('Trần Thị Bình', 1, 18000000),
       ('Lê Văn Cường', 2, 8000000),
       ('Phạm Thị Dung', 2, 9500000),
       ('Hoàng Văn Em', 3, 7000000);

-- 1. Liệt kê danh sách nhân viên cùng tên phòng ban của họ (INNER JOIN)
select e.*, d.name
from Employee e
         join Department d on e.department_id = d.id;

-- 2. Tính lương trung bình của từng phòng ban, hiển thị:
-- department_name
-- avg_salary
-- Gợi ý: dùng GROUP BY và bí danh cột
select d.id, d.name, avg(e.salary)
from Employee e
         join Department d on e.department_id = d.id
group by d.id
order by d.id;


-- 3. Hiển thị các phòng ban có lương trung bình > 10 triệu (HAVING)
select d.id, d.name, avg(e.salary)
from Employee e
         join Department d on e.department_id = d.id
group by d.id
having avg(e.salary) > 10000000
order by d.id;


-- 4. Liệt kê phòng ban không có nhân viên nào
-- (LEFT JOIN + WHERE employee.id IS NULL)
select d.*
from Department d
         left join Employee E on d.id = E.department_id
where e.department_id isnull;
