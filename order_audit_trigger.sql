create or replace function write_order_log()
    returns trigger as
$$
begin
    raise notice 'write_order_log is working';
    insert into order_log
    values (default, new.order_id, new.customer_id, 'created', now());
    return new;
end;
$$ language plpgsql;


create or replace trigger order_audit
    after insert
    on orders
    for each row
execute function write_order_log();