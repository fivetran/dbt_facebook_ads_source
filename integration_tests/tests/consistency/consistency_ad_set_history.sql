{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        source_relation,
        updated_at,
        ad_set_id,
        ad_set_name,
        account_id,
        campaign_id,
        start_at,
        end_at,
        bid_strategy,
        daily_budget,
        budget_remaining,
        status
    from {{ target.schema }}_facebook_ads_source_prod.stg_facebook_ads__ad_set_history
    where is_most_recent_record
),

dev as (
    select
        source_relation,
        updated_at,
        ad_set_id,
        ad_set_name,
        account_id,
        campaign_id,
        start_at,
        end_at,
        bid_strategy,
        daily_budget,
        budget_remaining,
        status
    from {{ target.schema }}_facebook_ads_source_dev.stg_facebook_ads__ad_set_history
    where is_most_recent_record 
),

final as (
    select 
        dev.source_relation as dev_source_relation,
        prod.source_relation as prod_source_relation,
        dev.updated_at as dev_updated_at,
        prod.updated_at as prod_updated_at,
        dev.ad_set_id as dev_ad_set_id,
        prod.ad_set_id as prod_ad_set_id,
        dev.ad_set_name as dev_ad_set_name,
        prod.ad_set_name as prod_ad_set_name,
        dev.account_id as dev_account_id,
        prod.account_id as prod_account_id,
        dev.campaign_id as dev_campaign_id,
        prod.campaign_id as prod_campaign_id,
        dev.start_at as dev_start_at,
        prod.start_at as prod_start_at,
        dev.end_at as dev_end_at,
        prod.end_at as prod_end_at,
        dev.bid_strategy as dev_bid_strategy,
        prod.bid_strategy as prod_bid_strategy,
        dev.daily_budget as dev_daily_budget,
        prod.daily_budget as prod_daily_budget,
        dev.budget_remaining as dev_budget_remaining,
        prod.budget_remaining as prod_budget_remaining,
        dev.status as dev_status,
        prod.status as prod_status

    from prod
    full outer join dev 
        on dev.ad_set_id = prod.ad_set_id
)

select *
from final
where
    prod_source_relation != dev_source_relation
    or prod_updated_at != dev_updated_at
    or prod_ad_set_id != dev_ad_set_id
    or prod_ad_set_name != dev_ad_set_name
    or prod_account_id != dev_account_id
    or prod_campaign_id != dev_campaign_id
    or prod_start_at != dev_start_at
    or prod_end_at != dev_end_at
    or prod_bid_strategy != dev_bid_strategy
    or prod_daily_budget != dev_daily_budget
    or prod_budget_remaining != dev_budget_remaining
    or prod_status != dev_status