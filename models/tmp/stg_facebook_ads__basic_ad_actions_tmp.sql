{{
    fivetran_utils.union_data(
        table_identifier='basic_ad_actions' if var('facebook_ads__using_basic_ad_actions_report', true) else 'basic_ad_action_values_actions', 
        database_variable='facebook_ads_database', 
        schema_variable='facebook_ads_schema', 
        default_database=target.database,
        default_schema='facebook_ads',
        default_variable='basic_ad_actions',
        union_schema_variable='facebook_ads_union_schemas',
        union_database_variable='facebook_ads_union_databases'
    )
}}
