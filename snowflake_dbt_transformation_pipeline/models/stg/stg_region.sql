WITH region AS (
    SELECT 
        r_regionkey AS region_key,
        r_name AS region_name,
        r_comment AS comment
    FROM 
        {{ source('tpch', 'region') }}
)

SELECT 
    *
FROM 
    region 