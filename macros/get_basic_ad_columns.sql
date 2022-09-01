{% macro get_basic_ad_columns() %}

{% set columns = [
    {"name": "ad_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_name", "datatype": dbt_utils.type_string()},
    {"name": "adset_name", "datatype": dbt_utils.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "account_id", "datatype": dbt_utils.type_int()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "inline_link_clicks", "datatype": dbt_utils.type_int()},
    {"name": "spend", "datatype": dbt_utils.type_float()},
    {"name": "reach", "datatype": dbt_utils.type_int()},
    {"name": "frequency", "datatype": dbt_utils.type_float()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('facebook_ads__basic_ad_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
