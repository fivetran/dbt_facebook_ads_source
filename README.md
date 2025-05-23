# Facebook Ads Source dbt Package ([Docs](https://fivetran.github.io/dbt_facebook_ads_source/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_facebook_ads_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
<!--section="facebook_ads_source_model"-->
- Materializes [Facebook Ads staging tables](https://fivetran.github.io/dbt_facebook_ads_source/#!/overview/facebook_ads_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/facebook-ads#schemainformation). These staging tables clean, test, and prepare your facebook_ads data from [Fivetran's connector](https://fivetran.com/docs/applications/facebook-ads) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Facebook Ads data through the [dbt docs site](https://fivetran.github.io/dbt_facebook_ads_source/).
- These tables are designed to work simultaneously with our [Facebook Ads transformation package](https://github.com/fivetran/dbt_facebook_ads).
<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Facebook Ads connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.
- You will need to configure your Facebook Ads connection to pull the `basic_ad` pre-built report and its child `basic_ad_actions` and `basic_ad_action_values` pre-built reports. These pre-built reports should be enabled in your connection by default. However, to confirm these reports are actively syncing you may perform the following steps:
    1. Navigate to the connection schema tab in Fivetran.
    2. Search for `basic_ad`, `basic_ad_actions`, `basic_ad_action_values` and confirm they all selected/enabled. If you would like country and region-level transformations, do the same for `demographics_country`, `demographics_country_actions`, `demographics_region`, and `demographics_region_actions`.
    3. If not selected, do so and sync. If already selected you are ready to run the models!

 >**Note**: If you do not have your Facebook Ads connection [schema change settings](https://fivetran.com/docs/using-fivetran/features/data-blocking-column-hashing/config#configureschemachangesettingsforexistingconnectors) set to `Allow all`, it is possible that you are missing `basic_ad_actions` or `basic_ad_action_values`. If you would like to surface conversion metrics in your Facebook and/or Ad Reporting models, please ensure these reports are syncing. Otherwise, the `conversions` and `conversions_value` fields will be `null`.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `facebook_ads` transformation or `ad_reporting` combo package)
If you are not using the [Facebook Ads](https://github.com/fivetran/dbt_facebook_ads) transformation package or the [Ad Reporting](https://github.com/fivetran/dbt_ad_reporting) combination package, include the following facebook_ads_source package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: fivetran/facebook_ads_source
    version: [">=0.9.0", "<0.10.0"] # we recommend using ranges to capture non-breaking changes automatically
```
### Step 3: Define database and schema variables
By default, this package runs using your destination and the `facebook_ads` schema. If this is not where your Facebook Ads data is (for example, if your facebook_ads schema is named `facebook_ads_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    facebook_ads_database: your_destination_name
    facebook_ads_schema: your_schema_name 
```

### (Optional) Step 4: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple facebook_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `facebook_ads_union_schemas` OR `facebook_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    facebook_ads_union_schemas: ['facebook_ads_usa','facebook_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    facebook_ads_union_databases: ['facebook_ads_usa','facebook_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Enable or Disable Country and Region Reports
This package uses the `demographics_country`, `demographics_country_actions`, `demographics_region`, and `demographics_region_actions` [pre-built](https://fivetran.com/docs/connectors/applications/facebook-ads/prebuilt-reports) reports, but takes into consideration that not every user may use these tables.

If you are running the Facebook Ads transform package via Fivetran Quickstart, transformations of the above tables will be dynamically enabled or disabled. Otherwise, transformations of these tables are **disabled** by default.

To enable transformations of the above geo-focused reports, add the following variable configurations to your root `dbt_project.yml` file:

```yml
vars:
  facebook_ads__using_demographics_country: True # False by default. Will enable/disable use of the `demographics_country` and `demographics_country_actions` reports
  facebook_ads__using_demographics_region: True # False by default. Will enable/disable use of the `demographics_region` and `demographics_region_actions` reports
```

#### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, `cost`, `reach`, `frequency`, and conversion `value` (using the [default](https://fivetran.com/docs/connectors/applications/facebook-ads/custom-reports#attributionwindows) attribution window) from the source reporting tables (`BASIC_AD`, `BASIC_AD_ACTIONS`, `BASIC_AD_ACTION_VALUES`, `DEMOGRAPHICS_COUNTRY`, `DEMOGRAPHICS_REGION`, `DEMOGRAPHICS_COUNTRY_ACTIONS`, and `DEMOGRAPHICS_REGION_ACTIONS`) to store into the staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) and transformed (`transform_sql`) if desired, but not required. Only the `name` of each metric field is required. Use the below format for declaring the respective pass-through variables:

```yml
vars:
    facebook_ads__basic_ad_passthrough_metrics: # add metrics found in BASIC_AD
      - name: "new_custom_field"
        alias: "custom_field_alias"
        transform_sql: "coalesce(custom_field_alias, 0)" # reference the `alias` here if you are using one
      - name: "another_one"
        transform_sql: "coalesce(another_one, 0)" # reference the `name` here if you're not using an alias
      - name: "cpc" # only name is required
    facebook_ads__basic_ad_actions_passthrough_metrics: # add conversion metrics found in BASIC_AD_ACTIONS
      - name: "_7_d_click"
        alias: "conversion_value_7d_click"
      - name: "inline"
    facebook_ads__basic_ad_action_values_passthrough_metrics: # add conversion metrics found in BASIC_AD_ACTION_VALUES
      - name: "_7_d_click"
        alias: "conversion_value_7d_click"
      - name: "inline"
    facebook_ads__demographics_country_passthrough_metrics: # Add metrics from DEMOGRAPHICS_COUNTRY
      - name: "inline_link_clicks"
    facebook_ads__demographics_country_actions_passthrough_metrics: # Add conversion metrics from DEMOGRAPHICS_COUNTRY_ACTIONS
      - name: "inline"
    facebook_ads__demographics_region_passthrough_metrics: # Add metrics from DEMOGRAPHICS_REGION
      - name: "cost_per_inline_link_click"
    facebook_ads__demographics_region_actions_passthrough_metrics: # Add conversion metrics from DEMOGRAPHICS_REGION_ACTIONS
      - name: "inline"
```

>**Note** Please ensure you exercised due diligence when adding metrics to these models. The metrics added by default (taps, impressions, spend, and default-attribution window conversion values) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example metric averages, which may be inaccurately represented at the grain for reports created in this package. You will want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package.

#### Change the build schema
By default, this package builds the Facebook Ads staging models (8 views, 8 tables) within a schema titled (`<target_schema>` + `_facebook_ads_source`) in your destination. If this is not where you would like your Facebook Ads staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    facebook_ads_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_facebook_ads_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    facebook_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
    
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
          
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/facebook_ads_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_facebook_ads_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_facebook_ads_source/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_facebook_ads_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).