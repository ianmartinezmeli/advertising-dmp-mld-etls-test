SELECT
  sc_step, severity, status, count(column_name) qty
FROM `{{ project_id }}.{{ dataset_id }}.{{ sc_table_name }}`
WHERE
    execution_id = {{ execution_id }}
    and expectation_type = 'expectation'
    group by 1,2,3