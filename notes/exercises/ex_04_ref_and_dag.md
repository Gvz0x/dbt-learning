# Exercise 04 — ref() and the DAG

## Exercise 1
What does DAG stand for and what does it represent in dbt?

## Exercise 2
If you replaced `{{ ref('stg_customers') }}` with the hardcoded table name `dbt_database.learning_dbt.stg_customers` in `fct_funnel.sql`, what are the two things that would break?

## Exercise 3
Draw the DAG for your project. Which models run first and why?

## Exercise 4
If someone added a new model `dim_dates.sql` that referenced `stg_web_sales`, where would it sit in the DAG? Draw it.

## Exercise 5
What does `dbt compile -s fct_funnel` show you and when would you use it?
