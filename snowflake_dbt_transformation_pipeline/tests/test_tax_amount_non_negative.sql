SELECT 
    line_item_key,
    net_amount,
    gross_revenue,
    tax_amount
FROM 
    {{ ref('int_lineitem_calcs') }}
WHERE 
    tax_amount < 0