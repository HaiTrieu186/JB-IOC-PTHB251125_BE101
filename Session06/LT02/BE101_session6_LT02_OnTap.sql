CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt2;

set search_path to lt2;

CREATE table if not exists Employee
(
    id         serial primary key,
    full_name  varchar(100),
    department varchar(50),
    salary     numeric(10, 2),
    hire_date  date
);

INSERT INTO Employee (full_name, department, salary, hire_date)
VALUES ('Nguyễn Văn An', 'IT', 15000000, '2023-05-10'),
       ('Trần Thị Bé', 'HR', 5000000, '2024-01-15'),
       ('Lê Thanh An', 'Marketing', 12000000, '2023-11-20'),
       ('Phạm Văn Cường', 'IT', 20000000, '2022-03-01'),
       ('Hoàng Thị Lan', 'Sale', 5500000, '2023-06-15'),
       ('Đỗ Văn Sang', 'Sale', 7000000, '2023-02-14'),
       ('Nguyễn Dev', 'IT', 9000000, '2021-12-20'),
       ('Lưu Văn AN', 'HR', 8000000, '2020-10-10');


-- 1. Thêm 6 nhân viên mới
INSERT INTO Employee (full_name, department, salary, hire_date)
VALUES ('Vũ Văn Mới', 'IT', 11000000, '2025-01-01'),
       ('Trần New', 'HR', 6500000, '2025-01-02'),
       ('Lê Thị Tươi', 'Sale', 5800000, '2025-01-03'),
       ('Phạm Văn An', 'Marketing', 13000000, '2025-01-04'),
       ('Nguyễn Phú', 'IT', 16000000, '2025-01-05'),
       ('Hoàng Hậu', 'Sale', 7500000, '2025-01-06');

-- 2. Cập nhật mức lương tăng 10% cho nhân viên thuộc phòng IT
UPDATE Employee
set salary= salary*1.1
where department='IT';

-- 3. Xóa nhân viên có mức lương dưới 6,000,000
Delete from Employee
where salary < 6000000;

-- 4. Liệt kê các nhân viên có tên chứa chữ “An” (không phân biệt hoa thường)
select *
from Employee
where full_name ilike '%An%';

-- 5.Hiển thị các nhân viên có ngày vào làm việc trong khoảng từ '2023-01-01' đến '2023-12-31'
select *
from Employee
where hire_date between '2023-01-01' and '2023-12-31';

