WITH stg_supplier AS (
    SELECT 
        *
    FROM 
        {{ ref('stg_supplier') }}
),

stg_nation AS (
    SELECT 
        *
    FROM 
        {{ ref('stg_nation') }}
)


SELECT 
    ss.supplier_key,
    ss.supplier_name,
    ss.supplier_address,
    ss.phone,
    ss.supplier_account_balance,
    ss.comment,
    sn.nation_name
FROM 
    stg_supplier ss 
LEFT JOIN
    stg_nation sn 
ON 
    sn.nation_key = ss.nation_key