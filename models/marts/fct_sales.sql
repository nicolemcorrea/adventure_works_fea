with 
fct_sales as (
    select * from {{ ref('int_prep_salesmetrics') }}
),

dim_date as (
    select * from {{ ref('dim_date') }} 
)

select 
    fct_sales.sk_salesorder 
    , fct_sales.fk_salesorder
    , fct_sales.fk_customer
    , fct_sales.fk_address
    , fct_sales.fk_creditcard
    , fct_sales.fk_product
    , dim_date.sk_date as fk_date
    , fct_sales.order_date
    , fct_sales.order_qty
    , fct_sales.unit_price
    , fct_sales.gross_price
    , fct_sales.net_price
    , fct_sales.has_discount
    , fct_sales.discount_amount
    , fct_sales.discount_unit_amount
    , fct_sales.salesorder_subtotal
    , fct_sales.salesorder_tax
    , fct_sales.salesorder_freight
    , fct_sales.prorated_freight
    , fct_sales.salesorder_totaldue
    , fct_sales.payment
    , fct_sales.online_orderflag
from fct_sales
left join dim_date on fct_sales.order_date = dim_date.date_day