SELECT
  t.title_key,
  INITCAP(TRIM(c.value)) AS cast_member
FROM {{ ref('int_titles_unioned') }} t,
LATERAL SPLIT_TO_TABLE(t.cast_list, ',') c
WHERE t.cast_list IS NOT NULL
  AND UPPER(TRIM(c.value)) NOT IN ('JR', 'JR.', 'SR', 'SR.', 'II', 'III', 'IV')