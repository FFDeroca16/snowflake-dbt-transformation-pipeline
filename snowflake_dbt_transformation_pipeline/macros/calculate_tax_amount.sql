{% macro calculate_tax_amount(extended_price, discount, tax, scale=2)%}
    -- Modified the formula to subtract net amount from gross revenue
    (
        {{ calculate_gross_revenue(extended_price, discount, tax, scale) }} 
        - 
        {{ calculate_net_amount(extended_price, discount, scale) }}
    )::DECIMAL(16, {{ scale }})
{% endmacro %}