WITH nation AS (
    SELECT 
        n_nationkey AS nation_key,
        n_name AS nation_name,
        n_regionkey AS region_key,
        n_comment AS comment
    FROM   
        {{ source('tpch', 'nation') }}
)

SELECT 
    *
FROM 
    nation 