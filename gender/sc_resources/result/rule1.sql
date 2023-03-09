SELECT
    ds,
    site,
    user_id,
    registered_gender,
    final_gender
FROM
    `{{ project_id }}.{{ dataset_id }}.{{ table_name }}`
WHERE
    execution_id = {{execution_id}}