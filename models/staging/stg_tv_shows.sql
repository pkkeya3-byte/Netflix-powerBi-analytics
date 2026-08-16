WITH deduped AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY show_id, title ORDER BY show_id) AS rn
  FROM {{ source('raw', 'tv_shows') }}
)
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
  duration AS seasons,
  genres AS genre_list,
  language,
  popularity,
  vote_count
FROM deduped
WHERE rn = 1