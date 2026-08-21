{{
    config(
        materialized = 'table'
    )
}}

WITH date_spine AS (
    {{
        dbt_utils.date_spine(
            datepart = "day",
            start_date = "CAST('1992-01-01' AS DATE)",
            end_date = "CAST('1999-01-01' AS DATE)"
        )
    }}
)

SELECT
    date_day AS date_key,
    date_day,
    DAYOFWEEK(date_day) AS day_of_week_number,
    DAYNAME(date_day) AS day_of_week_name,
    DAY(date_day) AS day_of_month,
    WEEK(date_day) AS week_of_year,
    MONTH(date_day) AS month_number,
    MONTHNAME(date_day) AS month_name,
    QUARTER(date_day) AS quarter_number,
    YEAR(date_day) AS year_number,
    CASE 
        WHEN DAYOFWEEK(date_day) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM
    date_spine