
select order_id, item_id,
  sum(list_price) OVER(PARTITION BY order_id
                       ORDER BY order_id, item_id
                       ROWS UNBOUNDED PRECEDING) as list_price_groups
from public.order_items
