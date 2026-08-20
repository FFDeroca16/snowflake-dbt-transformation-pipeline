{% macro calculate_gross_revenue(extended_price, discount, tax, scale=2)%}
    ({{ extended_price }} * (1 - {{ discount }}) * (1 + {{ tax }}))::DECIMAL(16, {{ scale }})
{% endmacro %}