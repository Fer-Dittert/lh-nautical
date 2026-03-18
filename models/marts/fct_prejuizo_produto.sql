select
    product_id as id_produto,
    sum(receita_transacao_brl) as receita_total_brl,
    sum(prejuizo_brl) as prejuizo_total_brl,
    case
        when sum(receita_transacao_brl) = 0 then 0
        else sum(prejuizo_brl) / sum(receita_transacao_brl)
    end as percentual_perda
from {{ ref('int_vendas_enriquecidas') }}
group by product_id