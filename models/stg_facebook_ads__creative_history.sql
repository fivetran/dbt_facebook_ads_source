{{ config(enabled=var('ad_reporting__facebook_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_facebook_ads__creative_history_tmp') }}
),

{%- set columns = adapter.get_columns_in_relation(ref('stg_facebook_ads__creative_history_tmp')) -%}
{%- set ns = namespace(url_tags_column_type='string') -%}

{% for column in columns %}
    {%- if column.name|lower == 'url_tags' and target.type == 'bigquery' -%}
        {%- set ns.url_tags_column_type = column.dtype|lower -%}
    {%- endif -%}
{%- endfor %}

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=columns,
                staging_columns=get_creative_history_columns()
            )
        }}
        
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='facebook_ads_union_schemas', 
            union_database_variable='facebook_ads_union_databases') 
        }}

    from base
),

{# {% set column_type_query -%}
    select 
        lower(data_type) as data_type
    from `{{ ref('stg_facebook_ads__creative_history_tmp').database }}`.`{{ ref('stg_facebook_ads__creative_history_tmp').schema }}`.INFORMATION_SCHEMA.COLUMNS
    where 
        lower(table_name) = '{{ ref("stg_facebook_ads__creative_history_tmp").name |lower }}'
        and lower(column_name) = 'url_tags'
{%- endset %}

{%- set url_tags_column_type = dbt_utils.get_single_value(column_type_query, default="'string'") if execute and flags.WHICH in ('run', 'build') and target.type == 'bigquery' else 'string' -%} #}

final as (

    select
        source_relation, 
        _fivetran_id,
        _fivetran_synced,
        cast(id as {{ dbt.type_bigint() }}) as creative_id,
        cast(account_id as {{ dbt.type_bigint() }}) as account_id,
        name as creative_name,
        page_link,
        template_page_link,
        {# {% if var('facebook_ads__json_enabled', false) and target.type == 'bigquery' -%} #} -- using variable
        {% if ns.url_tags_column_type == 'json' -%}
            TO_JSON_STRING(url_tags)
        {%- else -%}
            url_tags
        {%- endif %} as url_tags,
        asset_feed_spec_link_urls,
        object_story_link_data_child_attachments,
        object_story_link_data_caption, 
        object_story_link_data_description, 
        object_story_link_data_link, 
        object_story_link_data_message,
        template_app_link_spec_ios,
        template_app_link_spec_ipad,
        template_app_link_spec_android,
        template_app_link_spec_iphone,
        case when id is null and _fivetran_synced is null 
            then row_number() over (partition by source_relation order by source_relation)
        else row_number() over (partition by source_relation, id order by _fivetran_synced desc) end = 1 as is_most_recent_record
    from fields
)

select * 
from final
