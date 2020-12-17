{% set url_field = "coalesce(page_link,template_page_link)" %}

with base as (

    select * 
    from {{ ref('stg_facebook_ads__creative_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_ads__creative_history_tmp')),
                staging_columns=get_creative_history_columns()
            )
        }}
        
    from base
),

fields_xf as (
    
    select 
        id as creative_id,
        account_id,
        name as creative_name,
        {{ url_field }} as url,
        {{ dbt_utils.split_part(url_field, "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host(url_field) }} as url_host,
        '/' || {{ dbt_utils.get_url_path(url_field) }} as url_path,
        {{ dbt_utils.get_url_parameter(url_field, 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter(url_field, 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter(url_field, 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter(url_field, 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter(url_field, 'utm_term') }} as utm_term,
        url_tags,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from fields
),

filtered as (

    select *
    from fields_xf
    where is_most_recent_record = True

)

select * from filtered
