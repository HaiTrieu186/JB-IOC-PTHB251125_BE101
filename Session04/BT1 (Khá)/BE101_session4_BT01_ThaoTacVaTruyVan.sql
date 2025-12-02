Create Schema if not exists Student;

set search_path to Student;

CREATE  TABLE  if not exists Students (
    id serial,
    name varchar(50),
    age int,
    major varchar(50),
    gpa decimal(3,2),
    constraint pk_Students primary key (id)
);

INSERT INTO Students (name, age, major, gpa) values
('An',20,'CNTT',3.5),
('Bình',21,'Toán',3.2),
('Cường',22,'CNTT',3.8),
('Dương',20,'Vật lý',3.0),
('EM',21,'CNTT',2.9);


-- 1. Thêm sinh viên mới 'Hùng' vào bảng
INSERT INTO Students (name, age, major, gpa) values
('Hùng',23,'Hóa học',3.4);

-- 2. Cập nhật GPA 'Bình' thành 3.6
UPDATE Students
SET gpa = 3.6
WHERE name='Bình'

-- 3. Xóa sinh viên có GPA < 3.0
DELETE from Students
where gpa <3.0;

-- 4. Liệt kê tất cả SV (Tên, chuyên ngành) theo GPA giảm dần
SELECT name, major
From Students
ORDER BY  gpa Desc;

-- 5. Liệt kê sinh viên duy nhất có chuyên ngành 'CNTT'
SELECT  DISTINCT name
from Students
WHERE major='CNTT';

-- 6. Liệt kê sinh viên có GPA từ 3.0 đến 3.6
SELECT  name,major, gpa
from Students
WHERE gpa between 3.0 and 3.6;

-- 7. Liệt kê sinh viên có tên bắt đầu bằng 'C'
SELECT *
from Students
WHERE  name ILIKE 'C%';


-- 8a. Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần
SELECT name, major,gpa
from Students
order by name asc
limit 3;

-- 8. lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
SELECT  name, major, gpa
from Students
order by name asc
limit 3
offset 1;