{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        source_relation,
        _fivetran_id,
        _fivetran_synced,
        creative_id,
        account_id,
        creative_name,
        page_link,
        template_page_link,
        url_tags,
        asset_feed_spec_link_urls,
        object_story_link_data_child_attachments,
        object_story_link_data_caption,
        object_story_link_data_description,
        object_story_link_data_link,
        object_story_link_data_message,
        template_app_link_spec_ios,
        template_app_link_spec_ipad,
        template_app_link_spec_android,
        template_app_link_spec_iphone

    from {{ target.schema }}_facebook_ads_source_prod.stg_facebook_ads__creative_history
    where is_most_recent_record
),

dev as (
    select
        source_relation,
        _fivetran_id,
        _fivetran_synced,
        creative_id,
        account_id,
        creative_name,
        page_link,
        template_page_link,
        url_tags,
        asset_feed_spec_link_urls,
        object_story_link_data_child_attachments,
        object_story_link_data_caption,
        object_story_link_data_description,
        object_story_link_data_link,
        object_story_link_data_message,
        template_app_link_spec_ios,
        template_app_link_spec_ipad,
        template_app_link_spec_android,
        template_app_link_spec_iphone

    from {{ target.schema }}_facebook_ads_source_dev.stg_facebook_ads__creative_history
    where is_most_recent_record 
),

final as (
    select 
        dev.source_relation as dev_source_relation,
        prod.source_relation as prod_source_relation,
        dev._fivetran_id as dev__fivetran_id,
        prod._fivetran_id as prod__fivetran_id,
        dev._fivetran_synced as dev__fivetran_synced,
        prod._fivetran_synced as prod__fivetran_synced,
        dev.creative_id as dev_creative_id,
        prod.creative_id as prod_creative_id,
        dev.account_id as dev_account_id,
        prod.account_id as prod_account_id,
        dev.creative_name as dev_creative_name,
        prod.creative_name as prod_creative_name,
        dev.page_link as dev_page_link,
        prod.page_link as prod_page_link,
        dev.template_page_link as dev_template_page_link,
        prod.template_page_link as prod_template_page_link,
        dev.url_tags as dev_url_tags,
        prod.url_tags as prod_url_tags,
        dev.asset_feed_spec_link_urls as dev_asset_feed_spec_link_urls,
        prod.asset_feed_spec_link_urls as prod_asset_feed_spec_link_urls,
        dev.object_story_link_data_child_attachments as dev_object_story_link_data_child_attachments,
        prod.object_story_link_data_child_attachments as prod_object_story_link_data_child_attachments,
        dev.object_story_link_data_caption as dev_object_story_link_data_caption,
        prod.object_story_link_data_caption as prod_object_story_link_data_caption,
        dev.object_story_link_data_description as dev_object_story_link_data_description,
        prod.object_story_link_data_description as prod_object_story_link_data_description,
        dev.object_story_link_data_link as dev_object_story_link_data_link,
        prod.object_story_link_data_link as prod_object_story_link_data_link,
        dev.object_story_link_data_message as dev_object_story_link_data_message,
        prod.object_story_link_data_message as prod_object_story_link_data_message,
        dev.template_app_link_spec_ios as dev_template_app_link_spec_ios,
        prod.template_app_link_spec_ios as prod_template_app_link_spec_ios,
        dev.template_app_link_spec_ipad as dev_template_app_link_spec_ipad,
        prod.template_app_link_spec_ipad as prod_template_app_link_spec_ipad,
        dev.template_app_link_spec_android as dev_template_app_link_spec_android,
        prod.template_app_link_spec_android as prod_template_app_link_spec_android,
        dev.template_app_link_spec_iphone as dev_template_app_link_spec_iphone,
        prod.template_app_link_spec_iphone as prod_template_app_link_spec_iphone

    from prod
    full outer join dev 
        on dev._fivetran_id = prod._fivetran_id
)

select *
from final
where
    prod_source_relation != dev_source_relation
    or prod__fivetran_id != dev__fivetran_id
    or prod__fivetran_synced != dev__fivetran_synced
    or prod_creative_id != dev_creative_id
    or prod_account_id != dev_account_id
    or prod_creative_name != dev_creative_name
    or prod_page_link != dev_page_link
    or prod_template_page_link != dev_template_page_link
    or prod_url_tags != dev_url_tags
    or prod_asset_feed_spec_link_urls != dev_asset_feed_spec_link_urls
    or prod_object_story_link_data_child_attachments != dev_object_story_link_data_child_attachments
    or prod_object_story_link_data_caption != dev_object_story_link_data_caption
    or prod_object_story_link_data_description != dev_object_story_link_data_description
    or prod_object_story_link_data_link != dev_object_story_link_data_link
    or prod_object_story_link_data_message != dev_object_story_link_data_message
    or prod_template_app_link_spec_ios != dev_template_app_link_spec_ios
    or prod_template_app_link_spec_ipad != dev_template_app_link_spec_ipad
    or prod_template_app_link_spec_android != dev_template_app_link_spec_android
    or prod_template_app_link_spec_iphone != dev_template_app_link_spec_iphone