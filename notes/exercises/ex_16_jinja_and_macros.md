# Exercise 16 — Jinja & Macros

## Exercise 1 — Write a new macro

Create `macros/cents_to_dollars.sql`. Write a macro that takes a column name and divides it by 100, cast to `decimal(10, 2)`.

Use it in `fct_funnel` on `sales_price`, `net_paid`, and `net_profit`.

Run `dbt compile -s fct_funnel` to verify the output before running.

---

## Exercise 2 — Inspect the macro count

Run `dbt run -s fct_funnel` and look at the line:
```
Found 5 models, 18 data tests, 1 seed, 4 sources, 640 macros
```

Where do those 640 macros come from? (Hint: most are not yours.)

---

## Exercise 3 — Add a default argument

Modify `yn_to_boolean` to accept an optional second argument `true_value` that defaults to `'Y'`:

```sql
{% macro yn_to_boolean(column_name, true_value='Y') %}
```

Update the `case when` to use `{{ true_value }}` instead of hardcoded `'Y'`.

Test it still works in `fct_funnel`.

---

## Questions to answer before moving on

1. What's the difference between `{{ }}` and `{% %}` in Jinja?
2. Why did we need `--full-refresh` after adding the macro to `fct_funnel`?
3. Where can macros be called — only in marts, or anywhere?
