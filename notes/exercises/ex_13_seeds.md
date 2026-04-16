# Exercise 13 — Seeds

## Goal
Practice creating a seed, loading it into Snowflake, and joining it to an existing model.

---

## Task

The marketing team has given you a new mapping: each promotion channel should be classified by reach tier.

1. Create a seed file at `seeds/channel_reach_tiers.csv` with the following data:

```
channel,reach_tier
email,Low
tv,High
radio,Mid
catalog,Mid
direct_mail,Low
```

2. Load it into Snowflake with the correct dbt command.

3. Verify it loaded correctly by querying it in Snowflake.

4. Reference it in `fct_funnel.sql` and join it on `channel_email` — wait, that won't work directly. Think about why, and what you would need to do differently to use this seed with the current model structure.

---

## Bonus question
After fixing a seed CSV (e.g. removing trailing spaces), what two commands do you need to run to get a downstream table to reflect the fix? In what order?
