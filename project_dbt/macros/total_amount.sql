{% macro total_amount(list_price, discount, precision=2) %}
  ({{ list_price }} * {{ discount }})::numeric(16, {{ precision }})
{% endmacro %}
