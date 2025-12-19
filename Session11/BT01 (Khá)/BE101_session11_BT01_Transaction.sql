create database session11;

create schema if not exists bt1;
set search_path to bt1;

create table flights (
    flight_id serial primary key ,
    flight_name varchar(100),
    availabale_seats int
);

create table bookings (
    booking_id serial primary key ,
    flight_id int references flights(flight_id),
    customer_name varchar(100)
);

insert into flights(flight_name, availabale_seats) values
('VN123', 3), ('VN456',2);


begin
    update flights
    set availabale_seats= availabale_seats-1
    where flight_id=1;

    insert into bookings(flight_id, customer_name) values
        (1, 'Nguyễn Văn A');

    commit;
end;


--- LỖI --> rollback
begin
update flights
set availabale_seats= availabale_seats-1
where flight_id=2;

insert into bookings(flight_id, customer_name) values
    (1, 'Nguyễn Văn A');

rollback;

commit;
end;
