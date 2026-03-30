# Exercise 03 — Models & Materializations

## Exercise 1
Look at `stg_customers.sql`. What materialization is it using and where is that set?

## Exercise 2
Without running anything — if you changed `fct_funnel` from a `table` to a `view` in `dbt_project.yml`, what would be the impact on query performance for someone running reports on it? Why?

## Exercise 3
In `stg_web_sales.sql`, there are two CTEs: `source` and `renamed`. What is the purpose of each? What would break if you combined them into one?

## Exercise 4
Write the config block you would add to a model if you wanted to override the folder-level materialization and force it to be a table:

```sql
-- your answer here
```

## Exercise 5
Which of these is correct and why?

**Option A:**
```sql
select * from renamed
```

**Option B:**
```sql
select
    customer_sk,
    first_name,
    last_name
from renamed
```
