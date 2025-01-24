with
/* Chamada dos modelos necessários. */
product as (select * from {{ ref('stg_erp__product') }})
, productcategory as ( select * from {{ ref('stg_erp__productcategory') }})
, productsubcategory as (select * from {{ ref('stg_erp__productsubcategory') }}),

final_product as (
    select
         product.pk_product
        , product.name_product
        , productcategory.name_productcategory
        , productsubcategory.name_productsubcategory

from product

    left join productsubcategory on product.fk_productsubcategory = productsubcategory.pk_productsubcategory
    left join productcategory on productsubcategory.fk_productcategory = productcategory.pk_productcategory -- Join correto
)

select * from final_product
