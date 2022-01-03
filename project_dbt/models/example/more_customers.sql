-- Give this model an alias
{{ config(alias='my_customers', schema='test_schema') }}

select * from {{ ref('customers') }}
intersect
select * from {{ ref('customers') }}
