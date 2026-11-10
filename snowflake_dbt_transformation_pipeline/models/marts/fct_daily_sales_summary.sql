{{
    config(materialized =  'table')
}}

WITH orders AS (
    SELECT 
        order_date,
        customer_version_key,
        line_item_count,
        total_quantity,
        total_net_amount,
        total_tax_amount,
        total_gross_revenue   
    FROM 
        {{ ref('fct_orders') }}
),

customers AS (
    SELECT 
        dbt_scd_id,
        nation_key
    FROM 
        {{ ref('dim_customer') }}
)

SELECT 
    o.order_date,
    c.nation_key,
    COUNT(*) AS order_count,
    SUM(o.line_item_count) AS line_item_count,
    SUM(o.total_quantity) AS total_quantity,
    SUM(o.total_net_amount) AS total_net_amount,
    SUM(o.total_tax_amount) AS total_tax_amount,
    SUM(o.total_gross_revenue) AS total_gross_revenue   
FROM 
    orders o
LEFT JOIN 
    customers c
ON 
    o.customer_version_key = c.dbt_scd_id
GROUP BY
    o.order_date, c.nation_key