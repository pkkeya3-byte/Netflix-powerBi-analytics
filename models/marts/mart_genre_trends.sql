SELECT
  g.genre,
  t.type,
  DATE_TRUNC('year', t.date_added) AS year_added,
  COUNT(DISTINCT t.title_key) AS title_count,
  AVG(t.vote_average) AS avg_rating
FROM {{ ref('int_genres_split') }} g
JOIN {{ ref('fct_titles') }} t ON g.title_key = t.title_key
GROUP BY 1, 2, 3