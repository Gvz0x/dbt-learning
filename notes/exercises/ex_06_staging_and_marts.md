# Exercise 06 — Staging & Marts

## Exercise 1
What is the only job of a staging model? List two things it should NOT do.

## Exercise 2
Why are staging models materialized as views and mart models as tables?

## Exercise 3
A teammate wrote this staging model. What is wrong with it?

```sql
-- stg_web_sales_with_customers.sql
with source as (
    select * from {{ source('tpcds', 'web_sales') }}
),

joined as (
    select
        ws.ws_order_number  as order_number,
        c.c_first_name      as first_name
    from source ws
    join {{ ref('stg_customers') }} c on ws.ws_bill_customer_sk = c.customer_sk
)

select * from joined
```

## Exercise 4
What naming convention do staging and mart models follow? Give an example of each from your project.

## Exercise 5
If you had a new source table called `returns` that you wanted to add to your funnel, what steps would you take? List them in order.
