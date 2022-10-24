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