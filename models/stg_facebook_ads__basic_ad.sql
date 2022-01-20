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
        {{ fivetran_utils.source_relation(
            union_schema_variable='facebook_ads_union_schemas',
            union_database_variable='facebook_ads_union_databases') 
        }}
    from base
),

final as (
    select 
        ad_id,
        date as date_day,
        account_id,
        impressions,
        inline_link_clicks as clicks,
        spend
    from fields
)

select * from final
