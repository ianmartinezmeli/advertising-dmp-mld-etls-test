WITH VIEW_USERS AS
(
    SELECT
        B.sit_site_id AS site,
        B.cus_cust_id AS user_id,
        LOWER(TRIM(Split(kyc_per_first_name,' ') [OFFSET(0)])) AS first_name,
        LOWER(kyc_name_preferred) AS name_preferred,
        LOWER(TRIM(Split(kyc_name_preferred,' ') [OFFSET(0)]))  AS first_name_preferred,
        kyc_per_gender AS gender
    FROM
        `meli-bi-data.WHOWNER.LK_KYC_VAULT_USER` B
    WHERE
        B.sit_site_id IN ('MLA','MLB','MLC','MLU','MCO','MLM','MEC')
        AND kyc_entity_type = 'person'
        AND kyc_reg_idnt_email_verified = 'true'
        AND kyc_name_preferred IS NOT NULL
        AND LENGTH(kyc_name_preferred) > 0
        AND kyc_name_preferred NOT LIKE 'card'
        AND kyc_name_preferred NOT LIKE 'test'
),

VIEW_INTERNAL_DICT AS
(
    SELECT
        name,
        gender
    FROM
    (
        SELECT
            name,
            gender,
            SUM(qty),
            ROW_NUMBER() OVER (PARTITION BY name ORDER BY SUM(qty) DESC ) AS ranking
        FROM
        (
            SELECT
                LOWER(first_name) AS name,
                gender,
                COUNT(gender) AS qty
            FROM
                VIEW_USERS
            WHERE
                gender IS NOT NULL
            GROUP BY
                1,2
        ) t
        GROUP BY
            1,2
    )
    WHERE
        ranking = 1
),

VIEW_EXTERNAL_DICT AS
(
    SELECT
        name,
        gender
    FROM
    (
        SELECT
            name,
            gender,
            SUM(qty),
            ROW_NUMBER() OVER (PARTITION BY name ORDER BY SUM(qty) DESC ) AS ranking
        FROM
        (
            SELECT
                LOWER(name) AS name,
                gender,
                COUNT(gender) AS qty
            FROM
                `{{ project_id }}.{{ dataset_id }}.DMP_GENDER_DICT`
            GROUP BY
                1,2
        ) t
        GROUP BY
            1,2
    )
    WHERE
        ranking = 1
),

VIEW_CRUCE AS
(
    SELECT
        u.site, u.user_id,
        u.gender AS registered_gender,
        d1.gender AS first_name_preferred_vs_dict,
        d2.gender AS first_name_vs_ext_dict,
        d3.gender AS first_name_vs_int_dict,
        IFNULL(u.gender, IFNULL(d1.gender, IFNULL(d2.gender,d3.gender) ) ) AS final_gender
    FROM
        VIEW_USERS u
    LEFT JOIN VIEW_EXTERNAL_DICT d1 ON u.first_name_preferred = d1.name
    LEFT JOIN VIEW_EXTERNAL_DICT d2 ON u.first_name = d2.name
    LEFT JOIN VIEW_INTERNAL_DICT d3 ON u.first_name = d3.name
)

SELECT
    {{execution_id}} as execution_id,
    CURRENT_DATE() AS ds,
    site,
    user_id,
    registered_gender,
    final_gender
FROM
    VIEW_CRUCE VC
INNER JOIN
    `meli-bi-data.WHOWNER.LK_CUS_CUSTOMERS_DATA` CD
ON
    CD.cus_cust_id = VC.user_id
WHERE
    CD.cus_cust_status IN ('active','C');
