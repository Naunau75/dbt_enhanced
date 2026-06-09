with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('int_orders_payments') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(total_amount_in_euros) as total_amount_spent
    from orders
    group by 1
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        coalesce(co.number_of_orders, 0) as number_of_orders,
        coalesce(co.total_amount_spent, 0) as total_amount_spent,
        co.first_order_date,
        co.most_recent_order_date
    from customers c
    left join customer_orders co on c.customer_id = co.customer_id
)

select * from final
