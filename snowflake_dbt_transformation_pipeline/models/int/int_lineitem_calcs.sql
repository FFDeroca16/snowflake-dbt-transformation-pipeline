WITH line_item_calcs AS (
    SELECT
        line_item_key,
        order_key,
        part_key,
        supplier_key,
        line_number,
        quantity,
        extended_price,
        discount,
        tax,
        return_flag,
        line_status,
        ship_date, 
        commit_date,
        receipt_date,
        ship_instruct,
        ship_mode,
        comment,
        {{ calculate_net_amount('extended_price', 'discount') }} AS net_amount,
        {{ calculate_gross_revenue('extended_price', 'discount', 'tax') }} AS gross_revenue,
        {{ calculate_tax_amount('extended_price', 'discount', 'tax') }} AS tax_amount
    FROM {{ ref('stg_lineitem') }}
)

SELECT 
    *
FROM 
    line_item_calcs