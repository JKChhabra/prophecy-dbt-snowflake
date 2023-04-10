{% macro human_readable_number(number) %}
CASE
  WHEN {{number}} < 1000
    THEN CAST({{number}} AS string)
  WHEN {{number}} < 1000000
    THEN concat(CAST(FLOOR({{number}}/1000) AS string), 'K')
  ELSE concat(CAST(FLOOR({{number}}/1000000) AS string), 'M')
END
{% endmacro %}

 