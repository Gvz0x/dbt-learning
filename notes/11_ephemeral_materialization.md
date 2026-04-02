# 11 — Ephemeral Materialization

## What it is
An ephemeral model is a dbt model that creates no object in the database. Instead, its SQL is injected as a CTE into any model that references it with `ref()`.

## Why it exists
Sometimes you need intermediate logic to keep your SQL organized and readable, but you don't want to create extra views or tables in Snowflake. Ephemeral lets you break complex SQL into logical pieces in dbt without cluttering your schema.

## How to use it

### Set the materialization
```sql
{{ config(materialized='ephemeral') }}

with web_sales as (
    select * from {{ ref('stg_web_sales') }}
),

promotions as (
    select * from {{ ref('stg_promotions') }}
),

joined as (
    select
        web_sales.customer_sk,
        web_sales.sold_date_sk,
        web_sales.promo_sk,
        promotions.promo_id,
        promotions.promo_name
    from web_sales
    left join promotions
        on web_sales.promo_sk = promotions.promo_sk
)

select
    customer_sk,
    sold_date_sk,
    promo_sk,
    promo_id,
    promo_name
from joined
```

### Reference it from another model
```sql
select * from {{ ref('int_web_sales_enriched') }}
```
dbt will inline the ephemeral model's SQL as a CTE inside this query.

## Real example from this project
- `models/intermediate/int_web_sales_enriched.sql` — joins `stg_web_sales` and `stg_promotions`
- Running `dbt run -s int_web_sales_enriched` produces no output in Snowflake
- Nothing appears in the `learning_dbt` schema

## dbt commands
```bash
dbt compile -s my_ephemeral_model   # see the compiled SQL — resolves refs but no object created
dbt run -s my_ephemeral_model       # runs in ~1s, nothing built
```

## Common mistakes
- Expecting to find the model in Snowflake after `dbt run` — it won't be there
- Using ephemeral for models that are queried directly by BI tools — those need a real object (view or table)
- Confusing ephemeral with temporary tables — ephemeral is a dbt concept, not a Snowflake object

## Key behaviour
- `dbt run -s int_web_sales_enriched` completes instantly with no "START/OK" log — nothing was built
- The SQL only executes when another model references it with `ref()`
- Convention: name intermediate models with `int_` prefix and place in `models/intermediate/`
