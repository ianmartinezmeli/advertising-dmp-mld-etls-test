SELECT
  SUM(evaluated_expectations) evaluated_expectations,
  SUM(successful_expectations) successful_expectations,
  SUM(unsuccessful_expectations) unsuccessful_expectations,
FROM `{{ project_id }}.{{ dataset_id }}.{{ sc_table_name }}`
WHERE
    execution_id = {{ execution_id }}
    -- and sc_step = 'step_result'