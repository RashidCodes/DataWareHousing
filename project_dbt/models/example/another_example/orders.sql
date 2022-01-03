{{ config (
      materialized="view",
      schema="test_schema"
)  }}

with staff_orders as (
    select staff_id,  min(order_date) as first_order_date, 
    max(order_date) as recent_order_date, 
    count(order_id) as num_of_orders
    from public.orders 
    group by staff_id
)
select 
   so.staff_id, s.first_name, s.last_name, 
   so.first_order_date, so.recent_order_date,
   so.num_of_orders
from staff_orders as so
left join {{ source('public', 'staffs') }} as s
  on so.staff_id = s.staff_id

