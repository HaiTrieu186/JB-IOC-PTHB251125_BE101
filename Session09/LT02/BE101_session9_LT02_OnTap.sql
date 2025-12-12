create database session09;
create schema if not exists lt2;

set search_path to lt2;

create table if not exists Users
(
    user_id  serial primary key,
    email    text,
    username varchar(50)
);

INSERT INTO Users (email, username)
SELECT 'user_' || md5(random()::text) || '@test.com',
       'user_' || generate_series
FROM generate_series(1, 1000);

INSERT INTO Users (email, username)
VALUES ('example@example.com', 'Mr. Example');

-- Tạo Hash Index trên cột email
-- Viết truy vấn SELECT * FROM Users WHERE email = 'example@example.com'; và kiểm tra kế hoạch thực hiện bằng EXPLAIN
explain analyse
SELECT *
FROM Users
WHERE email = 'example@example.com';
create index idx_users_email on Users using hash (email);

-- KHÔNG DÙNG INDEX
-- Seq Scan on users  (cost=0.00..24.51 rows=1 width=58) (actual time=0.059..0.059 rows=1.00 loops=1)
--   Filter: (email = 'example@example.com'::text)
--   Rows Removed by Filter: 1000
--   Buffers: shared hit=12
-- Planning Time: 0.053 ms
-- Execution Time: 0.070 ms

-- DÙNG INDEX HASH
-- Index Scan using idx_users_email on users  (cost=0.00..8.02 rows=1 width=58) (actual time=0.025..0.026 rows=1.00 loops=1)
--   Index Cond: (email = 'example@example.com'::text)
--   Index Searches: 1
--   Buffers: shared hit=3
-- Planning:
--   Buffers: shared hit=15
-- Planning Time: 0.167 ms
-- Execution Time: 0.036 ms


SET enable_seqscan = OFF;
RESET enable_seqscan;

