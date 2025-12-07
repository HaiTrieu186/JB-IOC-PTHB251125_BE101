CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt5;

set search_path to lt5;

CREATE table if not exists Course
(
    id         serial primary key,
    title      varchar(100),
    instructor varchar(50),
    price      numeric(10, 2),
    duration   int
);


-- 1. Thêm ít nhất 6 khóa học vào bảng
INSERT INTO Course (title, instructor, price, duration)
VALUES ('Lập trình Python cơ bản', 'Nguyễn Văn A', 400000, 20),
       ('Master sql for Data Science', 'Trần Thị B', 600000, 35),
       ('Khóa học thử nghiệm Demo', 'Admin', 0, 5),
       ('Web Fullstack từ A-Z', 'Lê Cường', 1500000, 50),
       ('PostgreSQL Advanced', 'Vũ F', 1800000, 25),
       ('ReactJS Demo Version', 'Admin', 100000, 2);


-- 2. Cập nhật giá tăng 15% cho các khóa học có thời lượng trên 30 giờ
update Course
set price=price * 1.15
where duration > 30;

-- 3. Xóa khóa học có tên chứa từ khóa “Demo”
delete
from Course
where title ilike '%Demo%';

-- 4.Hiển thị các khóa học có tên chứa từ “SQL” (không phân biệt hoa thường)
delete
from Course
where title ilike '%SQL%';

-- 5.Lấy 3 khóa học có giá nằm giữa 500,000 và 2,000,000, sắp xếp theo giá giảm dần
select *
from Course
where price between 500000 and 2000000
order by price desc;