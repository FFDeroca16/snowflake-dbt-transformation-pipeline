WITH customer AS (
    SELECT 
        c_custkey AS cust_key,
        c_name AS name,
        c_address AS address,
        c_nationkey AS nation_key,
        c_phone AS phone,
        c_acctbal AS acct_bal,
        c_mktsegment AS mkt_segment, 
        c_comment AS comment
    FROM 
        {{ source('raw', 'customer') }}
)

SELECT 
    *
FROM 
    customer