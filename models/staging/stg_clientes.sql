select
    cast(customer_id as int) as customer_id,
    lower(trim(email)) as email,
    trim(customer_name) as customer_name,
    trim(location) as location
from lh_nautical.02_bronze.clientes_bronze
where customer_id is not null
  and email is not null
  and customer_name is not null
  and location is not null