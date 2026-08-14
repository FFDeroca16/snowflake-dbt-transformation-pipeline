WITH partsupp AS (
    SELECT 
        ps_partkey AS part_key,
        ps_suppkey AS supplier_key,
        ps_availqty AS available_quantity,
        ps_supplycost AS supply_cost, 
        ps_comment AS comment
    FROM 
        {{ source('tpch', 'partsupp') }}
)

SELECT 
    *
FROM 
    partsupp