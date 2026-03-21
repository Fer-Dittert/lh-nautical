with base as (

    select
        f.sale_id,
        f.customer_id,
        f.product_id,
        f.quantity,
        f.receita_transacao_brl,
        p.category
    from {{ ref('fct_vendas') }} f
    left join {{ ref('dim_produto') }} p
        on f.product_id = p.product_id

),

clientes_agregados as (

    select
        customer_id,

        sum(receita_transacao_brl) as faturamento_total,
        count(distinct sale_id) as frequencia,
        sum(receita_transacao_brl) / count(distinct sale_id) as ticket_medio,
        count(distinct category) as diversidade_categorias

    from base
    group by customer_id

),

clientes_elegiveis as (

    select *
    from clientes_agregados
    where diversidade_categorias >= 3

),

top_10 as (

    select *
    from clientes_elegiveis
    order by ticket_medio desc, customer_id asc
    limit 10

)

select *
from top_10