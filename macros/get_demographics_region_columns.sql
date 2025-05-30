{% macro get_demographics_region_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "account_id", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "frequency", "datatype": dbt.type_float()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "inline_link_clicks", "datatype": dbt.type_int()},
    {"name": "reach", "datatype": dbt.type_int()},
    {"name": "region", "datatype": dbt.type_string()},
    {"name": "spend", "datatype": dbt.type_float()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('facebook_ads__demographics_region_passthrough_metrics')) }} 

{{ return(columns) }}

{% endmacro %}
