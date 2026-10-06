WITH stg_part AS (
    SELECT 
        part_key,
        part_name,
        manufacturer,
        brand,
        part_type,
        part_size,
        container,
        retail_price,
        comment
    FROM 
        {{ ref('stg_part') }}
)

SELECT 
    *
FROM 
    stg_part