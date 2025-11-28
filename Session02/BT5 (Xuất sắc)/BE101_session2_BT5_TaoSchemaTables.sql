create schema if not EXISTS hotel;

set search_path to hotel;

create table if not exists RoomTypes
(
    room_type_id    serial,
    type_name       varchar(50) not null unique,
    price_per_night numeric(10, 2),
    max_capacity    int,
    constraint pk_RoomTypes primary key (room_type_id),
    constraint check_price_per_night CHECK (price_per_night > 0),
    constraint check_max_capacity CHECK (max_capacity > 0)
);

create table if not exists Rooms
(
    room_id      serial,
    room_number  varchar(10) not null unique,
    status       varchar(20) DEFAULT 'Available',
    room_type_id int,
    constraint pk_Rooms primary key (room_id),
    constraint fk_Rooms foreign key (room_type_id) references RoomTypes (room_type_id),
    constraint check_status CHECK (status IN ('Available', 'Occupied', 'Maintenance'))
);

create table if not exists Customers
(
    customer_id serial,
    full_name   varchar(100) not null,
    email       varchar(100) not null unique,
    phone       varchar(15)  not null,
    constraint pk_Customers primary key (customer_id)
);

create table if not exists Bookings
(
    booking_id  serial,
    check_in    date not null,
    check_out   date not null,
    status      varchar(20) default 'Pending',
    customer_id int,
    room_id     int,
    constraint pk_Bookings primary key (booking_id),
    constraint fk1_Bookings foreign key (customer_id) references Customers (customer_id),
    constraint fk2_Bookings foreign key (room_id) references Rooms (room_id),
    constraint check_status CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
    constraint check_dates CHECK (check_out > check_in)
);

create table if not exists Payments
(
    payment_id   serial,
    amount       numeric(10, 2) not null,
    payment_date date           not null,
    method       varchar(20),
    booking_id   int,
    constraint pk_Payments primary key (payment_id),
    constraint fk_Payments foreign key (booking_id) references Bookings (booking_id),
    constraint check_amount CHECK (amount >= 0),
    constraint check_method CHECK (method IN ('Credit Card', 'Cash', 'Bank Transfer'))
);