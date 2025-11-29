CREATE DATABASE  LibraryDB;

CREATE SCHEMA if not exists  library;

set search_path  to library;

CREATE  table  if not exists Books(
    book_id serial,
    title varchar(100) not null ,
    author varchar(100) not null,
    published_year int,
    available boolean,
    constraint pk_Books primary key (book_id)
);

CREATE  table  if not exists Members(
    member_id serial,
    name varchar(100) not null ,
    email text not null  unique,
    join_date date default now(),
    constraint pk_Members primary key (member_id)
);