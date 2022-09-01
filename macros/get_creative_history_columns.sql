{% macro get_creative_history_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "account_id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "page_link", "datatype": dbt_utils.type_string()},
    {"name": "template_page_link", "datatype": dbt_utils.type_string()},
    {"name": "url_tags", "datatype": dbt_utils.type_string()},
    {"name": "asset_feed_spec_link_urls", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_child_attachments", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_caption", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_description", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_link", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_message", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_android", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_ios", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_ipad", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_iphone", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
