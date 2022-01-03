{{ config(schema="test_schema", materialize="view") }}

select *
from {{ source('public', 'order_items') }}
where order_id IN (1, 2, 3)
