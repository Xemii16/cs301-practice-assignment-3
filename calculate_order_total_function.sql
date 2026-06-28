create or replace function calculate_order_total(p_order_id int)
    returns numeric
as
$$
select coalesce(sum(order_items_with_total_price.total_order_price), 0)
from (select order_items.quantity * order_items.price as total_order_price
      from order_items
      where order_items.order_id = p_order_id) as order_items_with_total_price;
$$ language sql;

select calculate_order_total(1);  -- expect 1250
select calculate_order_total(998) -- expect 0