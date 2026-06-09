with source as (
    select * from {{ ref('raw_products') }}
),

final as (
    select
        id as product_id,
        name,
        category,
        {{ cents_to_euros('price') }} as price_in_euros
    from source
)

select * from final
