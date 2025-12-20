create database session12;
create schema if not exists lt6;

set search_path to lt6;

drop table accounts;

CREATE TABLE if not exists accounts
(
    account_id   SERIAL PRIMARY KEY,
    account_name VARCHAR(50),
    balance      NUMERIC
);

INSERT INTO accounts (account_name, balance)
VALUES ('Nguyen Van A', 5000.00),
       ('Tran Thi B', 3000.00);


create or replace procedure check_trans(
    from_account int,
    to_account int,
    amount numeric(10, 2)
)
    language plpgsql
as
$$
begin
    if (select balance
        from accounts
        where accounts.account_id = from_account) < amount then
        rollback;
        raise exception 'Khong du so du trong tai khoan';
    end if;

    update accounts
    set balance = balance - amount
    where account_id = from_account;

    update accounts
    set balance = balance + amount
    where account_id = to_account;

    commit;
end;
$$;


call check_trans(1, 2, 1000.00);

call check_trans(1, 2, 111000.00);
