# 12. Configurations vs Properties

## What it is
Configurations tell dbt **how to build** a model (materialization, schema, tags).
Properties tell dbt **what a model is** (descriptions, tests — metadata).

## Why it exists
Separating build behavior from metadata keeps concerns clean. Configs affect what Snowflake objects get created. Properties affect documentation and data quality checks. They live in different places and serve different purposes.

## Where each lives

| | What it is | Where it lives |
|---|---|---|
| **Config** | How dbt builds the model | `dbt_project.yml`, `schema.yml`, or `.sql` config block |
| **Property** | What the model is | `schema.yml` only |

Note: `schema.yml` can hold **both** configs and properties.

## The override hierarchy

```
SQL config block  >  schema.yml  >  dbt_project.yml
```

The closer to the SQL file, the higher the priority. The SQL config block always wins.

## Real example from this project

`fct_funnel` materializes as a table because of `dbt_project.yml`:

```yaml
# dbt_project.yml
models:
  learning_dbt:
    marts:
      +materialized: table
```

No config block needed in `fct_funnel.sql` — the folder-level default handles it.

If you wanted `fct_funnel` to be a view instead, you'd add this to the top of `fct_funnel.sql`:

```sql
{{ config(materialized='view') }}
```

That would override `dbt_project.yml`.

## Common mistakes / gotchas
- Assuming `schema.yml` is only for tests and descriptions — it can also hold configs
- Forgetting the hierarchy and being confused when a model builds differently than expected
- Putting configs in `schema.yml` unnecessarily — prefer `dbt_project.yml` for folder defaults and SQL config blocks for exceptions
