SELECT
  title_key, show_id, type, title, director, date_added, release_year,
  vote_average, language, popularity, vote_count, budget, revenue,
  has_financial_data, seasons
FROM {{ ref('int_titles_unioned') }}