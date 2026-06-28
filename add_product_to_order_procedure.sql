create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
as
$$
declare
    p_price     numeric;
    p_stock_quantity int;
    p_order_id_check int;
begin
    select products.stock_quantity into p_stock_quantity from products where product_id = p_product_id;
    select products.price into p_price from products where product_id = p_product_id;
    select orders.order_id into p_order_id_check from orders where order_id = p_order_id;
    if p_quantity > 0 and p_stock_quantity - p_quantity > 0 and p_order_id_check is not null
    then
        insert into order_items values (default, p_order_id, p_product_id, p_quantity, p_price);
        update products
        set stock_quantity = stock_quantity - p_quantity
        where product_id = p_product_id;
    end if;
end;
$$ language plpgsql;

call add_product_to_order(1, 4, 2); -- expect add to order_items and change the value of quantity in products
call add_product_to_order(1, 214, 2); -- expect add nothing
call add_product_to_order(1123, 4, 2); -- expect add nothing
call add_product_to_order(1123, 4, -1); -- expect add nothing