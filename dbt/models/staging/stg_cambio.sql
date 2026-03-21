select
    cast(exchange_date as date) as exchange_date,
    cast(exchange_rate as decimal(18,6)) as exchange_rate
from lh_nautical.02_bronze.cambio_bronze
where exchange_date is not null
  and exchange_rate is not null
  and exchange_rate > 0