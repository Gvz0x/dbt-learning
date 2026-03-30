# 07 — Tests

## What it is
Data quality checks defined in `schema.yml` that run against your models in Snowflake. They catch bad data before it reaches dashboards or reports.

## Why it exists
Without tests, bad data silently flows downstream. A null primary key or duplicate row in a staging model corrupts everything built on top of it. Tests catch this early.

## The 4 built-in test types

| Test | What it checks | Example use |
|------|---------------|-------------|
| `not_null` | Column has no empty values | Primary keys, required fields |
| `unique` | No duplicate values in column | Primary keys, business keys |
| `accepted_values` | Only specific values allowed | Flag columns like `'Y'`/`'N'` |
| `relationships` | Value exists in another model | Foreign key checks |

## How to define tests in schema.yml

```yaml
version: 2

models:
  - name: stg_customers
    columns:
      - name: customer_sk
        tests:
          - unique
          - not_null

      - name: is_preferred_customer
        tests:
          - accepted_values:
              arguments:
                values: ['Y', 'N']

  - name: stg_web_sales
    columns:
      - name: customer_sk
        tests:
          - relationships:
              arguments:
                to: ref('stg_customers')
                field: customer_sk
```

## Severity levels
```yaml
- not_null:
    config:
      severity: error   # default — stops the pipeline on failure
      # severity: warn  # keeps going, just prints a warning
```

Use `error` for things that should never happen (null PKs, duplicates).
Use `warn` for expected edge cases (missing foreign keys from guest checkouts).

## dbt commands
```bash
dbt test              # run all tests
dbt test -s my_model  # test one model
dbt build             # run + test together (recommended)
```

## Your project's tests (13 total, all passing)
- `fct_funnel` — not_null on order_number, sold_date_sk
- `stg_customers` — unique + not_null on customer_sk, not_null on customer_id, accepted_values on is_preferred_customer
- `stg_web_sales` — not_null on order_number, relationships on customer_sk
- `stg_promotions` — unique + not_null on promo_sk, not_null on promo_id, accepted_values on channel_email + is_discount_active

## Common mistakes
- Not testing primary keys — always add `unique` + `not_null` to every PK
- Using old syntax without `arguments:` property — causes deprecation warnings in dbt 1.11+
- Only testing staging models — marts need tests too
