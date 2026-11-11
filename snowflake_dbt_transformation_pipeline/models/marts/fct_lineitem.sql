{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        unique_key='line_item_key',
        incremental_strategy='merge'
    )
}}


WITH lineitem AS (
    SELECT
        line_item_key,
        order_key,
        line_number,
        part_key,
        supplier_key,
        ship_date,
        commit_date,
        receipt_date,
        quantity,
        extended_price,
        net_amount,
        gross_revenue,
        tax_amount,
        discount,
        tax,
        return_flag,
        line_status,
        ship_mode,
        ship_instruct,
        loaded_at
    FROM
        {{ ref('int_lineitem_calcs') }}
    {% if is_incremental() %}
        WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }}) 
    {% endif %}

),

orders AS (
    SELECT
        customer_version_key,
        order_key
    FROM
        {{ ref('fct_orders') }}
),

final_cte AS (
    SELECT
        li.line_item_key,
        li.order_key,
        li.line_number,
        li.part_key,
        li.supplier_key,
        o.customer_version_key,
        li.ship_date,
        li.commit_date,
        li.receipt_date,
        li.quantity,
        li.extended_price,
        li.net_amount,
        li.gross_revenue,
        li.tax_amount,
        li.discount,
        li.tax,
        li.return_flag,
        li.line_status,
        li.ship_mode,
        li.ship_instruct,
        li.loaded_at
    FROM
        lineitem li
    LEFT JOIN
        orders o
        ON
            o.order_key = li.order_key

)

SELECT *
FROM
    final_cte
