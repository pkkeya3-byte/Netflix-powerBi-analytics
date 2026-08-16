SELECT
  show_id,
  type,
  title,
  director,
  "CAST" AS cast_list,
  country AS country_list,
  date_added,
  release_year,
  vote_average,
  genres AS genre_list,
  language,
  popularity,
  vote_count,
  budget,
  revenue,
  (budget > 0 AND revenue > 0) AS has_financial_data
FROM {{ source('raw', 'movies') }}