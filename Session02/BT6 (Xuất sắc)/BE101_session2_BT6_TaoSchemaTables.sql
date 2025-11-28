create schema if not exists shop;

set search_path to shop;

create table if not exists Users
(
    user_id  serial,
    username varchar(50) unique not null,
    email    varchar(100)       not null unique,
    password varchar(100)       not null,
    role     varchar(20)        not null default 'Customer',
    constraint pk_Users primary key (user_id),
    constraint check_role CHECK (role IN ('Customer', 'Admin'))
);

create table if not exists Categories
(
    category_id   serial,
    category_name varchar(100) not null unique,
    constraint pk_Categories primary key (category_id)
);

create table if not exists Products
(
    product_id   serial,
    product_name varchar(100) not null,
    price        numeric(10, 2),
    stock        int,
    category_id  int,
    constraint pk_Products primary key (product_id),
    constraint fk_Products foreign key (category_id) references Categories (category_id),
    constraint check_price CHECK (price > 0),
    constraint check_stock CHECK ( stock >= 0)
);

create table if not exists Orders
(
    order_id   serial,
    order_date date not null,
    status     varchar(20) default 'Pending',
    user_id    int,
    constraint pk_Orders primary key (order_id),
    constraint fk_Orders foreign key (user_id) references Users (user_id),
    constraint check_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

create table if not exists OrderDetails
(
    order_detail_id serial,
    quantity        int,
    price_each      numeric(10, 2),
    order_id        int,
    product_id      int,
    constraint pk_OrderDetails primary key (order_detail_id),
    constraint fk1_OrderDetails foreign key (order_id) references Orders (order_id),
    constraint fk2_OrderDetails foreign key (product_id) references Products (product_id),
    constraint check_quantity CHECK (quantity > 0),
    constraint check_price_each check (price_each > 0)
);

create table if not exists Payments
(
    payment_id   serial,
    amount       numeric(10, 2),
    payment_date date not null,
    method       varchar(30) default 'Credit Card',
    order_id     int,
    constraint pk_Payments primary key (payment_id),
    constraint fk_Payments foreign key (order_id) references Orders (order_id),
    constraint check_amount CHECK (amount >= 0),
    constraint check_method CHECK (method IN ('Credit Card', 'Momo', 'Bank Transfer', 'Cash'))
);
