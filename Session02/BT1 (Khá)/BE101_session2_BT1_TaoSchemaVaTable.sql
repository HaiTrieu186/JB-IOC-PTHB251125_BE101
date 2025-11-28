CREATE SCHEMA if not exists library;

set search_path  to library;

CREATE table if not exists Books(
    book_id serial,
    title varchar(100) not null ,
    author varchar(50) not null ,
    published_year int,
    price numeric(10,2),
    constraint pk primary key (book_id)
);