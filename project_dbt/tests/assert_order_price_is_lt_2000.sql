-- This should return an empty set

select * 
from {{ ref('customers') }} 
where first_name = 'Debra'
   and last_name = 'Burks'


