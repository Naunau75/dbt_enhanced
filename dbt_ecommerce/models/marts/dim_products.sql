with products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        product_id,
        name,
        category,
        price_in_euros
    from products
)

select * from final
