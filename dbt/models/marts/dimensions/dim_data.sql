with limites as (

    select
        min(sale_date) as data_minima,
        max(sale_date) as data_maxima
    from {{ ref('stg_vendas') }}

),

calendario as (

    select
        explode(
            sequence(
                (select data_minima from limites),
                (select data_maxima from limites),
                interval 1 day
            )
        ) as data_dia

)

select
    data_dia,
    year(data_dia) as ano,
    quarter(data_dia) as trimestre,
    month(data_dia) as mes,
    day(data_dia) as dia,
    dayofweek(data_dia) as numero_dia_semana,

    case dayofweek(data_dia)
        when 1 then 'Domingo'
        when 2 then 'Segunda-feira'
        when 3 then 'Terça-feira'
        when 4 then 'Quarta-feira'
        when 5 then 'Quinta-feira'
        when 6 then 'Sexta-feira'
        when 7 then 'Sábado'
    end as dia_semana

from calendario