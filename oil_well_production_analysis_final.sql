-- =========================================================
-- OIL WELL PRODUCTION & PERFORMANCE ANALYSIS
-- Final SQL Analysis File
--
-- Database: oil_well_analysis
-- Dataset: Synthetic oil-well production data
-- Purpose: Combine SQL analytics with petroleum-engineering KPIs
-- =========================================================

USE oil_well_analysis;


-- =========================================================
-- 1. TOTAL OIL PRODUCTION
-- Calculate total oil produced by all wells
-- during the complete analysis period.
-- =========================================================

SELECT
    SUM(oil_bbl) AS total_oil_production
FROM production;


-- =========================================================
-- 2. PRODUCTION BY WELL
-- Calculate total oil production for each well
-- and rank wells from highest to lowest production.
-- =========================================================

SELECT
    well_id,
    SUM(oil_bbl) AS total_oil
FROM production
GROUP BY well_id
ORDER BY total_oil DESC;


-- =========================================================
-- 3. TOP 5 PRODUCING WELLS
-- Identify the five wells with the highest
-- total oil production.
-- =========================================================

SELECT
    well_id,
    SUM(oil_bbl) AS total_oil
FROM production
GROUP BY well_id
ORDER BY total_oil DESC
LIMIT 5;


-- =========================================================
-- 4. WELL + PRODUCTION ANALYSIS
-- Join well information with production data
-- to understand where the production is coming from.
-- =========================================================

SELECT
    w.well_id,
    w.well_name,
    w.field_name,
    w.reservoir_name,
    w.depth_m,
    w.status,
    SUM(p.oil_bbl) AS total_oil
FROM wells w
JOIN production p
    ON w.well_id = p.well_id
GROUP BY
    w.well_id,
    w.well_name,
    w.field_name,
    w.reservoir_name,
    w.depth_m,
    w.status
ORDER BY total_oil DESC;


-- =========================================================
-- 5. PRODUCTION BY FIELD
-- Compare total oil production across fields.
-- =========================================================

SELECT
    w.field_name,
    SUM(p.oil_bbl) AS total_oil
FROM wells w
JOIN production p
    ON w.well_id = p.well_id
GROUP BY w.field_name
ORDER BY total_oil DESC;


-- =========================================================
-- 6. WATER CUT ANALYSIS
-- Calculate total oil, total water and water cut
-- for each well.
--
-- Water Cut =
-- Water / (Oil + Water) × 100
-- =========================================================

SELECT
    w.well_id,
    w.well_name,
    w.field_name,
    ROUND(SUM(p.oil_bbl), 2) AS total_oil,
    ROUND(SUM(p.water_bbl), 2) AS total_water,
    ROUND(
        SUM(p.water_bbl) /
        (SUM(p.oil_bbl) + SUM(p.water_bbl)) * 100,
        2
    ) AS water_cut_percent
FROM wells w
JOIN production p
    ON w.well_id = p.well_id
GROUP BY
    w.well_id,
    w.well_name,
    w.field_name
ORDER BY water_cut_percent DESC;


-- =========================================================
-- 7. MONTHLY PRODUCTION TREND
-- Calculate total oil production month by month
-- to observe the production trend over time.
-- =========================================================

SELECT
    production_date,
    SUM(oil_bbl) AS monthly_oil_production
FROM production
GROUP BY production_date
ORDER BY production_date;


-- =========================================================
-- 8. MONTHLY PRODUCTION DECLINE
-- LAG() retrieves the previous month's production.
-- The CTE then allows us to calculate the percentage
-- decline between consecutive months.
-- =========================================================

WITH monthly_data AS (

    SELECT
        production_date,
        SUM(oil_bbl) AS monthly_oil_production,

        LAG(SUM(oil_bbl)) OVER (
            ORDER BY production_date
        ) AS previous_month_production

    FROM production
    GROUP BY production_date
)

SELECT
    production_date,
    monthly_oil_production,
    previous_month_production,
    ROUND(
        (
            previous_month_production - monthly_oil_production
        ) / previous_month_production * 100,
        2
    ) AS decline_percent
FROM monthly_data
ORDER BY production_date;


-- =========================================================
-- 9. WELL-LEVEL PRODUCTION DECLINE
-- PARTITION BY well_id makes LAG() work separately
-- for each well.
-- =========================================================

WITH well_monthly_data AS (

    SELECT
        well_id,
        production_date,
        oil_bbl,

        LAG(oil_bbl) OVER (
            PARTITION BY well_id
            ORDER BY production_date
        ) AS previous_month_oil

    FROM production
)

SELECT
    well_id,
    production_date,
    oil_bbl,
    previous_month_oil,
    ROUND(
        (
            previous_month_oil - oil_bbl
        ) / previous_month_oil * 100,
        2
    ) AS decline_percent
FROM well_monthly_data
ORDER BY well_id, production_date;


-- =========================================================
-- 10. FINAL WELL PERFORMANCE VIEW
-- Create a reusable view containing:
-- total oil, water cut, production decline
-- and performance category.
--
-- Performance rules used here are project assumptions:
-- High decline OR high water cut OR low production
-- -> Needs Attention
-- Strong production with low water cut and low decline
-- -> Strong
-- Otherwise -> Moderate
-- =========================================================

CREATE OR REPLACE VIEW well_performance AS

WITH well_data AS (

    SELECT
        w.well_id,
        w.well_name,
        w.field_name,
        w.reservoir_name,
        w.status,
        p.production_date,
        p.oil_bbl,
        p.water_bbl,

        FIRST_VALUE(p.oil_bbl) OVER (
            PARTITION BY p.well_id
            ORDER BY p.production_date
        ) AS first_month_oil,

        LAST_VALUE(p.oil_bbl) OVER (
            PARTITION BY p.well_id
            ORDER BY p.production_date
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
        ) AS last_month_oil

    FROM wells w
    JOIN production p
        ON w.well_id = p.well_id
),

well_metrics AS (

    SELECT
        well_id,
        well_name,
        field_name,
        reservoir_name,
        status,

        ROUND(SUM(oil_bbl), 2) AS total_oil,

        ROUND(
            SUM(water_bbl) /
            (SUM(oil_bbl) + SUM(water_bbl)) * 100,
            2
        ) AS water_cut_percent,

        ROUND(
            (MAX(first_month_oil) - MAX(last_month_oil))
            / MAX(first_month_oil) * 100,
            2
        ) AS decline_percent

    FROM well_data
    GROUP BY
        well_id,
        well_name,
        field_name,
        reservoir_name,
        status
)

SELECT
    *,
    CASE
        WHEN decline_percent > 25
             OR water_cut_percent > 35
             OR total_oil < 2000
        THEN 'Needs Attention'

        WHEN total_oil >= 3000
             AND water_cut_percent < 25
             AND decline_percent < 20
        THEN 'Strong'

        ELSE 'Moderate'
    END AS performance_category
FROM well_metrics;


-- =========================================================
-- 11. FINAL WELL PERFORMANCE REPORT
-- Display the reusable performance view.
-- =========================================================

SELECT *
FROM well_performance
ORDER BY total_oil DESC;


-- =========================================================
-- 12. WELLS REQUIRING ATTENTION
-- Quickly identify wells flagged by the performance model.
-- =========================================================

SELECT
    well_id,
    well_name,
    field_name,
    reservoir_name,
    total_oil,
    water_cut_percent,
    decline_percent,
    performance_category
FROM well_performance
WHERE performance_category = 'Needs Attention'
ORDER BY decline_percent DESC;


-- =========================================================
-- END OF FINAL SQL ANALYSIS
-- =========================================================
