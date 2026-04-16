  {{ config(
      materialized='incremental',
      unique_key='funnel_id'
  ) }}

with web_sales as (

    select * from {{ ref('stg_web_sales') }}

    {% if is_incremental() %}
          where sold_date_sk > (select max(sold_date_sk) from {{ this }})
    {% endif %}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

promotions as (

    select * from {{ ref('stg_promotions') }}

),

budget_tiers as (

    select * from {{ ref('promo_budget_tiers') }}

),

joined as (

    select
        -- promotion details
        p.promo_id,
        p.promo_name,
        p.promo_purpose,
        p.promo_cost,
        p.channel_email,
        p.channel_tv,
        p.channel_radio,
        p.channel_direct_mail,
        p.is_discount_active,
        b.budget_tier,

        -- customer details
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.is_preferred_customer,

        -- sale details
        s.order_number,
        s.item_sk,
        s.sold_date_sk,
        s.quantity,
        s.sales_price,
        s.net_paid,
        s.net_profit,
        s.coupon_amount,
        s.discount_amount

    from web_sales s
    left join customers  c on s.customer_sk = c.customer_sk
    left join promotions p on s.promo_sk    = p.promo_sk
    left join budget_tiers b on p.promo_purpose = b.promo_purpose

)

select
    -- surrogate key
   {{ dbt_utils.generate_surrogate_key(['order_number', 'item_sk']) }} as funnel_id,

    -- promotion details
    promo_id,
    promo_name,
    promo_purpose,
    promo_cost,
    channel_email,
    channel_tv,
    channel_radio,
    channel_direct_mail,
    is_discount_active,
    budget_tier,

    -- customer details
    customer_id,
    first_name,
    last_name,
    email,
    is_preferred_customer,

    -- sale details
    order_number,
    item_sk,
    sold_date_sk,
    quantity,
    sales_price,
    net_paid,
    net_profit,
    coupon_amount,
    discount_amount
from joined
