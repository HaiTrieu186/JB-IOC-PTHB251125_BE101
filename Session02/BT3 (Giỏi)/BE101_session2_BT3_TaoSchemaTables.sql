create schema if not exists sales;

set search_path to sales;

create table if not exists Customers
(
    customer_id serial,
    first_name  varchar(50) not null,
    last_name   varchar(50) not null,
    email       text        not null unique,
    phone       char(10),
    constraint pk_Customers primary key (customer_id)
);


create table if not exists Products
(
    product_id     serial,
    product_name   varchar(100) not null,
    price          float        not null,
    stock_quantity int          not null
);


create table if not exists Orders
(
    order_id    serial,
    order_date  date not null default now(),
    customer_id int,
    constraint pk_orders primary key (order_id),
    constraint fk_orders foreign key (customer_id) references Customers (customer_id)
);


create table if not exists OrderItems
(
    order_item_id serial,
    quantity      int,
    order_id      int,
    product_id    int,
    constraint pk_OrderItems primary key (order_item_id),
    constraint fk1_OrderItems foreign key (order_id) references Orders (order_id),
    constraint fk2_OrderItems foreign key (product_id) references Products (product_id),
    constraint checkQuantity check ( quantity >= 1 )
);

ALTER TABLE Products
    ADD CONSTRAINT pk_Products PRIMARY KEY (product_id);
drop table OrderItems;
drop table Orders,Products,Customers;