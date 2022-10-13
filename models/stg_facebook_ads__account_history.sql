{{ config(enabled=var('ad_reporting__facebook_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_facebook_ads__account_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__account_history_tmp')),
                staging_columns=get_account_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        cast(id as {{ dbt.type_bigint() }}) as account_id,
        _fivetran_synced,
        name as account_name,
        account_status,
        business_country_code,
        created_time as created_at,
        currency,
        timezone_name,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from fields

)

select * 
from final