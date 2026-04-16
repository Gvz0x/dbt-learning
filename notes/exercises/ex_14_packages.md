# Exercise 14 — Packages (dbt-utils)

## Setup
Make sure `dbt deps` has been run and `dbt_packages/` exists.

---

## Exercise 1 — Install a second package

Add `dbt-labs/dbt_expectations` version `0.10.0` to `packages.yml` and run `dbt deps`.

Check `dbt_packages/` to confirm both packages installed.

Then remove it — we don't need it. Run `dbt deps` again to clean up.

---

## Exercise 2 — Surrogate key on stg_promotions

`stg_promotions` has `promo_sk` as its primary key — that's a raw surrogate key from the source system.

Add a dbt-generated surrogate key called `promo_id_sk` using `generate_surrogate_key` on `['promo_sk', 'promo_id']`. Add it as the first column.

Add `unique` + `not_null` tests for it in `schema.yml`.

Run and test:
```bash
dbt run -s stg_promotions
dbt test -s stg_promotions
```

---

## Exercise 3 — expression_is_true test

Add an `expression_is_true` test to `fct_funnel` asserting that `quantity > 0`.

Use `severity: warn` since we don't want to block the pipeline if this fails.

Run `dbt test -s fct_funnel` and confirm the test appears and passes.

---

## Questions to answer before moving on

1. Why use `generate_surrogate_key` instead of just using the existing `promo_sk` column?
2. What happens if one of the columns passed to `generate_surrogate_key` is NULL?
3. When would you use a singular test instead of `expression_is_true`?
