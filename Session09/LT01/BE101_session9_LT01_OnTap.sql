create database session09;
create schema if not exists lt1;

set search_path to lt1;

create table if not exists Orders
(
    order_id     serial primary key,
    customer_id  int,
    order_date   date,
    total_amount numeric(10, 2)
);

INSERT INTO Orders (customer_id, order_date, total_amount)
SELECT (random() * 100 + 1)::int,
       CURRENT_DATE - (random() * 365)::int,
       (random() * 1000 + 50)::numeric(10, 2)
FROM generate_series(1, 10000);

--Tạo một B-Tree Index trên cột customer_id
-- Thực hiện truy vấn SELECT * FROM Orders WHERE customer_id = X; trước và sau khi tạo Index, so sánh thời gian thực hiện
explain analyse
SELECT *
FROM Orders
WHERE customer_id = 50;
create index idx_orders_customer_id on orders (customer_id);

SET enable_seqscan = OFF;
RESET enable_seqscan;

-- KHOONG DÙNG INDEX
-- Seq Scan on orders  (cost=0.00..189.00 rows=89 width=18) (actual time=0.017..0.394 rows=89.00 loops=1)
--   Filter: (customer_id = 50)
--   Rows Removed by Filter: 9911
--   Buffers: shared hit=64
-- Planning Time: 0.070 ms
-- Execution Time: 0.407 ms


-- DÙNG INDEX
-- Bitmap Heap Scan on orders  (cost=4.97..73.40 rows=89 width=18) (actual time=0.083..0.123 rows=89.00 loops=1)
--   Recheck Cond: (customer_id = 50)
--   Heap Blocks: exact=50
--   Buffers: shared hit=50 read=2
--   ->  Bitmap Index Scan on idx_orders_customer_id  (cost=0.00..4.95 rows=89 width=0) (actual time=0.031..0.031 rows=89.00 loops=1)
--         Index Cond: (customer_id = 50)
--         Index Searches: 1
--         Buffers: shared read=2
-- Planning:
--   Buffers: shared hit=15 read=1
-- Planning Time: 0.273 ms
-- Execution Time: 0.140 ms

