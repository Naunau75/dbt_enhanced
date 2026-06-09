with source as (
    select * from {{ ref('raw_payments') }}
),

final as (
    select
        id as payment_id,
        order_id,
        payment_method,
        {{ cents_to_euros('amount') }} as amount_in_euros,
        case 
            when amount > 0 then true 
            else false 
        end as is_successful
    from source
)

select * from final
