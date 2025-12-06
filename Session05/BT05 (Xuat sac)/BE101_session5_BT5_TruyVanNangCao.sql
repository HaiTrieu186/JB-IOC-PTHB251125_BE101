CREATE schema if not exists bt5;
set search_path to bt5;


-- 1. Bảng Sinh viên
CREATE TABLE students
(
    student_id SERIAL PRIMARY KEY,
    full_name  VARCHAR(100),
    major      VARCHAR(50)
);

-- 2. Bảng Khóa học (Môn học)
CREATE TABLE courses
(
    course_id   SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit      INT -- Số tín chỉ
);

-- 3. Bảng Đăng ký (Bảng trung gian Many-to-Many)
CREATE TABLE enrollments
(
    student_id INT REFERENCES students (student_id),
    course_id  INT REFERENCES courses (course_id),
    score      NUMERIC(5, 2),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO students (full_name, major)
VALUES ('Nguyễn Văn An', 'CNTT'),
       ('Trần Thị Bình', 'Kinh Tế'),
       ('Lê Văn Cường', 'Luật'),
       ('Phạm Thị Dung', 'CNTT'),
       ('Hoàng Văn Em', NULL),
       ('Đỗ Văn F', 'CNTT');

INSERT INTO courses (course_name, credit)
VALUES ('Cơ sở dữ liệu', 3),
       ('Lập trình Java', 4),
       ('Triết học Mác-Lênin', 2),
       ('Toán cao cấp', 3),
       ('Kỹ năng mềm', 1);

INSERT INTO enrollments (student_id, course_id, score)
VALUES (1, 1, 9.0),
       (1, 2, 8.5),
       (1, 3, 7.0),
       (2, 3, 6.5),
       (2, 4, 5.0),
       (3, 1, 3.5),
       (3, 4, NULL),
       (4, 2, 10.0),
       (4, 1, NULL),
       (5, 3, 2.0);


-- 1.ALIAS:
-- Liệt kê danh sách sinh viên cùng tên môn học và điểm
-- dùng bí danh bảng ngắn (vd. s, c, e)
-- và bí danh cột như Tên sinh viên, Môn học, Điểm
select s.student_id  as "MSSV",
       s.full_name   as "Tên Sinh Viên",
       c.course_name as "Môn học",
       e.score       as "Điểm"
from students s
         join enrollments e on s.student_id = e.student_id
         join courses c on e.course_id = c.course_id

-- 2.Aggregate Functions:
-- Tính cho từng sinh viên:
-- Điểm trung bình
-- Điểm cao nhất
-- Điểm thấp nhất

select s.student_id as "MSSV",
       s.full_name  as "Tên sinh viên",
       avg(e.score) as "Điểm trung bình",
       max(e.score) as "Điểm cao nhất",
       min(e.score) as "Điểm thấp nhất"
from students s
         join enrollments e on s.student_id = e.student_id
group by s.student_id;



-- 3. GROUP BY / HAVING:
-- Tìm ngành học (major) có điểm trung bình cao hơn 7.5
select c.course_id, c.course_name, avg(e.score)
from courses c
         join enrollments e on c.course_id = e.course_id
group by c.course_id
having avg(e.score) > 7.5;

-- 4. JOIN:
-- Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
select s.student_id, s.full_name, c.course_name, c.credit, e.score
from students s
         join enrollments e on s.student_id = e.student_id
         join courses c on e.course_id = c.course_id;

-- 5. Subquery:
-- Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
-- Gợi ý: dùng AVG(score) trong subquery
-- B1 : tính điểm tb theo từng sv,
select avg(e.score)
from students s
         join enrollments e on s.student_id = e.student_id
group by s.student_id;
-- B2 : tính trung bình cộng điểm số
select avg(bang_diem_tb.diem_tb)
from (select avg(e.score) as "diem_tb"
      from students s
               join enrollments e on s.student_id = e.student_id
      group by s.student_id) as bang_diem_tb;

-- B3 : lọc theo điểm tb vừa tính được
select s.student_id, s.full_name, avg(e.score)
from students s
         join enrollments e on s.student_id = e.student_id
group by s.student_id
having avg(e.score) >
       (select avg(bang_diem_tb.diem_tb)
        from (select avg(e.score) as "diem_tb"
              from students s
                       join enrollments e on s.student_id = e.student_id
              group by s.student_id) as bang_diem_tb
);



-- 6. UNION và INTERSECT:
-- UNION: Danh sách sinh viên có điểm >= 9 hoặc đã học ít nhất một môn
select distinct s.*
from students s join enrollments e on s.student_id = e.student_id
where e.score>=9

union

select distinct s.*
from students s join enrollments e on s.student_id = e.student_id

-- INTERSECT: Danh sách sinh viên thỏa cả hai điều kiện trên
select distinct s.*
from students s join enrollments e on s.student_id = e.student_id
where e.score>=9

intersect

select distinct s.*
from students s join enrollments e on s.student_id = e.student_id











