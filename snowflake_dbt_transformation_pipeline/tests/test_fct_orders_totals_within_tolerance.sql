SELECT
    order_key,
    total_price,
    total_gross_revenue,
    ABS(total_price - total_gross_revenue) AS difference
FROM {{ ref('fct_orders') }}
WHERE ABS(total_price - total_gross_revenue) > 1.00