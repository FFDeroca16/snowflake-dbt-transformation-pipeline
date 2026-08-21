WITH orders_agg_from_lineitem AS  (
    SELECT 
        order_key,
        SUM(quantity) AS total_quantity,
        SUM(net_amount) AS total_net_amount,
        SUM(gross_revenue) AS total_gross_revenue,
        SUM(tax_amount) AS total_tax_amount,
        COUNT(line_item_key) AS line_item_count
    FROM 
        {{ ref('int_lineitem_calcs') }}
    GROUP BY
        order_key
) 

SELECT 
    *
FROM 
    orders_agg_from_lineitem