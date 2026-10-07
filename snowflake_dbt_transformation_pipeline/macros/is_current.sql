{% macro is_current(dbt_valid_to)%}
    CASE 
        WHEN {{ dbt_valid_to }} IS  NULL THEN TRUE 
        ELSE FALSE
    END
{% endmacro %}