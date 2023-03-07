CREATE TABLE `{{ project_id }}.{{ dataset_id }}.DMP_GENDER_HISTORICAL_MVP`
(
  execution_id INT64,
  ds DATE,
  site STRING,
  user_id INT64,
  registered_gender STRING,
  final_gender STRING
)
PARTITION BY ds
CLUSTER BY execution_id, site, final_gender
OPTIONS(
  partition_expiration_days=7.0
);