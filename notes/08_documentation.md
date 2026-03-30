# 08 — Documentation

## What it is
dbt auto-generates a documentation website from the descriptions written in your `schema.yml` files. It includes every model, column, test, and a visual lineage graph.

## Why it exists
SQL files alone don't explain intent. Documentation makes the project understandable to teammates, stakeholders, and your future self — without anyone having to read raw SQL.

## Where the content comes from
Descriptions you write in `schema.yml`:

```yaml
models:
  - name: fct_funnel
    description: >
      Marketing funnel fact table. Joins web sales with customer and promotion
      dimensions. Contains one row per web sale line item for the year 2003.
    columns:
      - name: order_number
        description: "Web order number. One order can have multiple line items."
```

dbt pulls all of this into the generated site automatically.

## What the docs site shows
- **Project explorer** — every model, source, column and description
- **Test coverage** — which columns have tests
- **Lineage graph** — visual DAG showing how models connect
- **Compiled SQL** — the actual SQL dbt runs for each model

## dbt commands
```bash
dbt docs generate    # builds the docs (creates target/catalog.json)
dbt docs serve       # opens the site at http://localhost:8080
```

Always run `dbt docs generate` before `dbt docs serve` — generate builds it, serve opens it.

Press `Ctrl+C` to stop the server.

## Common mistakes
- Running `dbt docs serve` without running `dbt docs generate` first — shows stale or empty docs
- Leaving descriptions empty in `schema.yml` — the site exists but has no useful content
- Not documenting marts — staging docs are good, but marts are what stakeholders see
