# dbt_facebook_ads_source version.version

## Documentation
- Corrected references to connectors and connections in the README. ([#40](https://github.com/fivetran/dbt_facebook_ads_source/pull/40))

# dbt_facebook_ads_source v0.8.0

[PR #36](https://github.com/fivetran/dbt_facebook_ads_source/pull/36) includes the following updates:

## Breaking Changes 
- Incorporates the `basic_ad_actions` and `basic_ad_action_values` pre-built reports in order to grab conversion data. They are both child tables of the already-required `basic_ad` report, broken down by `action_type`. 
  - Addition of the new `stg_facebook_ads__basic_ad_actions` and `stg_facebook_ads__basic_ad_action_values` (and their `_tmp` counterparts) staging models. Given that this is a schema change for the package, this is a breaking change.

## Feature Updates: Conversion Metrics
- With the inclusion of the `basic_ad_actions` and `basic_ad_action_values` source tables, we have added the `facebook_ads__basic_ad_actions_passthrough_metrics` and `facebook_ads__basic_ad_action_values_passthrough_metrics` variables to pass through additional conversion value metrics to downstream models.
  - By default, the package includes only the conversion value calculated using the [default](https://fivetran.com/docs/connectors/applications/facebook-ads/custom-reports#attributionwindows) attribution window, but your report may include calculations using the other windows defined [here](https://developers.facebook.com/docs/marketing-api/reference/ads-action-stats/). See [README](https://github.com/fivetran/dbt_facebook_ads_source/tree/main?tab=readme-ov-file#passing-through-additional-metrics) for details on how to use the new variables.
- Adds the `optimization_goal` field to `stg_facebook_ads__ad_set_history` model. This is defined as the optimization goal this ad set is using, possible values of which are defined [here](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign/#fields).
- Adds the `conversion_domain` field to `stg_facebook_ads__ad_history` model. This is defined as the domain you've configured the ad to convert to.

## Documentation
- Documents the ability to transform metrics provided to the new `facebook_ads__basic_ad_passthrough_metrics` and `facebook_ads__basic_ad_action_values_passthrough_metrics` variables. See [README](https://github.com/fivetran/dbt_facebook_ads_source/tree/main?tab=readme-ov-file#passing-through-additional-metrics) for details.

## Under the Hood
- Creates `facebook_ads_fill_pass_through_columns` macro to make passthrough column logic in the new staging models DRYer.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_facebook_ads_source v0.7.4
[PR #37](https://github.com/fivetran/dbt_facebook_ads_source/pull/37) includes the following update:

## Bug Fixes
- Updated partition logic in `*_history` staging models to account for null tables, which could cause `constant expressions are not supported in partition by clauses` errors in Redshift.

# dbt_facebook_ads_source v0.7.3
[PR #35](https://github.com/fivetran/dbt_facebook_ads_source/pull/35) includes the following updates:

## Bug Fixes
- Resolved the "duplicate column" error that would arise when the `facebook_ads__basic_ad_passthrough_metrics` variable included `reach` or `frequency`. `Reach` and `frequency` were included by default in the `stg_facebook_ads__basic_ad` model but will now only persist to downstream transform models if specified in the `facebook_ads__basic_ad_passthrough_metrics` variable.
  - This error is now avoided by first [checking](https://github.com/fivetran/dbt_facebook_ads_source/blob/main/models/stg_facebook_ads__basic_ad.sql#L41-L45) if `reach` and `frequency` are included in `facebook_ads__basic_ad_passthrough_metrics` and only selecting the columns once if so.

## Under the Hood
- Updated the maintainer PR template to our most up-to-date standards.
- Removed the now defunct 2nd-reviewer workflow bot.

# dbt_facebook_ads_source v0.7.2
[PR #33](https://github.com/fivetran/dbt_facebook_ads_source/pull/33) includes the following updates:

## 🧪 Test Updates 🧪
- Updated `stg_facebook_ads__creative_history` test in `stg_facebook_ads.yml` to test uniqueness on identifier `_fivetran_id`, since there are rare cases where `_fivetran_synced` and `creative_id` could hold the same value. 

# dbt_facebook_ads_source v0.7.1

[PR #31](https://github.com/fivetran/dbt_facebook_ads_source/pull/31) includes the following updates:
## Documentation Updates
- The [prerequisite steps in the README](https://github.com/fivetran/dbt_facebook_ads_source#step-1-prerequisites) for generating the `basic_ad` pre-built report have been modified to reflect the current state of the Facebook Ads connector.
- Adds the [DECISIONLOG](DECISIONLOG.md) to clarify why there exist differences among aggregations across different grains.

# dbt_facebook_ads_source v0.7.0
[PR #28](https://github.com/fivetran/dbt_facebook_ads_source/pull/28) includes the following updates:
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple facebook_ads connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_facebook_ads_source/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- Updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging model and applied the `fivetran_utils.source_relation` macro.
- Updated tests to account for the new `source_relation` column.
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_facebook_ads_source v0.6.0

## 🚨 Breaking Changes 🚨:
[PR #23](https://github.com/fivetran/dbt_facebook_ads_source/pull/23) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_facebook_ads_source v0.5.0

## 🎉 Feature Enhancements 🎉
PR (#25)[https://github.com/fivetran/dbt_facebook_ads_source/pull/22] includes the following changes:
- Updates source models to include more potentially useful columns and respective definitions within `src.yml` and `stg.yml`.
- Added passthrough functionality for `BASIC_AD` pre-built report using `facebook_ads__basic_ad_metrics` variable.`facebook_ads__basic_ad_metrics` example.
```yml
vars:
  facebook_ads__basic_ad_metrics:
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
```
- Updates `is_most_recent_record` logic to take in `updated_time` rather than `_fivetran_synced` for the following models:
  - `stg_facebook_ads__campaign_history`
  - `stg_facebook_ads__ad_set_history`
  - `stg_facebook_ads__ad_history`
- Model grain tests were added for better data integrity.
- Addition of identifier variables for each of the source tables to allow for further flexibility in source table direction within the dbt project.
- `README` updates for easier navigation and use of the package.

# dbt_facebook_ads_source v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_facebook_ads_source v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!