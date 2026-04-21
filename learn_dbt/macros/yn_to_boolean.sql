{% macro yn_to_boolean(column_name) %}
    case
        when {{ column_name }} = 'Y' then true
        when {{ column_name }} = 'N' then false
        else null
    end

{% endmacro %}