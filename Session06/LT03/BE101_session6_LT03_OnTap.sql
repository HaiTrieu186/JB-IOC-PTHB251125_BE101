CREATE DATABASE Session06;
CREATE SCHEMA if not exists lt3;

set search_path to lt2;

CREATE table if not exists Customer
(
    id     serial primary key,
    name   varchar(100),
    email  varchar(100),
    phone  varchar(20),
    points int
);


INSERT INTO Customer (name, email, phone, points)
VALUES ('Nguyễn Văn An', 'an.nguyen.old@example.com', '0911111111', 250),
       ('Lê Thị Top', 'top.le@example.com', '0922222222', 800),
       ('Trần Văn Không Email', NULL, '0933333333', 120),
       ('Hoàng Thị D', 'd.hoang@example.com', '0944444444', 300),
       ('Phạm Văn E', 'e.pham@example.com', '0955555555', 50);


-- 1.Thêm 7 khách hàng (trong đó có 1 người không có email)
INSERT INTO Customer (name, email, phone, points)
VALUES ('Phan Văn Hùng', 'hung.phan@gmail.com', '0961111111', 600),
       ('Đỗ Thị Không Mail', NULL, '0962222222', 90),
       ('Nguyễn Văn An', 'an.nguyen.new@company.com', '0963333333', 150),
       ('Lý Văn Giàu', 'giau.ly@vip.com', '0964444444', 950),
       ('Trương Mỹ Lan', 'lan.truong@test.com', '0965555555', 420),
       ('Bùi Văn Tí', 'ti.bui@yahoo.com', '0966666666', 30),
       ('Võ Thị Sáu', 'sau.vo@gmail.com', '0967777777', 310);


-- 2. Truy vấn danh sách tên khách hàng duy nhất (DISTINCT)
select distinct name
from Customer;

-- 3.Tìm các khách hàng chưa có email (IS NULL)
select *
from Customer
where email is null;

-- 4.Hiển thị 3 khách hàng có điểm thưởng cao nhất,
-- bỏ qua khách hàng cao điểm nhất (gợi ý: dùng OFFSET)
select *
from Customer
order by points desc
limit 3 offset 1;