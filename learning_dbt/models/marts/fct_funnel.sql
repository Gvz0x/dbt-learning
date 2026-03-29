with web_sales as (

    select * from {{ ref('stg_web_sales') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

promotions as (

    select * from {{ ref('stg_promotions') }}

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

        -- customer details
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.is_preferred_customer,

        -- sale details
        s.order_number,
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

)

select
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

    -- customer details
    customer_id,
    first_name,
    last_name,
    email,
    is_preferred_customer,

    -- sale details
    order_number,
    sold_date_sk,
    quantity,
    sales_price,
    net_paid,
    net_profit,
    coupon_amount,
    discount_amount
from joined
