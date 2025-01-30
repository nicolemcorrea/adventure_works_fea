with
    salesorderheader as (
        select *
        from {{ ref('stg_erp__salesorderheader') }}
    ),

    salesorderdetail as (
        select *
        from {{ ref('stg_erp__salesorderdetail') }}
    ),
    
  join_sales as (
        select 
          salesorderheader.pk_salesorder
          , salesorderdetail.pk_salesorderdetail 
          , salesorderheader.fk_customer
          , salesorderheader.fk_address
          , salesorderheader.fk_creditcard
          , salesorderdetail.fk_product
          , salesorderheader.order_date
          , salesorderdetail.order_qty 
          , salesorderdetail.unit_price
          , salesorderheader.salesorder_subtotal
          , salesorderdetail.discount_price
          , salesorderheader.salesorder_tax
          , salesorderheader.salesorder_freight
          , salesorderheader.salesorder_totaldue
          , salesorderheader.online_orderflag

        from salesorderdetail
        inner join salesorderheader on salesorderdetail.fk_salesorder = salesorderheader.pk_salesorder
    ),

  sales_metrics as (
        select
        --foi feito um hash para a criação da surrogate key, pois pk_salesorder não é único e não há outra coluna que, combinada com ele, garanta a unicidade
          md5(cast(coalesce(cast(pk_salesorderdetail as TEXT), 'default_value') || '-' || coalesce(cast(pk_salesorder as TEXT), 'default_value') as TEXT)) as sk_salesorder
          , pk_salesorder
          , fk_customer
          , fk_address
          , fk_creditcard
          , fk_product
          , order_date
          , order_qty
          , unit_price
          , unit_price * order_qty as gross_price -- Calcula o preço total antes de qualquer desconto
          , cast(unit_price * (1- discount_price) * order_qty as numeric(18,2)) as net_price -- Preço líquido, ou seja, o valor total após aplicar o desconto
          ,  case
                when discount_price > 0 then true
                else false
            end as has_discount
          , cast(gross_price - net_price as numeric(18,2)) as discount_amount --Diferença de valor entre o preço bruto e o preço líquido
          , cast(discount_amount/order_qty as numeric(18,2)) as discount_unit_amount --Valor do desconto por unidade 
          , salesorder_subtotal
          , salesorder_tax
          , salesorder_freight,
            cast(salesorder_freight / count(*) over (partition by pk_salesorder) as numeric(18,2)) as prorated_freight --Valor do frete rateado 
          , salesorder_totaldue
          , case 
                when fk_creditcard is not null then 'Credit Card'
                else 'Other' 
            end as payment
          ,  online_orderflag
        from join_sales
    )

select * from sales_metrics