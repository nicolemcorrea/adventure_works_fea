with
    salesorderheadersalesreason as (select * from {{ ref('stg_erp__salesorderheadersalesreason') }})
    , salesreason as (select * from {{ ref('stg_erp__salesreason') }})

    , enriched_salesreason as (
        select
            {{dbt_utils.generate_surrogate_key(['salesorderheadersalesreason.pk_salesorder', 'salesreason.pk_salesreason']) }} as sk_salesreason
            , salesorderheadersalesreason.pk_salesorder
            , salesorderheadersalesreason.fk_salesreason
            , salesreason.name_salesreason
            , salesreason.type_salesreason

        from salesorderheadersalesreason
        left join salesreason on salesorderheadersalesreason.fk_salesreason = salesreason.pk_salesreason
    )

select * from enriched_salesreason
    