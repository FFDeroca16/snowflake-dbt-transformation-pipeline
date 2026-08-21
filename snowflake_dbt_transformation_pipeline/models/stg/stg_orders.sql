/*
    Last edit: Franz 2026-08-21
    - Added loaded_at column for deduplication scenarios
*/

WITH orders AS (
    SELECT 
        o_orderkey AS order_key,
        o_custkey AS customer_key,
        o_orderstatus AS order_status,
        o_totalprice AS total_price,
        o_orderdate AS order_date,
        o_orderpriority AS order_priority,
        o_clerk AS order_clerk,
        o_shippriority AS ship_priority,
        o_comment AS comment,
        loaded_at -- Added: Franz 2026-08-21
    FROM 
        {{ source('raw', 'orders') }}
)

SELECT
    *
FROM 
    orders
