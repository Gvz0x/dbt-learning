# 16 — Jinja & Macros

## What it is
Jinja is a templating language built into dbt. Macros are reusable SQL functions written in Jinja — define once, call anywhere in your project.

## Why it exists
Avoids repeating the same SQL logic across multiple models. If the logic needs to change, you change it in one place.

## Jinja syntax types

| Syntax | Purpose |
|--------|---------|
| `{{ }}` | Output a value (expressions, macro calls) |
| `{% %}` | Control flow (if, for, macro definitions) |
| `{# #}` | Comments (not rendered in compiled SQL) |

You've used all of these:
- `{{ ref('stg_customers') }}` — expression
- `{% if is_incremental() %}` — control flow
- `{% macro ... %}` — macro definition

## Defining a macro

Lives in `macros/` folder as a `.sql` file:

```sql
{% macro yn_to_boolean(column_name) %}
    case
        when {{ column_name }} = 'Y' then true
        when {{ column_name }} = 'N' then false
        else null
    end
{% endmacro %}
```

- `column_name` is the argument (like a Python function parameter)
- `{{ column_name }}` injects the argument value into the SQL

## Calling a macro

In any model (staging, mart, CTE, anywhere):
```sql
{{ yn_to_boolean('channel_email') }} as channel_email
```

- Double curly braces `{{ }}`
- Column name passed as a string in quotes
- Alias it with `as`

## What dbt does at compile time

The macro call expands to full SQL:
```sql
case
    when channel_email = 'Y' then true
    when channel_email = 'N' then false
    else null
end as channel_email
```

Run `dbt compile -s model_name` to see the expanded SQL.

## In fct_funnel

Applied to all Y/N flag columns:
```sql
{{ yn_to_boolean('channel_email') }}      as channel_email,
{{ yn_to_boolean('channel_tv') }}         as channel_tv,
{{ yn_to_boolean('channel_radio') }}      as channel_radio,
{{ yn_to_boolean('channel_direct_mail') }} as channel_direct_mail,
{{ yn_to_boolean('is_discount_active') }} as is_discount_active,
{{ yn_to_boolean('is_preferred_customer') }} as is_preferred_customer,
```

## Gotchas
- After changing column types (Y/N → boolean), always `--full-refresh` the table
- Macro definition uses `{% macro %}`, calling uses `{{ }}`
- Macros can be called from any model — not just marts
- dbt counts your macros on each run — you'll see the count go up when you add one
