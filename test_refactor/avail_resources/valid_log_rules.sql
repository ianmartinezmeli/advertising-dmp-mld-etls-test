SELECT
  sc_step, severity, status, column_name
FROM `{{ project_id }}.{{ dataset_id }}.{{ sc_table_name }}`
WHERE
    execution_id = {{ execution_id }}
    and expectation_type = 'expectation'