# 04 — ref() and the DAG

## What it is
`ref()` is a Jinja function that references another dbt model. The DAG (Directed Acyclic Graph) is the map dbt builds from all `ref()` calls to determine the correct build order.

## Why it exists
Without `ref()`, dbt has no way to know which models depend on which. You'd have to manually manage execution order. `ref()` also resolves the full database path automatically so you never hardcode it.

## How to use it

```sql
-- reference another model
select * from {{ ref('stg_customers') }}

-- dbt compiles this to:
select * from dbt_database.learning_dbt.stg_customers
```

## Your project's DAG
```
stg_customers ──┐
stg_web_sales ──┼──► fct_funnel
stg_promotions ─┘
```
dbt reads the `ref()` calls in `fct_funnel` and knows to build the three staging models first.

## Why not hardcode the table name?
Two reasons:
1. **DAG** — dbt can't see the dependency and won't guarantee build order
2. **Dynamic paths** — if your database or schema changes, `ref()` updates automatically. Hardcoded names break.

## dbt commands
```bash
dbt run              # builds models in DAG order automatically
dbt compile -s fct_funnel  # see the compiled SQL with ref() resolved
```

## Common mistakes
- Writing raw table names instead of `ref()` — dbt won't know the dependency
- Hardcoding database paths like `SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.date_dim` — use `source()` instead
