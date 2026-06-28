create or replace function update_order_total_function()
    returns trigger as
$$
begin
    if tg_op = 'INSERT' or tg_op = 'UPDATE' then
        raise notice 'INSERT or UPDATE is working on order_id %', new.order_id;
        update orders
        set total_amount = calculate_order_total(new.order_id)
        where order_id = new.order_id;
        return new;
    elsif tg_op = 'DELETE' then
        raise notice 'DELETE is working on order_id %', old.order_id;
        update orders
        set total_amount = calculate_order_total(old.order_id)
        where order_id = old.order_id;
        return old;
    end if;
    raise notice 'Nothing is working';
    return null;
end;
$$ language plpgsql;


create or replace trigger update_order_total
    before update or insert or delete
    on order_items
    for each row
execute function update_order_total_function();