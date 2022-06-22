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

valid_utm_fields as (

    select
        _fivetran_synced,
        id,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_valid_utm_record
    from fields 
    where url_tags not in ('{}','"[]"')
),

final as (
    
    select 
        fields._fivetran_id,
        fields.id as creative_id,
        fields.account_id,
        fields.name as creative_name,
        fields.page_link,
        fields.template_page_link,
        fields.url_tags,
        fields.asset_feed_spec_link_urls,
        fields.object_story_link_data_child_attachments,
        fields.object_story_link_data_caption, 
        fields.object_story_link_data_description, 
        fields.object_story_link_data_link, 
        fields.object_story_link_data_message,
        fields.template_app_link_spec_ios,
        fields.template_app_link_spec_ipad,
        fields.template_app_link_spec_android,
        fields.template_app_link_spec_iphone,
        valid_utm_fields.is_most_recent_valid_utm_record
    from fields
    left join valid_utm_fields 
        on fields.id = valid_utm_fields.id 
)

select * 
from final
