{{ config(materialized='ephemeral') }}                                                                                                    
                                                                                                                                      
  with web_sales as (                                                                                                                 
      select * from {{ ref('stg_web_sales') }}                                                                                                  
  ),                                          
                                                                                                                                      
  promotions as ( 
      select * from {{ ref('stg_promotions') }}                                                                                                  
  ),
                                                                                                                                      
  joined as (     
      select
          web_sales.customer_sk,
          web_sales.sold_date_sk,
          web_sales.promo_sk,
          promotions.promo_id,
          promotions.promo_name
      from web_sales                      
      left join promotions                                                                                                            
          on web_sales.promo_sk = promotions.promo_sk                                                                                           
  )
                                                                                                                                      
  select
      customer_sk,                                                                                                                    
      sold_date_sk,                                                                                                                   
      promo_sk,                                                                                                                       
      promo_id,                                                                                                                       
      promo_name  
  from joined                