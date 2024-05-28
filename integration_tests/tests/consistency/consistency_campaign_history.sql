{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        source_relation,
        updated_at,
        created_at,
        account_id,
        campaign_id,
        campaign_name,
        start_at,
        end_at,
        status,
        daily_budget,
        lifetime_budget,
        budget_remaining

    from {{ target.schema }}_facebook_ads_source_prod.stg_facebook_ads__campaign_history
    where is_most_recent_record
),

dev as (
    select
        source_relation,
        updated_at,
        created_at,
        account_id,
        campaign_id,
        campaign_name,
        start_at,
        end_at,
        status,
        daily_budget,
        lifetime_budget,
        budget_remaining

    from {{ target.schema }}_facebook_ads_source_dev.stg_facebook_ads__campaign_history
    where is_most_recent_record 
),

final as (
    select 
        dev.source_relation as dev_source_relation,
        prod.source_relation as prod_source_relation,
        dev.updated_at as dev_updated_at,
        prod.updated_at as prod_updated_at,
        dev.created_at as dev_created_at,
        prod.created_at as prod_created_at,
        dev.account_id as dev_account_id,
        prod.account_id as prod_account_id,
        dev.campaign_id as dev_campaign_id,
        prod.campaign_id as prod_campaign_id,
        dev.campaign_name as dev_campaign_name,
        prod.campaign_name as prod_campaign_name,
        dev.start_at as dev_start_at,
        prod.start_at as prod_start_at,
        dev.end_at as dev_end_at,
        prod.end_at as prod_end_at,
        dev.status as dev_status,
        prod.status as prod_status,
        dev.daily_budget as dev_daily_budget,
        prod.daily_budget as prod_daily_budget,
        dev.lifetime_budget as dev_lifetime_budget,
        prod.lifetime_budget as prod_lifetime_budget,
        dev.budget_remaining as dev_budget_remaining,
        prod.budget_remaining as prod_budget_remaining

    from prod
    full outer join dev 
        on dev.campaign_id = prod.campaign_id
)

select *
from final
where
    prod_source_relation != dev_source_relation
    or prod_updated_at != dev_updated_at
    or prod_created_at != dev_created_at
    or prod_account_id != dev_account_id
    or prod_campaign_id != dev_campaign_id
    or prod_campaign_name != dev_campaign_name
    or prod_start_at != dev_start_at
    or prod_end_at != dev_end_at
    or prod_status != dev_status
    or prod_daily_budget != dev_daily_budget
    or prod_lifetime_budget != dev_lifetime_budget
    or prod_budget_remaining != dev_budget_remaining