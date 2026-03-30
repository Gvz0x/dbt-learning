# 09 — Singular Tests

## What it is
A singular test is a `.sql` file in the `tests/` folder that encodes a specific business rule. It returns rows that violate the rule — zero rows means pass, any rows means fail.

## Why it exists
The 4 generic tests (`not_null`, `unique`, `accepted_values`, `relationships`) cover structural data quality. But they cannot express business logic like "coupon amount should never exceed sales price." Singular tests fill that gap.

## How to use it

### Create a file in `tests/`
```sql
-- tests/assert_coupon_not_greater_than_sales_price.sql
{{ config(severity='warn') }}

select *
from {{ ref('fct_funnel') }}
where coupon_amount > sales_price
```

The test **passes** if the query returns 0 rows.
The test **fails** if the query returns any rows.

### Set severity
```sql
{{ config(severity='error') }}  -- blocks the pipeline
{{ config(severity='warn') }}   -- flags it, keeps going
```

Use `error` for violations that should never happen (corrupted PKs, impossible values).
Use `warn` for patterns that are unusual but may be intentional (like promotional discounts exceeding face value).

## Naming convention
Always prefix with `assert_` to make it clear it's a test:
```
assert_coupon_not_greater_than_sales_price.sql
assert_net_profit_not_null.sql
assert_quantity_greater_than_zero.sql
```

## dbt commands
```bash
dbt test                                              # run all tests including singular
dbt test -s assert_coupon_not_greater_than_sales_price  # run one singular test
```

## Generic vs Singular — comparison
| | Generic tests | Singular tests |
|---|---|---|
| Where defined | `schema.yml` | `.sql` file in `tests/` |
| Reusable | Yes | No — one specific case |
| What they check | Structure (nulls, dupes, values, FKs) | Business rules |
| Example | `not_null` on `customer_sk` | coupon ≤ sales price |

## Common mistakes
- Forgetting `{{ ref() }}` — always reference models through ref(), never hardcode table names
- Writing the logic backwards — the query should return **violating** rows, not valid rows
- Setting everything to `error` — investigate frequency before deciding severity
