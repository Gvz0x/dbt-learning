with source as (

    select * from {{ source('tpcds', 'web_sales') }}
    where ws_sold_date_sk in (
        select d_date_sk
        from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.DATE_DIM
        where d_year = 2003
    )

),

renamed as (

    select
        ws_order_number              as order_number,
        ws_sold_date_sk              as sold_date_sk,
        ws_bill_customer_sk          as customer_sk,
        ws_promo_sk                  as promo_sk,
        ws_quantity                  as quantity,
        ws_sales_price               as sales_price,
        ws_net_paid                  as net_paid,
        ws_net_profit                as net_profit,
        ws_coupon_amt                as coupon_amount,
        ws_ext_discount_amt          as discount_amount

    from source

)

select * from renamed
