# Learning Session Progress

## Where We Left Off
Completed Tests. Ready to start **Documentation** next session.

## What Has Been Built

### Project: `learning_dbt`
Location: `~/dbt-learning/learning_dbt/`

### Models
| Model | Type | Location | Purpose |
|-------|------|----------|---------|
| `stg_customers` | view | `models/staging/` | Cleans raw CUSTOMER table |
| `stg_web_sales` | view | `models/staging/` | Cleans raw WEB_SALES table (filtered to 2003) |
| `stg_promotions` | view | `models/staging/` | Cleans raw PROMOTION table |
| `fct_funnel` | table | `models/marts/` | Joins all three staging models — 15.7M rows |

### Tests (13 total, all passing)
| Test | Column | Model |
|------|--------|-------|
| `not_null` | order_number | fct_funnel |
| `not_null` | sold_date_sk | fct_funnel |
| `not_null` | customer_id | stg_customers |
| `not_null` | customer_sk | stg_customers |
| `unique` | customer_sk | stg_customers |
| `accepted_values` | is_preferred_customer | stg_customers |
| `not_null` | order_number | stg_web_sales |
| `relationships` | customer_sk | stg_web_sales → stg_customers |
| `not_null` | promo_id | stg_promotions |
| `not_null` | promo_sk | stg_promotions |
| `unique` | promo_sk | stg_promotions |
| `accepted_values` | channel_email | stg_promotions |
| `accepted_values` | is_discount_active | stg_promotions |

### Schema files
| File | Purpose |
|------|---------|
| `models/staging/schema.yml` | Tests + descriptions for all 3 staging models |
| `models/staging/sources.yml` | Declares raw Snowflake source tables incl. date_dim |
| `models/marts/schema.yml` | Tests + descriptions for fct_funnel |

### Data Source
`SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL` — Snowflake's built-in sample dataset.
`stg_web_sales` is filtered to year 2003 only to keep the table build fast.

### Pipeline
```
SNOWFLAKE_SAMPLE_DATA (raw)
        ↓
stg_customers  stg_web_sales  stg_promotions   ← views (staging)
        ↓              ↓              ↓
              fct_funnel                        ← table (mart, 15.7M rows)
```

## Concepts Covered
- [x] What dbt is and where it fits in the data stack
- [x] Project structure (all folders and files)
- [x] Models — SELECT statements that become Snowflake objects
- [x] Materializations — view vs table (and why it matters for performance)
- [x] The `ref()` function — how models depend on each other (DAG)
- [x] Sources — declaring raw Snowflake tables in `sources.yml`
- [x] Staging layer — cleaning and renaming raw columns
- [x] Marts layer — joining staging models into a final output
- [x] Compiling — what `dbt compile` does and when to use it
- [x] Build workflow — write → compile → run -s → query → test loop
- [x] Tests — not_null, unique, accepted_values, relationships

## Up Next
- [ ] Documentation — descriptions + `dbt docs serve`

## Environment
- pyenv Python 3.11.9
- Per-project venv at `~/dbt-learning/.venv/`
- Credentials in `~/dbt-learning/.env` — never committed
- `dbt-learn` shell shortcut in `~/.zshrc`
- `newdbt` shell shortcut in `~/.zshrc` for scaffolding new projects

## Notes
- `fct_funnel` switched from view to table after seeing query times >2 mins
- Filtered `stg_web_sales` to 2003 only (15.7M rows vs 1.4B per year)
- Example scaffold models deleted — they were dbt init boilerplate, not real models
- Fixed 3 code quality issues: hardcoded paths, select *, deprecated test syntax
