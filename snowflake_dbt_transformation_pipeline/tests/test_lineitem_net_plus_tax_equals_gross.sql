SELECT 
    line_item_key,
    net_amount,
    tax_amount,
    gross_revenue
FROM 
    {{ ref('fct_lineitem') }}
WHERE 
    gross_revenue != net_amount + tax_amount