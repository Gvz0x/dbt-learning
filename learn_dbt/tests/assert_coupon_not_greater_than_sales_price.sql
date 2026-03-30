{{ config(severity='warn') }}

select *
from {{ ref('fct_funnel') }}
where coupon_amount > sales_price