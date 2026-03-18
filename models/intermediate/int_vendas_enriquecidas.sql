with vendas as (

    select
        sale_id,
        customer_id,
        product_id,
        quantity,
        total_amount,
        sale_date
    from {{ ref('stg_vendas') }}

),

custos as (

    select
        product_id,
        start_date,
        usd_price
    from {{ ref('stg_custos_importacao') }}

),

cambio as (

    select
        exchange_date,
        exchange_rate
    from {{ ref('stg_cambio') }}

),

custos_validos as (

    select
        v.sale_id,
        v.customer_id,
        v.product_id,
        v.quantity,
        v.total_amount,
        v.sale_date,
        c.start_date as cost_start_date,
        c.usd_price,

        row_number() over (
            partition by v.sale_id
            order by c.start_date desc
        ) as rn_cost

    from vendas v
    left join custos c
        on v.product_id = c.product_id
       and c.start_date <= v.sale_date

),

custos_filtrados as (

    select
        sale_id,
        customer_id,
        product_id,
        quantity,
        total_amount,
        sale_date,
        cost_start_date,
        usd_price
    from custos_validos
    where rn_cost = 1

),

cambio_valido as (

    select
        cf.sale_id,
        cb.exchange_date,
        cb.exchange_rate,

        row_number() over (
            partition by cf.sale_id
            order by cb.exchange_date desc
        ) as rn_exchange

    from custos_filtrados cf
    left join cambio cb
        on cb.exchange_date <= cf.sale_date

),

cambio_filtrado as (

    select
        sale_id,
        exchange_date,
        exchange_rate
    from cambio_valido
    where rn_exchange = 1

),

final as (

    select
        cf.sale_id,
        cf.customer_id,
        cf.product_id,
        cf.quantity,
        cf.sale_date,
        cf.total_amount as receita_transacao_brl,

        cf.cost_start_date,
        cf.usd_price,
        cfx.exchange_date as exchange_rate_date,
        cfx.exchange_rate,

        -- custo unitário convertido para BRL
        (cf.usd_price * cfx.exchange_rate) as custo_unitario_brl,

        -- custo total da transação em BRL
        (cf.usd_price * cfx.exchange_rate * cf.quantity) as custo_total_brl,

        case
            when (cf.usd_price * cfx.exchange_rate * cf.quantity) > cf.total_amount
                then (cf.usd_price * cfx.exchange_rate * cf.quantity) - cf.total_amount
            else 0
        end as prejuizo_brl,

        case
            when (cf.usd_price * cfx.exchange_rate * cf.quantity) > cf.total_amount
                then true
            else false
        end as teve_prejuizo

    from custos_filtrados cf
    left join cambio_filtrado cfx
        on cf.sale_id = cfx.sale_id

)

select *
from final