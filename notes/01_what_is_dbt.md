# What is dbt?

dbt (data build tool) manages the **transformation layer** of your data pipeline.
As a data analyst, your job is to turn raw data into something useful for reporting.
dbt is the tool that organizes, runs, and validates that work.

## The Flow

```
Raw Data in Snowflake        dbt                        Output in Snowflake
(loaded by Fivetran,          (your SQL models,          (clean tables/views
 Airbyte, pipelines,  ──────► run in the right   ──────► ready for dashboards,
 etc.)                        order, tested,              reports, analysts)
                              documented)
```

## What dbt does NOT do
- Load raw data into Snowflake — that is an ingestion tool's job (Fivetran, Airbyte, etc.)
- Connect to your BI tool — Tableau or Power BI does that
- Replace SQL — you still write SQL, dbt just manages it

## What dbt DOES do
- Takes your `.sql` files and runs them against Snowflake
- Builds tables and views automatically from those SQL files
- Runs models in the correct order when one depends on another
- Tests that your data looks correct (no nulls, no duplicates, etc.)
- Generates documentation from your code

## The key idea
When you write `{{ ref('some_model') }}` in a SQL file, dbt knows to run
that model first before the one that references it. Without dbt, you would
have to manage that execution order yourself.

> Snowflake is the engine. Your SQL is the logic. dbt is the project manager
> that orchestrates all of it.
