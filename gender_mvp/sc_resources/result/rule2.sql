SELECT
    site,
    final_gender,
    count(user_id) as qty
FROM
    `{{ project_id }}.{{ dataset_id }}.{{ table_name }}`
WHERE
    execution_id = {{execution_id}}
GROUP BY
    1,2
