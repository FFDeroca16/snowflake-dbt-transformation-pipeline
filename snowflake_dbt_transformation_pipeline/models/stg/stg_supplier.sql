WITH supplier AS (
    SELECT 
        s_suppkey AS supplier_key,
        s_name AS supplier_name,
        s_address AS supplier_address,
        s_nationkey AS nation_key,
        s_phone AS phone, 
        s_acctbal AS supplier_account_balance,
        s_comment AS comment
    FROM 
        {{ source('tpch', 'supplier') }}
)

SELECT 
    *
FROM    
    supplier 