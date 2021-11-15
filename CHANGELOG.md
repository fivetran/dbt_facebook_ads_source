# dbt_facebook_ads_source v0.4.0

## Features
- Allow for multiple sources by unioning source tables across multiple Facebook Ads connectors.
  - Refer to the [README](https://github.com/fivetran/dbt_facebook_ads_source#unioning-multiple-facebook-ads-connectors) for more details.

## Under the Hood
- Unioning: The unioning occurs in the tmp models using the `fivetran_utils.union_data` macro.
- Source Relation column: To distinguish which source each field comes from, we added a new `source_relation` column in each staging model and applied the `fivetran_utils.source_relation` macro.

## Contributors
- [@pawelngei](https://github.com/pawelngei)

# dbt_facebook_ads_source v0.1.0 -> v0.4.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!