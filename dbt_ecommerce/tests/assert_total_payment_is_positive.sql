select
    order_id,
    sum(amount_in_euros) as total_amount
from {{ ref('stg_payments') }}
group by 1
having not(sum(amount_in_euros) >= 0)
