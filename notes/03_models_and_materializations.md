# 03 — Models & Materializations

## What it is
A model is a `.sql` file containing a SELECT statement. When you run `dbt run`, dbt executes that SQL and creates an object in Snowflake. A materialization controls what type of object gets created.

## Why it exists
Without dbt, you'd manually run SQL scripts and manage what gets created where. dbt automates this — write a SELECT, dbt handles the rest.

## How to use it

### Standard model pattern (staging)
```sql
with source as (
    select * from {{ source('tpcds', 'customer') }}
),

renamed as (
    select
        c_customer_sk  as customer_sk,
        c_first_name   as first_name
    from source
)

select
    customer_sk,
    first_name
from renamed
```

### Setting materialization inline
```sql
{{ config(materialized='table') }}

select ...
```

### Setting materialization by folder in dbt_project.yml
```yaml
models:
  learn_dbt:
    staging:
      +materialized: view
    marts:
      +materialized: table
```

## Materialization types
| Type | Creates | Use when |
|------|---------|----------|
| `view` | SQL view | Lightweight, staging layer |
| `table` | Physical table | Queried often, complex joins |
| `incremental` | Append new rows | Large tables, event data |
| `ephemeral` | CTE only, no DB object | Intermediate logic |

## dbt commands
```bash
dbt run              # build all models
dbt run -s my_model  # build one model
```

## Common mistakes
- Using `select *` as the final output — always list columns explicitly
- Materializing everything as a table — use views for staging, tables for marts
- Putting transformation logic in the `source` CTE — keep it in `renamed`
