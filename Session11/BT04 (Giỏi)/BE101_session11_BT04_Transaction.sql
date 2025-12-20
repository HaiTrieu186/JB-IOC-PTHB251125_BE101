create database session11;

create schema if not exists bt4;
set search_path to bt4;

CREATE TABLE accounts
(
    account_id    SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    balance       NUMERIC(12, 2) CHECK (balance >= 0)
);

CREATE TABLE transactions
(
    trans_id   SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts (account_id),
    amount     NUMERIC(12, 2),
    trans_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO accounts (customer_name, balance)
VALUES ('Nguyen Van A', 5000.00),
       ('Tran Thi B', 1000.00),
       ('Le Van C', 200.00);


create or replace procedure withdraw_money(
    in_account_from int,
    in_amount decimal(12,2)
)
language plpgsql
as $$
begin
    -- Kiểm tra số dư
    if (select balance
        from accounts
        where account_id = in_account_from) < in_amount then
            raise exception 'Không đủ số tiền để rút';
    end if;

    -- Cập nhật số dư
    update accounts
    set balance=balance-in_amount
    where account_id=in_account_from;

    -- Ghi vào transactions
    insert into transactions(account_id, amount, trans_type)
    values (in_account_from, in_amount, 'WITHDRAW');



EXception
    WHEN OTHERS THEN
        ROLLBACK;
        raise exception 'Đã có lỗi: %', SQLERRM;
        RAISE;
end;
$$;

call withdraw_money(1, 1000.00);
call withdraw_money(1, 7000.00); -- Không đủ tiền
call withdraw_money(5, 1000.00); -- Sai người rút

