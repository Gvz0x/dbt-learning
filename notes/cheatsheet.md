# dbt Cheat Sheet

*Built incrementally — add to this as new concepts are covered.*

---

## Commands

```bash
dbt run              # build all models
dbt run -s my_model  # build one model
dbt run -s staging.* # build all models in the staging folder
dbt test             # run all tests
dbt test -s my_model # test one model
dbt build            # run + test together (recommended)
dbt compile          # generate SQL without running it
dbt source freshness # check if source tables are stale
dbt docs generate    # build the documentation site
dbt docs serve       # open docs in browser (port 8080)
dbt clean            # delete the target/ and dbt_packages/ folders
dbt debug            # test your Snowflake connection
```

---

## Configurations vs Properties

| | What it is | Where it lives |
|---|---|---|
| **Config** | How dbt builds the model | `dbt_project.yml`, `schema.yml`, `.sql` config block |
| **Property** | Metadata — descriptions + tests | `schema.yml` only |

Override hierarchy (highest to lowest priority):
```
SQL config block  >  schema.yml  >  dbt_project.yml
```

---

## Materializations

| Type | Creates | Use when |
|------|---------|----------|
| `view` | SQL view | lightweight, default for staging |
| `table` | physical table | queried often, joins/aggregations |
| `incremental` | appends new rows | large tables, event data |
| `ephemeral` | CTE only, no DB object | intermediate logic, not standalone |

Set in model:
```sql
{{ config(materialized='table') }}
```

Set in dbt_project.yml (applies to whole folder):
```yaml
models:
  my_project:
    staging:
      +materialized: view
    marts:
      +materialized: table
```

---

## Jinja Functions

```sql
{{ ref('model_name') }}          -- reference another model (builds DAG)
{{ source('source', 'table') }}  -- reference a raw source table
{{ config(materialized='table') }} -- set model config inline
{{ var('my_var') }}              -- use a project variable
{{ doc('block_name') }}          -- reference a doc block (in schema.yml descriptions)
```

---

## Doc Blocks

Define in any `.md` file inside `models/`:
```markdown
{% docs customer_id %}
The unique identifier for a customer.
{% enddocs %}
```

Reference in `schema.yml`:
```yaml
- name: customer_id
  description: "{{ doc('customer_id') }}"
```

---

## Tests (in schema.yml)

```yaml
columns:
  - name: my_column
    tests:
      - unique
      - not_null
      - accepted_values:
          values: ['Y', 'N']
      - relationships:
          to: ref('other_model')
          field: foreign_key_column
```

---

## schema.yml Structure

```yaml
version: 2

models:
  - name: model_name
    description: "What this model does."
    columns:
      - name: column_name
        description: "What this column contains."
        tests:
          - unique
          - not_null
```

---

## sources.yml Structure

```yaml
version: 2

sources:
  - name: source_alias        # used in {{ source('alias', 'table') }}
    database: MY_DATABASE
    schema: MY_SCHEMA
    tables:
      - name: my_table
        description: "Raw table description."
```

---

## Jinja & Macros

Define in `macros/my_macro.sql`:
```sql
{% macro yn_to_boolean(column_name) %}
    case
        when {{ column_name }} = 'Y' then true
        when {{ column_name }} = 'N' then false
        else null
    end
{% endmacro %}
```

Call in any model:
```sql
{{ yn_to_boolean('channel_email') }} as channel_email
```

| Syntax | Purpose |
|--------|---------|
| `{{ }}` | Output a value (expressions, macro calls) |
| `{% %}` | Control flow (if, for, macro definitions) |

---

## Incremental Models

Config block:
```sql
{{ config(
    materialized='incremental',
    unique_key='funnel_id'
) }}
```

Incremental filter pattern (in the CTE with the date column):
```sql
{% if is_incremental() %}
    where sold_date_sk > (select max(sold_date_sk) from {{ this }})
{% endif %}
```

```bash
dbt run -s fct_funnel                    # incremental run (new rows only)
dbt run -s fct_funnel --full-refresh     # drop and rebuild entire table
```

---

## Packages

```bash
dbt deps   # install packages from packages.yml (like pip install)
```

`packages.yml` (project root):
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
```

`dbt_utils` macros:
```sql
-- Surrogate key from multiple columns (first column in SELECT)
{{ dbt_utils.generate_surrogate_key(['order_number', 'item_sk']) }} as funnel_id
```

`dbt_utils` tests in schema.yml:
```yaml
- name: net_paid
  tests:
    - dbt_utils.expression_is_true:
        arguments:
          expression: ">= 0"    # column name injected automatically
        severity: warn
```

---

## seeds

```bash
dbt seed              # load all CSVs in seeds/ into Snowflake
dbt seed -s my_file   # load one seed file
```

Reference in a model:
```sql
select * from {{ ref('my_seed_file') }}
```

---

## macros

Define in `macros/my_macro.sql`:
```sql
{% macro cents_to_dollars(column_name) %}
    ({{ column_name }} / 100)::decimal(10, 2)
{% endmacro %}
```

Use in a model:
```sql
select {{ cents_to_dollars('sales_price') }} as sales_price_usd
```

---

## analyses

SQL files in `analyses/` that use `ref()` but don't materialize. Compile with:
```bash
dbt compile
```
Output appears in `target/compiled/`.

---

## Snapshots (SCD Type 2)

Tracks how rows change over time. Defined in `snapshots/`:
```sql
{% snapshot snap_customers %}
{{ config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='check',
    check_cols=['email', 'first_name']
) }}
select * from {{ source('raw', 'customers') }}
{% endsnapshot %}
```

Run with: `dbt snapshot`
