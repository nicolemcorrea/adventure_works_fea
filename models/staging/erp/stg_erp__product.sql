with 
    src_product as (
    select
        cast( PRODUCTID as int) as pk_product
        , cast(PRODUCTSUBCATEGORYID as int) as fk_productsubcategory
        , cast(NAME as string) as name_product
        --, PRODUCTNUMBER
        --, MAKEFLAG
        --, FINISHEDGOODSFLAG
        --, COLOR
        --, SAFETYSTOCKLEVEL
        --, REORDERPOINT
        --, STANDARDCOST
        --, LISTPRICE
        --, SIZE
        --, SIZEUNITMEASURECODE
        --, WEIGHTUNITMEASURECODE
        --, WEIGHT
        --, DAYSTOMANUFACTURE
        --, PRODUCTLINE
        --, CLASS
        --, STYLE
        --, PRODUCTMODELID
        --, SELLSTARTDATE
        --, SELLENDDATE
        --, DISCONTINUEDDATE
        --, ROWGUID
        --, MODIFIEDDATE
        
    from {{ source('erp_adventure_works', 'product') }}
)

select *
from src_product