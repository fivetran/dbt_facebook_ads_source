
with base as (

    select * 
    from {{ ref('stg_facebook_ads__basic_ad_actions_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__basic_ad_actions_tmp')),
                staging_columns=get_basic_ad_actions_columns()
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
        source_relation, 
        action_type,
        cast(ad_id as {{ dbt.type_bigint() }}) as ad_id,
        date as date_day,
        coalesce(value, 0) as value,
        coalesce(inline, 0) as value_inline,
        coalesce(_1_d_view, 0) as value_1d_view,
        coalesce(_28_d_click, 0) as value_28d_click

        {# _fivetran_id, #}
        {# _fivetran_synced, #}
    from fields
)

select *
from final
