select
    customer_id as id_cliente,
    customer_name,
    email,
    location
from {{ ref('stg_clientes') }}