{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        source_relation,
        account_id,
        _fivetran_synced,
        account_name,
        account_status,
        business_country_code,
        created_at,
        currency,
        timezone_name
    from {{ target.schema }}_facebook_ads_source_prod.stg_facebook_ads__account_history
    where is_most_recent_record
),

dev as (
    select
        source_relation,
        account_id,
        _fivetran_synced,
        account_name,
        account_status,
        business_country_code,
        created_at,
        currency,
        timezone_name
    from {{ target.schema }}_facebook_ads_source_dev.stg_facebook_ads__account_history
    where is_most_recent_record 
),

final as (
    select 
        dev.source_relation as dev_source_relation,
        prod.source_relation as prod_source_relation,
        dev.account_id as dev_account_id,
        prod.account_id as prod_account_id,
        dev._fivetran_synced as dev__fivetran_synced,
        prod._fivetran_synced as prod__fivetran_synced,
        dev.account_name as dev_account_name,
        prod.account_name as prod_account_name,
        dev.account_status as dev_account_status,
        prod.account_status as prod_account_status,
        dev.business_country_code as dev_business_country_code,
        prod.business_country_code as prod_business_country_code,
        dev.created_at as dev_created_at,
        prod.created_at as prod_created_at,
        dev.currency as dev_currency,
        prod.currency as prod_currency,
        dev.timezone_name as dev_timezone_name,
        prod.timezone_name as prod_timezone_name

    from prod
    full outer join dev 
        on dev.account_id = prod.account_id
)

select *
from final
where
    prod_source_relation != dev_source_relation
    or prod_account_id != dev_account_id
    or prod__fivetran_synced != dev__fivetran_synced
    or prod_account_name != dev_account_name
    or prod_account_status != dev_account_status
    or prod_business_country_code != dev_business_country_code
    or prod_created_at != dev_created_at
    or prod_currency != dev_currency
    or prod_timezone_name != dev_timezone_name