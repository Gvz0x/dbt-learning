# Learning Session Progress

## Where We Left Off
Completed a full learning environment overhaul. Ready to start **Tests** next session.

## What Has Been Built

### Project: `learning_dbt`
Location: `Documents/dbt-projects/learning_dbt/`

### Models
| Model | Type | Location | Purpose |
|-------|------|----------|---------|
| `stg_customers` | view | `models/staging/` | Cleans raw CUSTOMER table |
| `stg_web_sales` | view | `models/staging/` | Cleans raw WEB_SALES table (filtered to 2003) |
| `stg_promotions` | view | `models/staging/` | Cleans raw PROMOTION table |
| `fct_funnel` | table | `models/marts/` | Joins all three staging models — 15.7M rows |

### Schema files (added this session)
| File | Purpose |
|------|---------|
| `models/staging/schema.yml` | Tests + descriptions for all 3 staging models |
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
- [x] The `ref()` function — how models depend on each other
- [x] Sources — declaring raw Snowflake tables in `sources.yml`
- [x] Staging layer — cleaning and renaming raw columns
- [x] Marts layer — joining staging models into a final output
- [x] Compiling — what `dbt compile` does and when to use it
- [x] Build workflow — write → compile → run -s → query → test loop

## Up Next
- [ ] Tests — not_null, unique, accepted_values, relationships (schema.yml already scaffolded and ready)
- [ ] Documentation — descriptions + `dbt docs serve`

## Environment (updated this session)
- Shared venv at `dbt-projects/shared-venv/` — used by all projects
- Credentials in `dbt-projects/.env` — no longer hardcoded in scripts
- Auto-activates venv via hook in `learning_dbt/.claude/settings.json`
- `/dbt-learn` slash command in `~/.claude/commands/dbt-learn.md`
- `dbt-learn` shell function in `~/.bashrc` updated to use shared venv

## Folder Structure
```
dbt-projects/
├── learning_dbt/      ← permanent concept sandbox
├── experiments/       ← throwaway projects (one per concept)
├── projects/          ← real projects you plan to keep
├── airflow/dags/      ← Airflow DAGs (for later)
├── shared-venv/       ← one Python venv for all dbt projects
├── notes/             ← learning notes, cheatsheet, session progress
├── .env               ← Snowflake credentials (never commit)
└── new_project.sh     ← scaffolding script (reads from .env)
```

## Notes
- `fct_funnel` was switched from view to table after seeing query times >2 mins
- Filtered `stg_web_sales` to 2003 only (15.7M rows vs 1.4B per year for other years)
- Example models (`my_first_dbt_model`, `my_second_dbt_model`) still in project but not part of the funnel
- After reloading shell (`source ~/.bashrc`), `newdbt` now asks experiments vs projects and uses shared venv
