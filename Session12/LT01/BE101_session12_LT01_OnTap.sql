create database session12;
create schema if not exists lt1;

set search_path to lt1;

drop table custormes, custorme_log;

create table custormes
(
    customer_id serial primary key,
    name        varchar(50),
    email       varchar(50)
);

create table custorme_log
(
    log_id        serial primary key,
    customer_name varchar(50),
    action_time   timestamp default current_timestamp
);

insert into custormes(name, email)
values ('ABC','ac@gmail.com'),
       ('DEF','df@gmail.com');


create or replace function add_log()
returns trigger
as $$
begin
    insert into custorme_log(customer_name)
    values (new.name);
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_log
after insert on custormes
for each row
execute function add_log();

insert into custormes(name, email) values ('GHI','gi@gmail.com');
