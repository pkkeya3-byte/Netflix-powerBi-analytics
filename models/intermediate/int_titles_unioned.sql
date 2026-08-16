SELECT
  show_id || '_' || type AS title_key,
  show_id, type, title, director, cast_list, country_list, date_added,
  release_year, vote_average, genre_list, language, popularity, vote_count,
  budget, revenue, has_financial_data,
  NULL AS seasons
FROM {{ ref('stg_movies') }}

UNION ALL

SELECT
  show_id || '_' || type AS title_key,
  show_id, type, title, director, cast_list, country_list, date_added,
  release_year, vote_average, genre_list, language, popularity, vote_count,
  NULL AS budget, NULL AS revenue, FALSE AS has_financial_data,
  seasons
FROM {{ ref('stg_tv_shows') }}