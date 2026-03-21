select
    cast(sale_id as int) as sale_id,
    cast(customer_id as int) as customer_id,
    cast(product_id as int) as product_id,
    cast(quantity as int) as quantity,
    cast(total_amount as decimal(18,2)) as total_amount,
    cast(sale_date as date) as sale_date
from lh_nautical.02_bronze.vendas_bronze
where sale_id is not null
  and customer_id is not null
  and product_id is not null
  and quantity > 0
  and total_amount >= 0
  and sale_date is not null