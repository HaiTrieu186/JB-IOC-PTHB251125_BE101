create database session11;

create schema if not exists bt2;
set search_path to bt2;

create table accounts
(
    account_id serial primary key,
    owner_name varchar(100),
    balance    numeric(10, 2)
);


insert into accounts(owner_name, balance)
values ('A', 500.00),
       ('B', 300.00);


begin;
update accounts
set balance=balance - 100.00
where account_id = 1;

update accounts
set balance=balance + 100.00
where account_id = 2;
commit;
end;


--- LỖI --> rollback
begin;
update accounts
set balance=balance - 100.00
where account_id = 3;

update accounts
set balance=balance + 100.00
where account_id = 2;
rollback;
end;
