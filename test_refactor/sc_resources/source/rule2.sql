SELECT
    count(test_message) qty_rows
FROM  `{{ project_id }}.{{ dataset_id }}.{{ table_name }}`
