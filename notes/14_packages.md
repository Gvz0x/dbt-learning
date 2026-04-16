# 14 — Packages (dbt-utils)

## What it is
A package is a collection of pre-built macros and tests shared by the dbt community. You declare dependencies in `packages.yml` and install them with `dbt deps`. The most widely used package is `dbt-utils` by dbt Labs.

## Why it exists
Avoids rewriting common logic (surrogate keys, expression tests, date spines) from scratch in every project. Packages are versioned and tested — you get reliable, consistent SQL generated for you.

## How to install

Create `packages.yml` at the project root (next to `dbt_project.yml`):
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
```

Then run:
```bash
dbt deps
```

This downloads packages into `dbt_packages/` and creates `package-lock.yml`. Never edit `dbt_packages/` — it's like `node_modules/`.

---

## generate_surrogate_key

Hashes a list of columns into a single MD5 surrogate key. Use it when no single column is a unique identifier and you need to create one from a combination of columns.

### In fct_funnel:
```sql
select
    {{ dbt_utils.generate_surrogate_key(['order_number', 'item_sk']) }} as funnel_id,
    ...
```

Compiles to:
```sql
md5(cast(
    coalesce(cast(order_number as TEXT), '_dbt_utils_surrogate_key_null_') || '-' ||
    coalesce(cast(item_sk as TEXT), '_dbt_utils_surrogate_key_null_')
as TEXT)) as funnel_id
```

- Handles NULLs safely via `coalesce` — a null column won't produce a null key
- Always produces the same output for the same input (deterministic)
- Always put the surrogate key as the first column in the SELECT

### Tests to add in schema.yml:
```yaml
- name: funnel_id
  tests:
    - unique
    - not_null
```

---

## expression_is_true

A generic test that asserts a SQL expression is true for every row. Defined in `schema.yml` — no separate `.sql` file needed.

### Syntax (column-level):
```yaml
- name: net_paid
  tests:
    - dbt_utils.expression_is_true:
        arguments:
          expression: ">= 0"
        severity: warn
```

When defined on a column, dbt injects the column name — write only the operator and value, not the full expression.

### vs singular tests:
| | expression_is_true | singular test |
|---|---|---|
| Lives in | schema.yml | tests/ folder (.sql file) |
| Good for | simple single-column assertions | complex logic, joins to other models |
| Syntax | operator only (`">= 0"`) | full SQL query |

## Gotchas
- Arguments must be nested under `arguments:` — top-level args trigger a deprecation warning
- When used on a column, do NOT repeat the column name in the expression (`">= 0"` not `"net_paid >= 0"`)
- `dbt_packages/` should be in `.gitignore` — it's generated, not source code
