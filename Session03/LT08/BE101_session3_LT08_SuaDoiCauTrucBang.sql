
ALTER TABLE library.books ADD COLUMN  genre varchar(50);

ALTER TABLE library.books RENAME COLUMN available to is_available;

ALTER TABLE library.members DROP COLUMN email;

DROP TABLE  sales.orderdetails;