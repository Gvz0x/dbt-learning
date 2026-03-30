# Exercise 09 — Singular Tests

## Exercise 1
What is the difference between a generic test and a singular test? Give one example of each from your project.

## Exercise 2
A singular test returns 500 rows. Did it pass or fail? What does that mean in plain English?

## Exercise 3
Write a singular test that checks `quantity` in `fct_funnel` is never zero or negative:

```sql
-- tests/assert_quantity_greater_than_zero.sql
-- your answer here
```

## Exercise 4
You ran a singular test and it found 50,000 violations out of 15M rows. Should you set severity to `error` or `warn`? Explain your reasoning.

## Exercise 5
What is wrong with this singular test?

```sql
select *
from fct_funnel
where net_profit > 0
```

There are two mistakes — find both.
