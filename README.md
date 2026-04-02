# dbt Learning Journey — Gio

A hands-on dbt project built while learning analytics engineering from scratch. This repo contains the working dbt project, structured concept notes, and exercises for every topic covered.

**Stack:** dbt 1.11.7 · Snowflake · Python 3.11.9
**Data source:** `SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL` (Snowflake's built-in TPC-DS dataset)

---

## Pipeline

```
SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL (raw)
         |
         ├── customer ──────────► stg_customers     (view)
         ├── web_sales ─────────► stg_web_sales     (view, filtered to 2003)
         └── promotion ─────────► stg_promotions    (view)
                                        |
                               int_web_sales_enriched  (ephemeral — no DB object)
                                        |
                                   fct_funnel        (table, 15.7M rows)
```

---

## Learning Progress

### Completed
| # | Concept | Note | Exercise |
|---|---------|------|----------|
| 01 | What dbt is and where it fits | [note](notes/01_what_is_dbt.md) | — |
| 02 | Project structure | [note](notes/02_project_structure.md) | — |
| 03 | Models & materializations | [note](notes/03_models_and_materializations.md) | [ex](notes/exercises/ex_03_models_and_materializations.md) |
| 04 | ref() and the DAG | [note](notes/04_ref_and_dag.md) | [ex](notes/exercises/ex_04_ref_and_dag.md) |
| 05 | Sources | [note](notes/05_sources.md) | [ex](notes/exercises/ex_05_sources.md) |
| 06 | Staging & marts layer pattern | [note](notes/06_staging_and_marts.md) | [ex](notes/exercises/ex_06_staging_and_marts.md) |
| 07 | Generic tests | [note](notes/07_tests.md) | [ex](notes/exercises/ex_07_tests.md) |
| 08 | Documentation | [note](notes/08_documentation.md) | [ex](notes/exercises/ex_08_documentation.md) |
| 09 | Singular tests | [note](notes/09_singular_tests.md) | [ex](notes/exercises/ex_09_singular_tests.md) |
| 10 | Doc blocks | [note](notes/10_doc_blocks.md) | [ex](notes/exercises/ex_10_doc_blocks.md) |
| 11 | Ephemeral materialization | [note](notes/11_ephemeral_materialization.md) | — |

### Up Next
- Configurations vs properties
- Seeds
- Packages (dbt-utils)
- Incremental models
- Jinja & Macros
- Snapshots
- Jobs & deployment
- Semantic Layer (MetricFlow, metrics, saved queries)

Full roadmap: [session_progress.md](notes/session_progress.md)

---

## Code Quality Standards

All code in this project is held to the following non-negotiable standards:

- No `select *` as final model output — explicit column lists only
- No hardcoded database/schema paths — `source()` and `ref()` only
- No staging models with joins or aggregations
- Generic tests: every primary key column has `unique` + `not_null`
- Test syntax uses `arguments:` nesting (not deprecated flat syntax)
- No credentials or secrets in tracked files
- All models have descriptions in `schema.yml`

---

## What to Review

| Area | Location |
|------|----------|
| dbt models (SQL) | [`learn_dbt/models/`](learn_dbt/models/) |
| Generic tests & column descriptions | [`learn_dbt/models/staging/schema.yml`](learn_dbt/models/staging/schema.yml) |
| Singular tests | [`learn_dbt/tests/`](learn_dbt/tests/) |
| Doc blocks | [`learn_dbt/models/staging/docs.md`](learn_dbt/models/staging/docs.md) |
| Concept notes | [`notes/`](notes/) |
| Exercises | [`notes/exercises/`](notes/exercises/) |
| Session progress & roadmap | [`notes/session_progress.md`](notes/session_progress.md) |
| Cheat sheet | [`notes/cheatsheet.md`](notes/cheatsheet.md) |

---

## Running the Project

```bash
# Activate virtual environment
source ~/Dbt/learn_dbt/.venv/bin/activate

# Test connection
dbt debug

# Build all models
dbt build

# Run tests only
dbt test

# Generate and serve docs
dbt docs generate && dbt docs serve
```

Requires a Snowflake account with access to `SNOWFLAKE_SAMPLE_DATA`. Credentials are stored locally in `~/.dbt/profiles.yml` and `~/Dbt/.env` — not committed to this repo.
