SELECT 
    order_key,
    total_gross_revenue,
    total_net_amount
FROM 
    {{ ref('int_orders_agg_from_lineitem') }}
WHERE
    total_gross_revenue < total_net_amount