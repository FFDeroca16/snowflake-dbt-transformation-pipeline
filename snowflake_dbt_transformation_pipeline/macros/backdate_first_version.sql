/*
    backdate_first_version

    Returns an expression that replaces each entity's earliest validity start with
    a fixed early date, so range joins to older fact rows still match

    Why: the first snapshot version of every customer starts on the 1998-01-01 backfill date, 
    but orders go back to 1992. That date is a placeholder, not a real start date

    Don't use it when the first snapshot date is the true start of the entity

    Args:
        valid_from_column: column holding the version's start date
        entity_key_column: column identifying the entity
        backdate_to: date to backdate (format is YYYY-MM-DD, example: 1900-01-01)
*/

{% macro backdate_first_version(valid_from_column, entity_key_column, backdate_to) %}
    CASE 
        WHEN {{ valid_from_column }} = MIN({{ valid_from_column }}) OVER (PARTITION BY {{ entity_key_column }})
            THEN '{{ backdate_to }}'::TIMESTAMP
        ELSE {{ valid_from_column }}
    END
{% endmacro %}