WITH int_lineitem_deduped AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY line_item_key ORDER BY loaded_at DESC) AS rn 
    FROM 
        {{ ref('stg_lineitem') }}
)

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
    line_comment,
    loaded_at
FROM
    int_lineitem_deduped
WHERE
    rn = 1