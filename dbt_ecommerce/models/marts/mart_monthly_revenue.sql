{{
    config(
        materialized='external',
        location='mart_monthly_revenue.csv'
    )
}}

with orders as (
    select * from {{ ref('fct_orders') }}
    where order_status = 'completed'
),

final as (
    select
        date_trunc('month', cast(order_date as date)) as order_month,
        sum(total_amount_in_euros)*2 as monthly_revenue
    from orders
    group by 1
)

select * from final
