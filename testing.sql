create table customers
(
    customer_id serial primary key,
    full_name   varchar(100)        not null,
    email       varchar(100) unique not null,
    balance     numeric(10, 2) default 0
);

create table products
(
    product_id     serial primary key,
    product_name   varchar(100)   not null,
    price          numeric(10, 2) not null,
    stock_quantity int            not null
);

create table orders
(
    order_id     serial primary key,
    customer_id  int references customers (customer_id),
    order_date   timestamp      default current_timestamp,
    total_amount numeric(10, 2) default 0
);

create table order_items
(
    order_item_id serial primary key,
    order_id      int references orders (order_id),
    product_id    int references products (product_id),
    quantity      int            not null,
    price         numeric(10, 2) not null
);

create table order_log
(
    log_id      serial primary key,
    order_id    int,
    customer_id int,
    action      varchar(50),
    log_date    timestamp default current_timestamp
);

-- customers can be created;
insert into customers
values (default, 'Maksym Balamut', 'bebe@gmail.com', 4530534);
-- products can be created;
insert into products
values (default, 'Iphone 5s', 422, 53);

-- orders can be created using the procedure;
call create_order((select customer_id
                   from customers
                   where full_name = 'Maksym Balamut'));

-- products can be added to orders using the procedure;
call add_product_to_order((select orders.order_id
                           from orders
                           where customer_id = (select customer_id from customers where full_name = 'Maksym Balamut')),
                          (select products.product_id
                           from products
                           where product_name = 'Iphone 5s'), 2);

-- order totals are updated automatically;
select orders.total_amount from orders where order_id = (select orders.order_id
                           from orders
                           where customer_id = (select customer_id from customers where full_name = 'Maksym Balamut'));

-- product stock decreases correctly; (expected 51)
select products.stock_quantity from products where product_name = 'Iphone 5s';

-- order creation is logged in order_log.
select * from order_log;
