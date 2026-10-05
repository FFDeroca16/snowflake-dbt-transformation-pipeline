WITH stg_nation AS (
    SELECT 
        *
    FROM 
        {{ ref('stg_nation') }}
),

stg_region AS (
    SELECT 
        *
    FROM 
        {{ ref('stg_region') }} 
)

SELECT 
    n.nation_key,
    n.nation_name,
    r.region_name
FROM 
    stg_nation n 
INNER JOIN 
    stg_region r 
ON 
    r.region_key = n.region_key
