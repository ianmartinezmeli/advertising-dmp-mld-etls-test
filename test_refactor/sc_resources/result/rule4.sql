SELECT
    count(test_message) qty_registros
FROM  `{{ project_id }}.{{ dataset_id }}.{{ table_name }}`
WHERE execution_id = {{execution_id}}