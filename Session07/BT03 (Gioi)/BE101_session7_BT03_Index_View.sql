create schema if not exists bt3;
set search_path to bt3;

drop table if exists customer;
drop table if exists orders;

create schema if not exists bt3;
set search_path to bt3, bt1;

drop table if exists posts;

create table if not exists posts
(
    post_id    serial primary key,
    user_id    int,
    content    text,
    tags       text[],
    is_public  boolean   default true,
    created_at timestamp default current_timestamp
);

create table if not exists post_like
(
    user_id  int not null,
    post_id  int not null,
    liked_at timestamp default current_timestamp,
    primary key (user_id, post_id)
);

INSERT INTO posts (user_id, content, tags, is_public, created_at)
VALUES (1, 'Hoc SQL co ban rat vui', ARRAY ['education', 'sql'], true, '2023-10-01 08:00:00'),
       (2, 'Hom nay troi dep qua', ARRAY ['life', 'weather'], true, '2023-10-02 09:30:00'),
       (1, 'Bi mat khong duoc bat mi', ARRAY ['secret'], false, '2023-10-05 10:00:00'),
       (3, 'PostgreSQL index deep dive', ARRAY ['tech', 'sql', 'postgresql'], true, '2023-11-01 14:00:00'),
       (2, 'Check in tai Ha Noi', ARRAY ['travel', 'food'], true, now() - interval '1 day'),
       (4, 'Review sach lap trinh', ARRAY ['education', 'book'], true, now() - interval '2 days'),
       (5, 'Tam su dem khuya', ARRAY ['life'], false, now() - interval '5 days');


INSERT INTO post_like (user_id, post_id, liked_at)
VALUES (2, 1, '2023-10-01 10:00:00'),
       (3, 1, '2023-10-02 08:15:00'),
       (1, 2, '2023-10-02 10:00:00'),
       (4, 3, '2023-10-05 11:30:00'),
       (1, 4, '2023-11-01 15:00:00'),
       (2, 4, '2023-11-01 16:45:00'),
       (5, 4, '2023-11-02 09:00:00'),
       (3, 5, now() - interval '2 hours'),
       (1, 6, now() - interval '1 day'),
       (2, 6, now() - interval '5 hours');


--1. Tối ưu hóa truy vấn tìm kiếm bài đăng công khai theo từ khóa:
select *
from posts
where  is_public= true and content ilike '%du lich%';

-- Nếu tối ưu cả câu lệnh
-- CREATE EXTENSION IF NOT EXISTS pg_trgm;
-- CREATE INDEX idx_content_trgm ON bt3.posts USING GIN (content bt1.gin_trgm_ops)
-- WHERE is_public = true;;

-- a.Tạo Expression Index sử dụng LOWER(content) để tăng tốc tìm kiếm
create index idx_posts_content_lower  on posts(lower(posts.content));

explain analyse select * from posts where lower(content) = 'hoc sql co ban rat vui';

-- b. So sánh hiệu suất trước và sau khi tạo chỉ mục
-- CHƯA TẠO INDEX
-- Seq Scan on posts  (cost=0.00..1.10 rows=1 width=81) (actual time=0.321..0.324 rows=1.00 loops=1)
--   Filter: (lower(content) = 'hoc sql co ban rat vui'::text)
--   Rows Removed by Filter: 6
--   Buffers: shared hit=1
-- Planning Time: 0.095 ms
-- Execution Time: 0.344 ms

-- Seq Scan on posts  (cost=0.00..1.10 rows=1 width=81) (actual time=0.022..0.025 rows=1.00 loops=1)
--   Filter: (lower(content) = 'hoc sql co ban rat vui'::text)
--   Rows Removed by Filter: 6
--   Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=17 read=1
-- Planning Time: 0.602 ms
-- Execution Time: 0.042 ms



-- 2. Tối ưu hóa truy vấn lọc bài đăng theo thẻ (tags):
-- a. Tạo GIN Index cho cột tags
create index idx_posts_tags on posts using  gin(tags);
-- b. phân tích hiệu suất
explain analyse select *
from posts
where tags @> ARRAY ['travel'];
    -- CHƯA CÓ INDEX
    -- Seq Scan on posts  (cost=0.00..1.09 rows=1 width=81) (actual time=0.017..0.017 rows=1.00 loops=1)
    --   Filter: (tags @> '{travel}'::text[])
    --   Rows Removed by Filter: 6
    --   Buffers: shared hit=1
    -- Planning Time: 0.091 ms
    -- Execution Time: 0.029 ms


    -- ĐÃ CÓ INDEX
    -- Seq Scan on posts  (cost=0.00..1.09 rows=1 width=81) (actual time=0.010..0.011 rows=1.00 loops=1)
    --   Filter: (tags @> '{travel}'::text[])
    --   Rows Removed by Filter: 6
    --   Buffers: shared hit=1
    -- Planning:
    --   Buffers: shared hit=1
    -- Planning Time: 0.082 ms
    -- Execution Time: 0.019 ms





-- 3/ Tối ưu hóa truy vấn tìm bài đăng mới trong 7 ngày gần nhất:
-- a. Tạo Partial Index cho bài viết công khai gần đây:
    create  index  idx_posts_recent_public
    on posts(created_at desc)
    where  is_public=true;
-- b. Kiểm tra hiệu suất với truy vấn:
explain analyse select *
from posts
where  is_public=true and created_at> now() - interval '7 days';
    -- Không dùng index
    -- Seq Scan on posts  (cost=0.00..1.12 rows=1 width=81) (actual time=0.019..0.020 rows=2.00 loops=1)
    --   Filter: (is_public AND (created_at > (now() - '7 days'::interval)))
    --   Rows Removed by Filter: 5
    --   Buffers: shared hit=1
    -- Planning Time: 0.103 ms
    -- Execution Time: 0.044 ms

    -- DÙNG INDEX
    -- Seq Scan on posts  (cost=0.00..1.12 rows=1 width=81) (actual time=0.017..0.017 rows=2.00 loops=1)
    --   Filter: (is_public AND (created_at > (now() - '7 days'::interval)))
    --   Rows Removed by Filter: 5
    --   Buffers: shared hit=1
    -- Planning:
    --   Buffers: shared hit=19 read=1
    -- Planning Time: 0.485 ms
    -- Execution Time: 0.040 ms


-- 4. Phân tích chỉ mục tổng hợp (Composite Index):
-- a) Tạo chỉ mục (user_id, created_at DESC)
create index idx_posts_userId_CreatedaAt on
posts(user_id, created_at desc);
-- b) Kiểm tra hiệu suất khi người dùng xem “bài đăng gần đây của bạn bè”

-- Giả sử danh sách bạn bè của tôi là User 2 và User 3
EXPLAIN ANALYSE
SELECT *
FROM posts
WHERE user_id IN (2, 3) -- Lọc theo ID người dùng (bạn bè)
ORDER BY created_at DESC; -- Sắp xếp bài mới nhất
        -- KHÔNG DÙNG INDEX
        -- Sort  (cost=1.10..1.10 rows=2 width=81) (actual time=1.310..1.311 rows=3.00 loops=1)
        --   Sort Key: created_at DESC
        --   Sort Method: quicksort  Memory: 25kB
        --   Buffers: shared hit=1
        --   ->  Seq Scan on posts  (cost=0.00..1.09 rows=2 width=81) (actual time=0.403..0.404 rows=3.00 loops=1)
        -- "        Filter: (user_id = ANY ('{2,3}'::integer[]))"
        --         Rows Removed by Filter: 4
        --         Buffers: shared hit=1
        -- Planning:
        --   Buffers: shared hit=21
        -- Planning Time: 4.790 ms
        -- Execution Time: 1.760 ms

        -- DÙNG INDEX
        -- Sort  (cost=1.10..1.10 rows=2 width=81) (actual time=0.023..0.024 rows=3.00 loops=1)
        --   Sort Key: created_at DESC
        --   Sort Method: quicksort  Memory: 25kB
        --   Buffers: shared hit=1
        --   ->  Seq Scan on posts  (cost=0.00..1.09 rows=2 width=81) (actual time=0.013..0.013 rows=3.00 loops=1)
        -- "        Filter: (user_id = ANY ('{2,3}'::integer[]))"
        --         Rows Removed by Filter: 4
        --         Buffers: shared hit=1
        -- Planning:
        --   Buffers: shared hit=19 read=1
        -- Planning Time: 0.343 ms
        -- Execution Time: 0.037 ms


