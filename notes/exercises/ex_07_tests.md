# Exercise 07 — Tests

## Exercise 1
What are the 4 built-in dbt test types and what does each one check?

## Exercise 2
Write the `schema.yml` test block for a column called `promo_sk` that should be unique and never null:

```yaml
# your answer here
```

## Exercise 3
You have a column `payment_method` that should only ever contain `'credit'`, `'debit'`, or `'cash'`. Write the test for it:

```yaml
# your answer here
```

## Exercise 4
When would you use `severity: warn` instead of `severity: error`? Give a real example from your project.

## Exercise 5
Your `dbt test` run shows this failure:
```
Failure in test not_null_stg_customers_customer_sk
Got 3 results, configured to fail if != 0
```
What does this mean in plain English and what would you do next?
