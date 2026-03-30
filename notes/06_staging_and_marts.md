# 06 — Staging & Marts

## What it is
A convention for organising models into layers. Staging cleans raw data, marts combine it into business outputs.

## Why it exists
Without layers, models become a tangled mess where cleaning and business logic are mixed together. Layers make the project maintainable and easy to understand.

## Staging layer
- Lives in `models/staging/`
- One model per source table
- Materialized as **views** (lightweight)
- Only job: clean and rename columns — no joins, no aggregations
- Named with `stg_` prefix

```sql
-- stg_customers.sql
with source as (
    select * from {{ source('tpcds', 'customer') }}
),

renamed as (
    select
        c_customer_sk         as customer_sk,
        c_customer_id         as customer_id,
        c_first_name          as first_name,
        c_preferred_cust_flag as is_preferred_customer
    from source
)

select
    customer_sk,
    customer_id,
    first_name,
    is_preferred_customer
from renamed
```

## Marts layer
- Lives in `models/marts/`
- Joins staging models together into final business outputs
- Materialized as **tables** (fast to query)
- Named with `fct_` (fact) or `dim_` (dimension) prefix

```sql
-- fct_funnel.sql
with web_sales as (
    select * from {{ ref('stg_web_sales') }}
),
customers as (
    select * from {{ ref('stg_customers') }}
),
joined as (
    select ...
    from web_sales s
    left join customers c on s.customer_sk = c.customer_sk
)

select ... from joined
```

## Your project's layers
```
SNOWFLAKE_SAMPLE_DATA (raw)
        ↓
stg_customers  stg_web_sales  stg_promotions   ← staging (views)
        ↓              ↓              ↓
              fct_funnel                        ← mart (table, 15.7M rows)
```

## Common mistakes
- Putting joins in staging models — staging should only clean, not combine
- Materializing staging as tables — use views unless there's a performance reason
- Skipping the staging layer and referencing raw sources directly in marts
