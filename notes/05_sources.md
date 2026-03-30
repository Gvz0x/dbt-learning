# 05 — Sources

## What it is
Sources are declarations of raw tables that already exist in Snowflake. Defined in `sources.yml`, they let you reference raw tables cleanly using `{{ source() }}` instead of hardcoded paths.

## Why it exists
Without sources, you'd hardcode database paths in your SQL. If the path changes, you'd have to update every model. Sources centralise that in one file.

## How to use it

### Declare in sources.yml
```yaml
version: 2

sources:
  - name: tpcds
    database: SNOWFLAKE_SAMPLE_DATA
    schema: TPCDS_SF10TCL
    tables:
      - name: customer
      - name: web_sales
      - name: promotion
      - name: date_dim
```

### Reference in a model
```sql
-- instead of this (bad)
select * from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.customer

-- use this (good)
select * from {{ source('tpcds', 'customer') }}
```

dbt compiles `{{ source('tpcds', 'customer') }}` to `SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.customer` automatically.

## Your project's sources
All declared in `models/staging/sources.yml`:
- `tpcds.customer` → feeds `stg_customers`
- `tpcds.web_sales` → feeds `stg_web_sales`
- `tpcds.promotion` → feeds `stg_promotions`
- `tpcds.date_dim` → used in `stg_web_sales` for year filtering

## dbt commands
```bash
dbt source freshness  # check if source tables are stale
```

## Common mistakes
- Hardcoding database paths instead of using `source()` — breaks in other environments
- Forgetting to declare a table in `sources.yml` before using `source()` — dbt will error
