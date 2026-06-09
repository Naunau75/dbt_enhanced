{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with orders as (
    select * from {{ ref('int_orders_payments') }}
),

final as (
    select
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount_in_euros
    from orders

    {% if is_incremental() %}
      where order_date > (select max(order_date) from {{ this }})
    {% endif %}
)

select * from final
