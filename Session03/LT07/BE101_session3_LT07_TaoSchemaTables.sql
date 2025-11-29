create schema if not exists sales;
set search_path to sales;

create table if not exists Products (
    product_id serial,
    product_name varchar(100) not null ,
    price numeric(10,2),
    stock_quantity int,
    constraint pk_Products primary key (product_id)
);
create table if not exists Orders (
    order_id serial,
    order_date date default now(),
    member_id int,
    constraint pk_Orders primary key (order_id),
    constraint fk_Orders foreign key (member_id) references library.members(member_id)
);
create table if not exists OrderDetails (
    order_detail_id serial,
    order_id int,
    product_id int,
    quantity int,
    constraint  pk_OrderDetails primary key (order_detail_id),
    constraint  fk1_OrderDetails foreign key (order_id) references Orders(order_id),
    constraint  fk2_OrderDetails foreign key (product_id) references Products(product_id),
    constraint check_quantity check (quantity > 0)
);