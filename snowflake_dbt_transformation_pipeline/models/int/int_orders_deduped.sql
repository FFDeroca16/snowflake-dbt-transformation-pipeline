WITH int_orders_deduped AS  (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY order_key ORDER BY loaded_at DESC) AS rn
    FROM 
        {{ ref('stg_orders') }}
)

SELECT
    order_key,
    customer_key,
    order_status,
    total_price,
    order_date,
    order_priority,
    order_clerk,
    ship_priority,
    comment,
    loaded_at 
FROM 
    int_orders_deduped
WHERE
    rn = 1