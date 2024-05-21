
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
        lower(action_type) as action_type,
        cast(ad_id as {{ dbt.type_bigint() }}) as ad_id,
        date as date_day,
        cast(coalesce(value, 0) as {{ dbt.type_float() }}) as conversion_value
        {# 
            Adapted from fivetran_utils.fill_pass_through_columns() macro. 
            Ensures that downstream summations work if a connector schema is missing one of your facebook_ads__basic_ad_actions_passthrough_metrics
        #}
        {% if var('facebook_ads__basic_ad_actions_passthrough_metrics') %}
            {% for field in var('facebook_ads__basic_ad_actions_passthrough_metrics') %}
                {% if field.transform_sql %}
                    , coalesce(cast({{ field.transform_sql }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
                {% else %}
                    , coalesce(cast({{ field.alias if field.alias else field.name }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
                {% endif %}
            {% endfor %}
        {% endif %}

    from fields
)

select *
from final
