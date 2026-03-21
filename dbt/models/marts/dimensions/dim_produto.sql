select
    product_id,
    product_name,
    product_price,
    category,
    actual_category
from {{ ref('stg_produtos') }}