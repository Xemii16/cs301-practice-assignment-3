create or replace procedure create_order(p_customer_id int)
as
$$
declare
    customer_id int;
begin
    select customers.customer_id into customer_id from customers where customers.customer_id = p_customer_id;
    if customer_id is not null
    then
        INSERT INTO orders VALUES (DEFAULT, p_customer_id, now(), 0);
    end if;
end;
$$ language plpgsql;

call create_order(3); -- expect insert the new order in orders
call create_order(998) -- expect nothing is inserted in orders