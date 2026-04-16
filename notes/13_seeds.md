# 13 — Seeds

## What it is
A seed is a CSV file that dbt loads into your warehouse as a table. It lives in the `seeds/` folder of your project.

## Why it exists
Some reference data doesn't come from a source system — it lives in a spreadsheet or is maintained manually. Seeds let you version-control that data alongside your dbt project and load it into the warehouse with one command.

## When to use a seed vs a source
- **Seed** — small, static, manually maintained data (lookup tables, mappings, business rules)
- **Source** — data that comes from an external system and changes over time

Rule of thumb: if someone could reasonably update it in a spreadsheet, it's a seed.

## How to use it

1. Create a CSV file in `seeds/` (e.g. `seeds/promo_budget_tiers.csv`):
```
promo_purpose,budget_tier
Price Reduction,High
Promotion,Mid
Unknown,Low
```

2. Load it into Snowflake:
```
dbt seed
```

3. Reference it in a model using `ref()` — exactly like any other model:
```sql
budget_tiers as (
    select * from {{ ref('promo_budget_tiers') }}
)
```

4. Join it like any table:
```sql
left join budget_tiers b on p.promo_purpose = b.promo_purpose
```

## Real example from this project
`promo_budget_tiers.csv` maps promotion purposes to budget tiers (Low/Mid/High). It was joined onto `fct_funnel` via `promo_purpose` to add a `budget_tier` column to all 15.7M rows.

## dbt commands
| Command | What it does |
|---------|-------------|
| `dbt seed` | Loads all CSV files in `seeds/` into the warehouse as tables |
| `dbt seed -s promo_budget_tiers` | Loads a specific seed only |

## Gotchas
- **Trailing spaces in CSV values will silently break joins.** The join condition fails with no error — you just get nulls. Always check `length()` if a join isn't matching.
- `NULL` in the join column never matches anything — not even another `NULL`. Rows with null `promo_purpose` will always have null `budget_tier`.
- Seeds are materialized as tables, not views.
- After fixing a seed CSV, you must run both `dbt seed` AND `dbt run -s <model>` to rebuild any downstream tables that reference it.
- `Unknown` and `null` are different things. `Unknown` is a real value someone wrote; `null` means no value at all.
