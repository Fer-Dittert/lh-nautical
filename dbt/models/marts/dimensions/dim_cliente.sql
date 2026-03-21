select
    customer_id,
    customer_name,
    email,
    location
from {{ ref('stg_clientes') }}