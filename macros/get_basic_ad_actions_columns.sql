{% macro get_basic_ad_actions_columns() %}

{% set columns = [
    {"name": "_1_d_view", "datatype": dbt.type_float()},
    {"name": "_28_d_click", "datatype": dbt.type_float()},
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "action_type", "datatype": dbt.type_string()},
    {"name": "ad_id", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "index", "datatype": dbt.type_int()},
    {"name": "inline", "datatype": dbt.type_float()},
    {"name": "value", "datatype": dbt.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}
