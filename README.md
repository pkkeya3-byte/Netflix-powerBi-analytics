Netflix Content Analytics — Snowflake, dbt & Power BI

An interactive 4-page Power BI report built on a Snowflake + dbt ETL pipeline, analyzing 32,000+ Netflix titles (movies and TV shows) enriched with TMDB data — budget, revenue, ratings, popularity, and cast/genre/country detail.

Overview

This project answers four questions using real, messy, TMDB-enriched Netflix data:

Where is the platform's content actually making financial sense, and where is the data too thin to say?
Is Netflix shifting its content mix between movies and TV shows over time?
Which countries is content sourced from, and how has that changed?
Which cast members appear most often, and what are they in?
Architecture
Snowflake (raw)  →  dbt (staging → intermediate → marts)  →  Power BI (4-page interactive report)
Raw layer: two source tables (movies, TV shows) loaded into Snowflake from CSV.
Staging: deduplication, dropping redundant/unusable columns.
Intermediate: a composite-key union of movies + TV shows, plus split tables for multi-value fields (genre, country, cast).
Marts: five analysis-ready tables, one feeding each dashboard concern (titles, financial performance, genre trends, global expansion, talent network).
Power BI: connects to the exported marts, with DAX measures for the interactive layer.
Data Quality Issues Found and Fixed

This dataset had several real problems that would have silently produced misleading charts if shipped as-is:

rating and vote_average were 100% identical columns — dropped the redundant one.
duration was 100% null for every movie row — excluded from the movies model; TV shows kept their real seasons data.
Budget/revenue were heavily zero-inflated, and a small number of near-zero "placeholder" budgets (as low as $5) were producing ROI values exceeding 2,000,000% and dominating every financial chart. Fixed with a $10,000 minimum threshold on both fields, excluding only 15 of 3,556 titles (0.4%) — verified by bracket analysis before applying.
show_id was not a globally unique key — 397 IDs were reused across the movies and TV files for different titles. Fixed with a composite key (show_id || type).
9 true duplicate rows existed within the TV shows source file — removed via ROW_NUMBER() deduplication.
An "Unknown" placeholder genre was inflating genre-diversity counts and made a "distinct genres per year" chart look like it had a real trend, when it was actually just a data cleanup artifact settling out over time — excluded at the source.
Comma-splitting cast names produced garbage entries: names like "Robert Downey, Jr." were splitting into a real name plus a fake "Jr." cast member. Combined with this, Power BI's case-insensitive relationship matching collided with Snowflake's case-sensitive data (JR, Jr, Jr. all existed as separate values) — fixed with INITCAP() normalization and explicit exclusion of honorific fragments in the cast-splitting model.
Dashboard Pages
1. Financial Performance

Budget vs. revenue scatter, Top 20 ROI by title, ROI trend by release year. Explicitly scoped to the ~22% of titles with genuine reported financial data, with the sub-$10,000 threshold documented on the page itself.

2. Content Strategy Shift

Movies vs. TV shows over time, with an interactive toggle to include/exclude 2025 — a partial year in this dataset that produces a batch-release spike unrelated to any real change in Netflix's content strategy. Title count by genre, filterable by genre via multi-select slicer.

3. Global Expansion

World map of title count by country (built via a custom-topology Shape Map after Power BI's default Map, Filled Map, and Azure Maps visuals were all blocked by tenant-level restrictions), filterable by year.

4. Talent Network

Top 20 cast members by title count, colored by average rating via conditional formatting. Click any name to cross-filter a linked table showing every title that person appears in.

Tools Used

Snowflake (data warehouse), dbt Core (transformation, testing), Power BI Desktop (visualization), DAX (measures), SQL.