# Exercise 10 — Doc Blocks

## Goal
Add doc blocks for two more columns that appear in multiple models.

## Tasks

### 1. Add a doc block for `promo_sk`
- Define it in `models/staging/docs.md`
- Description: the surrogate key for a promotion, sourced from the raw PROMOTION table
- Reference it in `models/staging/schema.yml` under `stg_promotions.promo_sk`
- Reference it again in `models/staging/schema.yml` under `stg_web_sales.promo_sk`

### 2. Add a doc block for `customer_sk`
- Define it in `models/staging/docs.md`
- Description: the surrogate key for a customer, sourced from the raw CUSTOMER table
- Reference it in `models/staging/schema.yml` under `stg_customers.customer_sk`
- Reference it again in `models/staging/schema.yml` under `stg_web_sales.customer_sk`

### 3. Verify
Run `dbt docs generate` — it must succeed with no errors.
Then run `dbt docs serve` and confirm both columns show the correct descriptions in the docs UI.

## Success criteria
- `docs.md` has 3 doc blocks total (customer_id + promo_sk + customer_sk)
- `schema.yml` references (not inline text) for all 3 columns across all relevant models
- `dbt docs generate` exits with no errors
