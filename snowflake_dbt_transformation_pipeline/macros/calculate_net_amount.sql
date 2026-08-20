{% macro calculate_net_amount(extended_price, discount, scale=2)%}
    ({{ extended_price }} * (1 - {{ discount }}))::DECIMAL(16, {{ scale }})
{% endmacro %}