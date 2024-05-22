{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        source_relation,
        updated_at,
        ad_id,
        ad_name,
        account_id,
        ad_set_id,
        campaign_id,
        creative_id
    from {{ target.schema }}_facebook_ads_source_prod.stg_facebook_ads__ad_history
    where is_most_recent_record
),

dev as (
    select
        source_relation,
        updated_at,
        ad_id,
        ad_name,
        account_id,
        ad_set_id,
        campaign_id,
        creative_id
    from {{ target.schema }}_facebook_ads_source_dev.stg_facebook_ads__ad_history
    where is_most_recent_record 
),

final as (
    select 
        dev.source_relation as dev_source_relation,
        prod.source_relation as prod_source_relation,
        dev.updated_at as dev_updated_at,
        prod.updated_at as prod_updated_at,
        dev.ad_id as dev_ad_id,
        prod.ad_id as prod_ad_id,
        dev.ad_name as dev_ad_name,
        prod.ad_name as prod_ad_name,
        dev.account_id as dev_account_id,
        prod.account_id as prod_account_id,
        dev.ad_set_id as dev_ad_set_id,
        prod.ad_set_id as prod_ad_set_id,
        dev.campaign_id as dev_campaign_id,
        prod.campaign_id as prod_campaign_id,
        dev.creative_id as dev_creative_id,
        prod.creative_id as prod_creative_id

    from prod
    full outer join dev 
        on dev.ad_id = prod.ad_id
)

select *
from final
where
    prod_source_relation != dev_source_relation
    or prod_updated_at != dev_updated_at
    or prod_ad_id != dev_ad_id
    or prod_ad_name != dev_ad_name
    or prod_account_id != dev_account_id
    or prod_ad_set_id != dev_ad_set_id
    or prod_campaign_id != dev_campaign_id
    or prod_creative_id != dev_creative_id