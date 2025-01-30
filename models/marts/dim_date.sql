with
    dim_date as (
        select
            {{ dbt_utils.generate_surrogate_key(['date_day', 'day_of_week_name']) }} as sk_date
            , *
        from {{ ref('int_prep_date') }}
    )

select *
from dim_date