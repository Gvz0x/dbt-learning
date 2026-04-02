# Doc Blocks

## What it is
A doc block is a named chunk of Markdown text defined in a `.md` file and referenced in `schema.yml` using the `doc()` Jinja function.

## Why it exists
Without doc blocks, you repeat the same column description across multiple `schema.yml` files (staging, marts, etc.). If the description changes, you have to update every file — and if you miss one, your docs drift out of sync. Doc blocks give you a single source of truth.

## How to use it

### 1. Create a `.md` file in your models folder
Convention: `models/staging/docs.md`

```markdown
{% docs customer_id %}
The unique identifier for a customer, sourced from the raw CUSTOMER table.
{% enddocs %}
```

### 2. Reference it in `schema.yml`
```yaml
- name: customer_id
  description: "{{ doc('customer_id') }}"
```

### 3. Generate docs to verify
```
dbt docs generate
dbt docs serve
```

## Real example from this project
- Doc block defined in `models/staging/docs.md`
- Referenced in `models/staging/schema.yml` under `stg_customers.customer_id`
- The same `{{ doc('customer_id') }}` reference can be added to `models/marts/schema.yml` for `fct_funnel` — both will show the same description

## dbt commands
```
dbt docs generate   # compiles docs + doc blocks into catalog.json
dbt docs serve      # serves the docs site locally
```

## Common mistakes
- Using `{% docs customer_id %}` in schema.yml instead of `{{ doc('customer_id') }}` — the definition syntax and reference syntax are different
- Typo in the block name — if `doc('customer_id')` doesn't match `{% docs customer_id %}` exactly, dbt errors at generate time
- Forgetting the quotes around the argument: `doc(customer_id)` is invalid, must be `doc('customer_id')`
