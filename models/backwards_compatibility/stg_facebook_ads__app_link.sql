with base as (

  select *
  from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

  select 
    _fivetran_id, 
    creative_id, 
    template_app_link_spec_ios_dummy,
    template_app_link_spec_ipad_dummy,
    template_app_link_spec_android_dummy,
    template_app_link_spec_iphone_dummy
  from base

{% for app in ['ios','ipad','android','iphone'] %}
  
), unnested_{{ app }} as (

  select 
    _fivetran_id,
    creative_id,
    '{{ app }}' as app_type,
    json_extract_scalar(element, '$.index') as index,
    json_extract_scalar(element, '$.app_name') as app_name,
    json_extract_scalar(element, '$.app_store_id') as app_store_id,
    json_extract_scalar(element, '$.class_name') as class_name,
    json_extract_scalar(element, '$.package_name') as package_name,
    json_extract_scalar(element, '$.template_page') as template_page
  from base
  left join unnest(json_extract_array(template_app_link_spec_{{ app }}_dummy)) as element

{% endfor %}

), unioned as (

    select * from unnested_ios
    union all
    select * from unnested_iphone
    union all
    select * from unnested_ipad
    union all
    select * from unnested_android

)

select *
from unioned
order by _fivetran_id