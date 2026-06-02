{% macro convert_to_usd(column_name) %}
    {{column_name}} * (
        SELECT
	        price
        FROM {{ ref('btc_usd_max')}}
        WHERE to_date(replace(snapped_at,' UTC','')) = current_date()
    )
{% endmacro %}