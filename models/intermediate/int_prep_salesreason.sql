with
    salesorderheadersalesreason as (select * from {{ ref('stg_erp__salesorderheadersalesreason') }})

    , salesreason as (select * from {{ ref('stg_erp__salesreason') }}),

    -- subquery para identificar os motivos "Promotion" para cada pedido, para priorizar este tipo de motivo, pois um mesmo pedido pode ter mais de um motivo de venda.
    promotion_reasons as (
        select
            pk_salesorder,
            fk_salesreason
        from salesorderheadersalesreason
        where fk_salesreason in (select pk_salesreason from salesreason where type_salesreason = 'Promotion') -- Filtra fk_salesreason que estão na tabela salesreason e type_salesreason for promotion
    ),

    -- subquery para identificar outros motivos (Marketing e Others) para pedidos que não possuem motivos "Promotion"
    other_reasons as (
        select
            pk_salesorder,
            fk_salesreason
        from salesorderheadersalesreason
        where pk_salesorder not in (select pk_salesorder from promotion_reasons)
    ),

    -- combina os resultados, dando prioridade aos motivos "Promotion"
    prioritized_reasons as (
        select * from promotion_reasons
        union all
        select * from other_reasons
    )

    ,enriched_salesreason as (
        select
            {{ dbt_utils.generate_surrogate_key(['prioritized_reasons.pk_salesorder', 'salesreason.pk_salesreason']) }} as sk_salesreason,
            prioritized_reasons.pk_salesorder,
            prioritized_reasons.fk_salesreason,
            salesreason.name_salesreason,
            salesreason.type_salesreason

        from prioritized_reasons
        left join salesreason on prioritized_reasons.fk_salesreason = salesreason.pk_salesreason
    )

select * from enriched_salesreason
    