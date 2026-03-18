select
    cast(product_id as int) as product_id,
    trim(product_name) as product_name,
    trim(lower(category)) as category,
    cast(start_date as date) as start_date,
    cast(usd_price as decimal(18,2)) as usd_price
from lh_nautical.02_bronze.custos_importacao_bronze
where product_id is not null
  and product_name is not null
  and category is not null
  and start_date is not null
  and usd_price > 0