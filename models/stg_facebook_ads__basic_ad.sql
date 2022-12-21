{{ config(enabled=var('ad_reporting__facebook_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_facebook_ads__basic_ad_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__basic_ad_tmp')),
                staging_columns=get_basic_ad_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        cast(ad_id as {{ dbt.type_bigint() }}) as ad_id,
        ad_name,
        adset_name as ad_set_name,
        date as date_day,
        cast(account_id as {{ dbt.type_bigint() }}) as account_id,
        impressions,
        coalesce(inline_link_clicks,0) as clicks,
        spend,
        reach,
        frequency

        {{ fivetran_utils.fill_pass_through_columns('facebook_ads__basic_ad_passthrough_metrics') }}
    from fields
)

select * 
from final
