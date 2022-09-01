{% macro get_ad_set_history_columns() %}

{% set columns = [
    {"name": "updated_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "account_id", "datatype": dbt_utils.type_int()},
    {"name": "campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "bid_strategy", "datatype": dbt_utils.type_string()},
    {"name": "daily_budget", "datatype": dbt_utils.type_int()},
    {"name": "budget_remaining", "datatype": dbt_utils.type_int()},
    {"name": "status", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
