SELECT
  c.country,
  DATE_TRUNC('year', t.date_added) AS year_added,
  COUNT(DISTINCT t.title_key) AS title_count
FROM {{ ref('int_country_split') }} c
JOIN {{ ref('fct_titles') }} t ON c.title_key = t.title_key
GROUP BY 1, 2