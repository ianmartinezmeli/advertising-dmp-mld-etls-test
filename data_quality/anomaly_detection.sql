SELECT
    column_name, expectation_name, metric_name, metric_value
FROM `{{ project_id }}.{{ dataset_id }}.{{ sc_table_name }}`
WHERE
  execution_id = {{ execution_id }}
  AND sanity_group_id = '{{ etl_name }}'
  AND expectation_type = 'metric'
