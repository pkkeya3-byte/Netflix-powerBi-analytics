SELECT
  t.title_key,
  TRIM(g.value) AS genre
FROM {{ ref('int_titles_unioned') }} t,
LATERAL SPLIT_TO_TABLE(t.genre_list, ',') g
WHERE t.genre_list IS NOT NULL
  AND TRIM(g.value) != 'Unknown'