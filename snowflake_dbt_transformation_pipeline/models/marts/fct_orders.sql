WITH deduped_orders AS (
    SELECT 
        order_key,
        customer_key,
        order_date,
        order_status,
        order_priority,
        order_clerk,
        ship_priority,
        total_price
    FROM
        {{ ref('int_orders_deduped') }}
),

customers AS (
    SELECT 
        customer_key,
        valid_to,
        valid_from,
        dbt_scd_id AS customer_version_key
    FROM 
        {{ ref('dim_customer') }}
),

orders_aggregated AS (
    SELECT 
        order_key,
        total_quantity,
        total_net_amount,
        total_gross_revenue,
        total_tax_amount,
        line_item_count
    FROM 
        {{ ref('int_orders_agg_from_lineitem') }}
),

final_cte AS  (
    SELECT 
        ord.order_key,
        ord.customer_key,
        c.customer_version_key,
        ord.order_date,
        ord.order_status,
        ord.order_priority,
        ord.order_clerk,
        ord.ship_priority,
        ord.total_price,
        oa.total_quantity,
        oa.total_net_amount,
        oa.total_gross_revenue,
        oa.total_tax_amount,
        oa.line_item_count
    FROM 
        deduped_orders ord
    LEFT JOIN 
        customers c 
    ON 
        c.customer_key = ord.customer_key
    -- Put conditions as part of joining instead in WHERE clause to prevent records being left out 
    AND 
        ord.order_date >= c.valid_from
    AND 
        (ord.order_date < c.valid_to OR c.valid_to IS NULL)
    LEFT JOIN 
        orders_aggregated oa 
    ON 
        oa.order_key = ord.order_key
)


SELECT 
    *
FROM final_cte