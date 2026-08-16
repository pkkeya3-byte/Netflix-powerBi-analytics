SELECT
  title_key, title, release_year, budget, revenue,
  ROUND((revenue - budget) / NULLIF(budget, 0), 2) AS roi,
  popularity, vote_average
FROM {{ ref('fct_titles') }}
WHERE has_financial_data = TRUE
  AND budget >= 10000
  AND revenue >= 10000