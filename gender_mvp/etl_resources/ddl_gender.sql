CREATE VIEW `{{ project_id }}.{{ dataset_id }}.DMP_GENDER_MVP`
AS SELECT
  site,
  user_id,
  registered_gender,
  IFNULL(final_gender, "NI") as final_gender
FROM `{{ project_id }}.{{ dataset_id }}.DMP_GENDER_HISTORICAL_MVP`
WHERE execution_id = (
    SELECT MAX(execution_id)
        FROM
          `{{ project_id }}.{{ dataset_id }}.DMP_DQ_WORKFLOW_CONTROL` t
        WHERE
          t.target_project='{{ project_id }}'
          and t.target_dataset='{{ dataset_id }}'
          and t.target_table = 'DMP_GENDER_HISTORICAL_MVP'
          and t.status = 'SUCCESS'
);
