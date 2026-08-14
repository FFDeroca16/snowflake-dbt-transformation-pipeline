WITH customer AS (
    SELECT 
        c_custkey AS customer_key,
        c_name AS customer_name,
        c_address AS customer_address,
        c_nationkey AS nation_key,
        c_phone AS phone,
        c_acctbal AS customer_account_balance,
        c_mktsegment AS market_segment, 
        c_comment AS customer_comment
    FROM 
        {{ source('raw', 'customer') }}
)

SELECT 
    *
FROM 
    customer