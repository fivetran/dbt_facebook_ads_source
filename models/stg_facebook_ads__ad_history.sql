with base as (

    select *
    from {{ source('facebook_ads','ad_history') }}

), fields as (

    select 
        id as ad_id,
        updated_time as updated_at,
        name as ad_name,
        account_id,
        ad_set_id,
        campaign_id,
        created_time as created_at
    from base

)

select *
from fields