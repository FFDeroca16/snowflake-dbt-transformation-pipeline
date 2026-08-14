WITH customer AS (
    SELECT 
        *
    FROM 
        {{ source('raw', 'customer') }}
)

SELECT 
    *
FROM 
    customer