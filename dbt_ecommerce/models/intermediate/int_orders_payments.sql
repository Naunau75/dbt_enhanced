with payments as (
    select * from {{ ref('stg_payments') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

aggregated_payments as (
    select
        order_id,
        sum(amount_in_euros) as total_amount_in_euros
    from payments
    group by 1
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status,
        coalesce(p.total_amount_in_euros, 0) as total_amount_in_euros
    from orders o
    left join aggregated_payments p on o.order_id = p.order_id
)

select * from final
