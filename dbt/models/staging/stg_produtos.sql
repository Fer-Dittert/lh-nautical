with base as (

    select
        cast(product_id as int) as product_id,
        trim(product_name) as product_name,
        cast(price as decimal(18,2)) as product_price,
        trim(actual_category) as actual_category,
        trim(lower(category)) as category
    from lh_nautical.02_bronze.produtos_bronze
    where product_id is not null
      and product_name is not null
      and price is not null
      and category is not null

),

deduplicado as (

    select
        product_id,
        product_name,
        product_price,
        actual_category,
        category,
        row_number() over (
            partition by product_id
            order by
                case when category is not null then 1 else 2 end,
                case when product_price is not null then 1 else 2 end,
                product_name
        ) as rn
    from base

)

select
    product_id,
    product_name,
    product_price,
    actual_category,
    category
from deduplicado
where rn = 1