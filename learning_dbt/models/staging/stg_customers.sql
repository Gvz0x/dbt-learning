with source as (

    select * from {{ source('tpcds', 'customer') }}

),

renamed as (

    select
        c_customer_sk                as customer_sk,
        c_customer_id                as customer_id,
        c_first_name                 as first_name,
        c_last_name                  as last_name,
        c_email_address              as email,
        c_birth_year                 as birth_year,
        c_preferred_cust_flag        as is_preferred_customer,
        c_birth_country              as birth_country

    from source

)

select * from renamed
