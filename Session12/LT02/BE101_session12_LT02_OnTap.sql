create database session12;
create schema if not exists lt2;

set search_path to lt2;

drop table products, sales;

create table products
(
    product_id serial primary key,
    name       varchar(50),
    stock      int
);

create table sales
(
    sale_id    serial primary key,
    product_id int references products (product_id),
    quantity   int
);

insert into products(name, stock)
values ('ABC', 100),
       ('DEF', 50);

create or replace function check_stock()
    returns trigger
as
$$
declare
    v_stock int;
begin
    select stock
    into v_stock
    from products
    where product_id = new.product_id;

    if (new.quantity > v_stock) then
        raise exception 'Khong du so luong hang trong kho !';
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_check_Stock
    before insert
    on sales
    for each row
execute function check_stock();

insert into sales(product_id, quantity)
values (1, 30);

insert into sales(product_id, quantity)
values (1, 200);