
with base as (

    select * 
    from {{ ref('stg_facebook_ads__ad_set_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__ad_set_history_tmp')),
                staging_columns=get_ad_set_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        updated_time,
        id as ad_set_id,
        name as ad_set_name,
        account_id,
        campaign_id,
        start_time,
        end_time,
        bid_strategy,
        daily_budget,
        budget_remaining,
        status,
        row_number() over (partition by id order by updated_time desc) = 1 as is_most_recent_record
    from fields

)

select * 
from final
