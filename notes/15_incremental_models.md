# 15 — Incremental Models

## What it is
An incremental model is a table that only processes new rows on each run, instead of rebuilding everything from scratch. dbt handles the logic of what's "new" via the `is_incremental()` macro.

## Why it exists
Rebuilding a full table every run is slow and expensive. In production, tables can have years of data. Incremental models let you process only today's new rows and append them — keeping build times fast regardless of total table size.

## How it works

### First run
`is_incremental()` returns false — the filter is skipped, full table is built.

### Subsequent runs
`is_incremental()` returns true — only rows newer than the current max are processed and merged into the existing table.

## Config block
```sql
{{ config(
    materialized='incremental',
    unique_key='funnel_id'
) }}
```

`unique_key` tells dbt which column identifies a row. If a row already exists, dbt updates it instead of inserting a duplicate (runs a Snowflake `MERGE` statement).

## is_incremental() filter pattern
```sql
with web_sales as (

    select * from {{ ref('stg_web_sales') }}

    {% if is_incremental() %}
        where sold_date_sk > (select max(sold_date_sk) from {{ this }})
    {% endif %}

),
```

- `{{ this }}` — refers to the existing table in Snowflake
- The filter is added to the CTE that contains the date column, not the final SELECT

## Commands
```bash
dbt run -s fct_funnel              # incremental run (new rows only)
dbt run -s fct_funnel --full-refresh  # drop and rebuild entire table
```

Use `--full-refresh` when:
- Your model logic changes and you need to reprocess all historical data
- The table is corrupted or out of sync
- You're setting up for the first time and want a clean build

## Incremental strategies (Snowflake)
| Strategy | Behaviour | Use when |
|----------|-----------|----------|
| `merge` (default) | Update existing rows, insert new | Most cases |
| `delete+insert` | Delete matching rows, re-insert | Late-arriving or corrected data |

Set in config:
```sql
{{ config(
    materialized='incremental',
    unique_key='funnel_id',
    incremental_strategy='delete+insert'
) }}
```

## Gotchas
- If the table already exists when you first convert to incremental, `is_incremental()` returns true immediately — you may get 0 rows on the first run. Use `--full-refresh` to reset.
- The filter column (`sold_date_sk`) must exist in the CTE where you apply the filter, not just in the final SELECT.
- Without `unique_key`, dbt just appends rows — you'll get duplicates on reruns.
