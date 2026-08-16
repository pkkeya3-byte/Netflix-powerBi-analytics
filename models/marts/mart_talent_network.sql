SELECT
  p.cast_member,
  COUNT(DISTINCT t.title_key) AS title_count,
  AVG(t.vote_average) AS avg_rating
FROM {{ ref('int_cast_split') }} p
JOIN {{ ref('fct_titles') }} t ON p.title_key = t.title_key
GROUP BY 1