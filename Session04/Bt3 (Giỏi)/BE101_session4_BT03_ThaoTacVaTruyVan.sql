CREATE SCHEMA if not exists BT3;
set search_path to BT3;


CREATE TYPE gender_enum AS ENUM ('Nam', 'Nữ', 'Khác');
CREATE table if not exists students
(
    id         serial,
    full_name  varchar(50) not null,
    gender     gender_enum,
    birth_year int,
    major      varchar(50) not null,
    gpa        decimal(3, 2),
    constraint pk_products primary key (id),
    constraint check_gpa check ( gpa between 0.00 and 4.00)
);

INSERT INTO students (full_name, gender, birth_year, major, gpa)
values ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Trần Thị Bích Ngọc', 'Nữ', 2001, 'Kinh tế', 3.2),
       ('Lê Quốc Cường', 'Nam', 2003, 'CNTT', 2.7),
       ('Phạm Minh Anh', 'Nữ', 2000, 'Luật', 3.9),
       ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Lưu Đức Tài', 'Nam', 2004, 'Cơ khí', NULL),
       ('Võ Thị Thu Hằng', 'Nữ', 2001, 'CNTT', 3.0);


-- 1. Thêm dữ liệu mới
INSERT INTO students (full_name, gender, birth_year, major, gpa)
values ('Phan Hoàng Nam', 'Nam', 2003, 'CNTT', 3.80);

-- 2. Cập nhật dữ liệu
UPDATE students
set gpa = 3.40
where full_name = 'Lê Quốc Cường';


-- 3. Xóa tất cả sinh viên có gpa IS NULL
DELETE
from students
where gpa is null;


-- 4.Hiển thị sinh viên ngành CNTT có gpa >= 3.0, chỉ lấy 3 kết quả đầu tiên
select *
from students
where gpa >= 3.00
order by gpa asc
limit 3

-- 5. Liệt kê danh sách ngành học duy nhất
select distinct major
from students;

-- 6. Hiển thị sinh viên ngành CNTT, sắp xếp giảm dần theo GPA, sau đó tăng dần theo tên
select *
from students
order by gpa desc, full_name asc;

-- 7. Tìm sinh viên có tên bắt đầu bằng “Nguyễn”
select *
from students
where full_name ilike 'Nguyễn%';

-- 8. Hiển thị sinh viên có năm sinh từ 2001 đến 2003
select *
from students
where birth_year between 2001 and 2003;