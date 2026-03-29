with source as (

    select * from {{ source('tpcds', 'promotion') }}

),

renamed as (

    select
        p_promo_sk                   as promo_sk,
        p_promo_id                   as promo_id,
        p_promo_name                 as promo_name,
        p_cost                       as promo_cost,
        p_purpose                    as promo_purpose,
        p_channel_email              as channel_email,
        p_channel_tv                 as channel_tv,
        p_channel_radio              as channel_radio,
        p_channel_catalog            as channel_catalog,
        p_channel_dmail              as channel_direct_mail,
        p_discount_active            as is_discount_active

    from source

)

select
    promo_sk,
    promo_id,
    promo_name,
    promo_cost,
    promo_purpose,
    channel_email,
    channel_tv,
    channel_radio,
    channel_catalog,
    channel_direct_mail,
    is_discount_active
from renamed
