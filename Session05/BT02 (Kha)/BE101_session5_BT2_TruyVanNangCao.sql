CREATE schema if not exists bt2;
set search_path to bt1;


-- 1. Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
-- Hiển thị: product_name, total_revenue
select p.product_id, p.product_name, sum(o.total_price) as "total_revenue"
from products p
         join orders o on p.product_id = o.product_id
group by p.product_id
having sum(o.total_price) = (select sum(o.total_price)
                             from orders o
                             group by o.product_id
                             order by sum(o.total_price) desc
                             limit 1)
order by p.product_id;

-- 2.Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
select p.category, sum(o.total_price) as "total_revenue"
from products p
         join orders o on p.product_id = o.product_id
group by p.category;


-- 3. Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cũng nằm trong danh sách nhóm có tổng doanh thu lớn hơn 3000
select p.category, sum(o.total_price) as "total_revenue"
from products p
         join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) = (select sum(o.total_price) as "total_revenue"
                             from products p
                                      join orders o on p.product_id = o.product_id
                             group by p.category
                             order by sum(o.total_price) desc
                             limit 1)

intersect

select p.category, sum(o.total_price) as "total_revenue"
from products p
         join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) > 3000;