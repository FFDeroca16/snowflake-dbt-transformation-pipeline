SELECT
    a.customer_key,
    a.dbt_scd_id AS version_a,
    b.dbt_scd_id AS version_b
FROM {{ ref('dim_customer') }} a
JOIN {{ ref('dim_customer') }} b
  ON a.customer_key = b.customer_key
 AND a.dbt_scd_id < b.dbt_scd_id
WHERE a.valid_from < COALESCE(b.valid_to, '9999-12-31'::TIMESTAMP)
  AND b.valid_from < COALESCE(a.valid_to, '9999-12-31'::TIMESTAMP)