{% macro calculate_tax_amount(extended_price, discount, tax, scale=2)%}
    ({{ calculate_net_amount(extended_price, discount) }} * {{ tax }})::DECIMAL(16, {{ scale }})
{% endmacro %}