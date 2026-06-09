with source as (
    select * from {{ ref('raw_customers') }}
),

final as (
    select
        id as customer_id,
        first_name,
        last_name,
        email
    from source
)

select * from final
