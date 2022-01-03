{% snapshot orders_snapshot %}

{{
      config(
          target_database='bikestores',
          target_schema='snapshots',
          unique_key='_airbyte_order_items_hashid',
          strategy='timestamp',
          updated_at='updated_at'
      )

}}
select * from {{ source('public', 'order_items') }}

{% endsnapshot %}
