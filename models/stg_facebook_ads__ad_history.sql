
with base as (

    select * 
    from {{ ref('stg_facebook_ads__ad_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__ad_history_tmp')),
                staging_columns=get_ad_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        updated_time,
        id as ad_id,
        name as ad_name,
        account_id,
        ad_set_id,
        campaign_id,
        creative_id,
        row_number() over (partition by id order by updated_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final
