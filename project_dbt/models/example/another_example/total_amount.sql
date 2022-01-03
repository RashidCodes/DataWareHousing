{{ config(materialize="view", schema="test_schema") }}

select 
  order_id, item_id, product_id, 
  {{ total_amount('list_price', 'discount') }} as total_amount
from {{ source('public', 'order_items') }} 

