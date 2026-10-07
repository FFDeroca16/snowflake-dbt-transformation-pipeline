WITH customer_cte AS (
    SELECT 
        c_custkey AS customer_key,
        c_name AS customer_name,
        c_address AS customer_address,
        c_nationkey AS nation_key,
        c_phone AS customer_phone,
        c_acctbal AS account_balance,
        c_mktsegment AS market_segment,
        c_comment AS comment,
        dbt_scd_id,
        dbt_updated_at,
        dbt_valid_from AS valid_from,
        dbt_valid_to AS valid_to,
        {{ is_current('dbt_valid_to') }} AS is_current
    FROM 
        {{ ref('int_customer_scd') }}
)

SELECT 
    *
FROM 
    customer_cte