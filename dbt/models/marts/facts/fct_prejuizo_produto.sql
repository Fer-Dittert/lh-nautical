select
    product_id as id_produto,

    -- Receita total do produto
    sum(receita_transacao_brl) as receita_total_brl,

    -- Prejuízo operacional:
    -- considera apenas os casos em que o custo total da venda foi maior que a receita
    sum(prejuizo_brl) as prejuizo_total_operacional_brl,

    -- Prejuízo de precificação:
    -- considera quanto deixou de ser ganho quando o preço vendido ficou abaixo
    -- do preço ideal (custo unitário com margem mínima de 20%)
    sum(
        case
            when (receita_transacao_brl / quantity) < (custo_unitario_brl * 1.20)
                then (
                    ((custo_unitario_brl * 1.20) - (receita_transacao_brl / quantity))
                    * quantity
                )
            else 0
        end
    ) as prejuizo_total_precificacao_brl,

    -- Percentual de perda operacional sobre a receita
    case
        when sum(receita_transacao_brl) = 0 then 0
        else sum(prejuizo_brl) / sum(receita_transacao_brl)
    end as percentual_perda_operacional,

    -- Percentual de perda de precificação sobre a receita
    case
        when sum(receita_transacao_brl) = 0 then 0
        else
            sum(
                case
                    when (receita_transacao_brl / quantity) < (custo_unitario_brl * 1.20)
                        then (
                            ((custo_unitario_brl * 1.20) - (receita_transacao_brl / quantity))
                            * quantity
                        )
                    else 0
                end
            ) / sum(receita_transacao_brl)
    end as percentual_perda_precificacao

from {{ ref('fct_vendas') }}
group by product_id