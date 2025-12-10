create schema if not exists bt1;
set search_path to bt1;

create  table  book (
    book_id serial primary key ,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default  current_timestamp
);

--Tạo dữ liệu giả
INSERT INTO book (title, author, genre, price)
SELECT
    -- TẠO TÊN SÁCH (Ghép tính từ + danh từ cho ngầu)
    CASE
        WHEN i % 5 = 0 THEN 'Harry Potter and the ' || (ARRAY['Philosopher''s Stone', 'Chamber of Secrets', 'Prisoner of Azkaban', 'Goblet of Fire', 'Order of the Phoenix'])[floor(random()*5)+1]
        WHEN i % 5 = 1 THEN 'The ' || (ARRAY['Lost', 'Secret', 'Dark', 'Silent', 'Hidden'])[floor(random()*5)+1] || ' ' || (ARRAY['Kingdom', 'Garden', 'Forest', 'Mystery', 'Legacy'])[floor(random()*5)+1]
        WHEN i % 5 = 2 THEN 'Journey to the ' || (ARRAY['West', 'Center of Earth', 'Moon', 'End of Time'])[floor(random()*4)+1]
        ELSE 'The Code of ' || (ARRAY['Da Vinci', 'Destiny', 'Honor', 'Silence'])[floor(random()*4)+1]
        END AS title,

    -- TẠO TÁC GIẢ (Cứ 5 ông thì có 1 ông Rowling để test)
    CASE
        WHEN i % 5 = 0 THEN 'J.K. Rowling'  -- Quan trọng: Để test ILIKE '%Rowling'
        WHEN i % 5 = 1 THEN 'J.R.R. Tolkien'
        WHEN i % 5 = 2 THEN 'Stephen King'
        WHEN i % 5 = 3 THEN 'Dan Brown'
        ELSE 'Agatha Christie'
        END AS author,

    -- TẠO THỂ LOẠI (Cứ 3 cuốn thì có 1 cuốn Fantasy)
    CASE
        WHEN i % 3 = 0 THEN 'Fantasy'       -- Quan trọng: Để test genre = 'Fantasy'
        WHEN i % 3 = 1 THEN 'Mystery'
        ELSE 'Sci-Fi'
        END AS genre,

    -- GIÁ TIỀN (Số lẻ nhìn cho đẹp, vd: 19.99)
    (floor(random() * 50) + 10) + 0.99 AS price

FROM generate_series(1, 10000) AS i;

DROP TABLE IF EXISTS book;




-- 1/ Tạo các chỉ mục phù hợp để tối ưu truy vấn sau:
-- a) select * from book where author ilike '%Rowling';
-- Đối với câu lệnh này em nghĩ nên dùng GIN vì đây là tìm văn bản
CREATE EXTENSION pg_trgm;
CREATE EXTENSION btree_gin;
CREATE INDEX index_book_author ON book USING GIN (author);

-- b) select * from book where genre = 'Fantasy';
-- Đối với câu lệnh b) em nghĩ nên dùng B-tree
-- hoặc Hash đều được vì đây là câu truy vấn cho tác giả có thể sắp xếp nữa nên phải dùng B-tree
create index idx_book_genre on book(genre);

drop index  idx_book_genre;
drop index  index_book_author;















-- 2/ So sánh thời gian truy vấn trước và sau khi tạo Index (dùng EXPLAIN ANALYZE)
explain analyse select * from book where author ilike '%Rowling';
--KHÔNG DÙNG INDEX
--     Seq Scan on book  (cost=0.00..244.00 rows=2000 width=95) (actual time=0.085..4.413 rows=2000.00 loops=1)
--       Filter: ((author)::text ~~* '%Rowling'::text)
--       Rows Removed by Filter: 8000
--       Buffers: shared hit=119
--     Planning:
--       Buffers: shared hit=32
--     Planning Time: 0.673 ms
--     Execution Time: 4.492 ms

-- DÙNG INDEX
--         Seq Scan on book  (cost=0.00..244.00 rows=2000 width=95) (actual time=0.011..3.769 rows=2000.00 loops=1)
--           Filter: ((author)::text ~~* '%Rowling'::text)
--           Rows Removed by Filter: 8000
--           Buffers: shared hit=119
--         Planning:
--           Buffers: shared hit=19
--         Planning Time: 0.211 ms
--         Execution Time: 3.826 ms



explain analyse select * from book where genre = 'Fantasy';
-- KHÔNG DÙNG INDEX
--         Seq Scan on book  (cost=0.00..244.00 rows=3333 width=95) (actual time=0.014..0.680 rows=3333.00 loops=1)
--           Filter: ((genre)::text = 'Fantasy'::text)
--           Rows Removed by Filter: 6667
--           Buffers: shared hit=119
--         Planning:
--           Buffers: shared hit=49
--         Planning Time: 0.430 ms
--         Execution Time: 0.768 ms

-- DÙNG INDEX
-- Bitmap Heap Scan on book  (cost=42.12..202.78 rows=3333 width=95) (actual time=0.213..0.595 rows=3333.00 loops=1)
--   Recheck Cond: ((genre)::text = 'Fantasy'::text)
--   Heap Blocks: exact=119
--   Buffers: shared hit=119 read=4
--   ->  Bitmap Index Scan on idx_book_genre  (cost=0.00..41.28 rows=3333 width=0) (actual time=0.187..0.188 rows=3333.00 loops=1)
--         Index Cond: ((genre)::text = 'Fantasy'::text)
--         Index Searches: 1
--         Buffers: shared read=4
-- Planning:
--   Buffers: shared hit=39 read=1
-- Planning Time: 6.366 ms
-- Execution Time: 0.681 ms











-- 3. Thử nghiệm các loại chỉ mục khác nhau:
-- B-tree cho genre
-- GIN cho title hoặc description (phục vụ tìm kiếm full-text)
create index idx_book_genre on book(genre);

create index idx_book_title on book using gin(title);






--- 4. Tạo một Clustered Index (sử dụng lệnh CLUSTER) trên
-- bảng book theo cột genre và kiểm tra sự khác biệt trong hiệu suất
 create index idx_book_genre on book(genre);
cluster  book using idx_book_genre;



