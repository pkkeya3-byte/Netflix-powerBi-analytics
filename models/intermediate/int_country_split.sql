SELECT
  t.title_key,
  TRIM(c.value) AS country
FROM {{ ref('int_titles_unioned') }} t,
LATERAL SPLIT_TO_TABLE(t.country_list, ',') c
WHERE t.country_list IS NOT NULL