# Exercise 15 — Incremental Models

## Exercise 1 — Understand the compiled SQL

Run:
```bash
dbt compile -s fct_funnel
```

Look at the output. Find where `is_incremental()` would inject the filter. Notice it's not there — why? (Hint: compile doesn't know if the table exists.)

---

## Exercise 2 — Simulate an incremental run

1. Run `dbt run -s fct_funnel --full-refresh` — note the row count and time
2. Run `dbt run -s fct_funnel` again immediately — note the row count and time
3. Explain the difference in your own words

---

## Exercise 3 — Change the strategy

Change `fct_funnel` to use `incremental_strategy='delete+insert'`. Run with `--full-refresh`.

Then change it back to the default (remove the strategy line). Run `--full-refresh` again.

What difference did you notice in the output?

---

## Questions to answer before moving on

1. What does `{{ this }}` refer to in the incremental filter?
2. Why do you need a `unique_key`? What happens without one?
3. When would you use `--full-refresh` in a production pipeline?
4. Why is `is_incremental()` better than just hardcoding a date filter?
