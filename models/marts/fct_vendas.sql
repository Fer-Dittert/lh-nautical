select
    sale_id,
    customer_id,
    product_id,
    sale_date,

    quantity,
    receita_transacao_brl,
    custo_unitario_brl,
    custo_total_brl,
    prejuizo_brl,
    teve_prejuizo,

    cost_start_date,
    exchange_rate_date,
    exchange_rate

from {{ ref('int_vendas_enriquecidas') }}