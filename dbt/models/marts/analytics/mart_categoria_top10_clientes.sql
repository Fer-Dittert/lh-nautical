with top_10 as (

    select
        customer_id
    from {{ ref('mart_clientes_fieis') }}

),

base as (

    select
        f.customer_id,
        f.quantity,
        p.category
    from {{ ref('fct_vendas') }} f
    left join {{ ref('dim_produto') }} p
        on f.product_id = p.product_id
    inner join top_10 t
        on f.customer_id = t.customer_id

),

categoria_agregada as (

    select
        category,
        sum(quantity) as quantidade_total_itens
    from base
    group by category

)

select *
from categoria_agregada
order by quantidade_total_itens desc, category asc