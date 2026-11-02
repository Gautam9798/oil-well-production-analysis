CREATE DATABASE oil_well_analysis;
-- drop database oil_well_analysis;
USE oil_well_analysis;
CREATE TABLE wells (
    well_id VARCHAR(10) PRIMARY KEY,
    well_name VARCHAR(50),
    field_name VARCHAR(50),
    reservoir_name VARCHAR(50),
    depth_m INT,
    status VARCHAR(20)
);
CREATE TABLE production (
    production_id INT AUTO_INCREMENT PRIMARY KEY,
    well_id VARCHAR(10),
    production_date DATE,
    oil_bbl DECIMAL(10,2),
    gas_mscf DECIMAL(10,2),
    water_bbl DECIMAL(10,2),
    
    FOREIGN KEY (well_id) REFERENCES wells(well_id)
);
CREATE TABLE reservoirs (
    reservoir_id VARCHAR(10) PRIMARY KEY,
    reservoir_name VARCHAR(50),
    porosity DECIMAL(5,2),
    permeability_md DECIMAL(10,2),
    pressure_psi DECIMAL(10,2),
    temperature_f DECIMAL(6,2)
);
SHOW TABLES;
INSERT INTO reservoirs
(reservoir_id, reservoir_name, porosity, permeability_md, pressure_psi, temperature_f)
VALUES
('R1', 'Sandstone A', 18.5, 120, 3200, 180),
('R2', 'Sandstone B', 21.0, 250, 3500, 195),
('R3', 'Sandstone C', 16.8, 85, 2900, 170),
('R4', 'Sandstone D', 23.5, 310, 3700, 205),
('R5', 'Sandstone E', 19.2, 175, 3300, 185);
SELECT * FROM reservoirs;
INSERT INTO wells
(well_id, well_name, field_name, reservoir_name, depth_m, status)
VALUES
('W001', 'Alpha-01', 'Alpha Field', 'R1', 3200, 'Active'),
('W002', 'Alpha-02', 'Alpha Field', 'R1', 3450, 'Active'),
('W003', 'Alpha-03', 'Alpha Field', 'R2', 3800, 'Active'),
('W004', 'Alpha-04', 'Alpha Field', 'R2', 4100, 'Active'),
('W005', 'Alpha-05', 'Alpha Field', 'R1', 3300, 'Inactive'),

('W006', 'Beta-01', 'Beta Field', 'R2', 3600, 'Active'),
('W007', 'Beta-02', 'Beta Field', 'R2', 3900, 'Active'),
('W008', 'Beta-03', 'Beta Field', 'R3', 4300, 'Active'),
('W009', 'Beta-04', 'Beta Field', 'R3', 4500, 'Active'),
('W010', 'Beta-05', 'Beta Field', 'R2', 3700, 'Inactive'),

('W011', 'Gamma-01', 'Gamma Field', 'R3', 4200, 'Active'),
('W012', 'Gamma-02', 'Gamma Field', 'R3', 4400, 'Active'),
('W013', 'Gamma-03', 'Gamma Field', 'R4', 4700, 'Active'),
('W014', 'Gamma-04', 'Gamma Field', 'R4', 4900, 'Active'),
('W015', 'Gamma-05', 'Gamma Field', 'R3', 4100, 'Inactive'),

('W016', 'Delta-01', 'Delta Field', 'R4', 4600, 'Active'),
('W017', 'Delta-02', 'Delta Field', 'R4', 4800, 'Active'),
('W018', 'Delta-03', 'Delta Field', 'R5', 5100, 'Active'),
('W019', 'Delta-04', 'Delta Field', 'R5', 5300, 'Active'),
('W020', 'Delta-05', 'Delta Field', 'R4', 5000, 'Inactive');
SELECT * FROM wells;
SELECT COUNT(*) FROM wells;
SELECT COUNT(*) FROM reservoirs;
SELECT COUNT(*) AS production_records
FROM production;
INSERT INTO production
(well_id, production_date, oil_bbl, gas_mscf, water_bbl)

WITH RECURSIVE months AS (
    SELECT 0 AS month_num, DATE('2026-01-01') AS production_date

    UNION ALL

    SELECT
        month_num + 1,
        DATE_ADD(production_date, INTERVAL 1 MONTH)
    FROM months
    WHERE month_num < 5
),

well_base AS (
    SELECT
        well_id,

        CASE well_id
            WHEN 'W001' THEN 650
            WHEN 'W002' THEN 580
            WHEN 'W003' THEN 720
            WHEN 'W004' THEN 500
            WHEN 'W005' THEN 300

            WHEN 'W006' THEN 750
            WHEN 'W007' THEN 680
            WHEN 'W008' THEN 420
            WHEN 'W009' THEN 390
            WHEN 'W010' THEN 280

            WHEN 'W011' THEN 350
            WHEN 'W012' THEN 400
            WHEN 'W013' THEN 800
            WHEN 'W014' THEN 720
            WHEN 'W015' THEN 250

            WHEN 'W016' THEN 850
            WHEN 'W017' THEN 780
            WHEN 'W018' THEN 600
            WHEN 'W019' THEN 550
            WHEN 'W020' THEN 300
        END AS base_oil,

        CASE well_id
            WHEN 'W001' THEN 0.15
            WHEN 'W002' THEN 0.20
            WHEN 'W003' THEN 0.12
            WHEN 'W004' THEN 0.25
            WHEN 'W005' THEN 0.45

            WHEN 'W006' THEN 0.10
            WHEN 'W007' THEN 0.15
            WHEN 'W008' THEN 0.35
            WHEN 'W009' THEN 0.40
            WHEN 'W010' THEN 0.50

            WHEN 'W011' THEN 0.30
            WHEN 'W012' THEN 0.25
            WHEN 'W013' THEN 0.08
            WHEN 'W014' THEN 0.12
            WHEN 'W015' THEN 0.55

            WHEN 'W016' THEN 0.07
            WHEN 'W017' THEN 0.10
            WHEN 'W018' THEN 0.20
            WHEN 'W019' THEN 0.25
            WHEN 'W020' THEN 0.50
        END AS base_water_cut

    FROM wells
)

SELECT
    wb.well_id,
    m.production_date,

    ROUND(
        wb.base_oil * (1 - 0.04 * m.month_num),
        2
    ) AS oil_bbl,

    ROUND(
        wb.base_oil * 1.5 * (1 - 0.03 * m.month_num),
        2
    ) AS gas_mscf,

    ROUND(
        wb.base_oil
        * (
            wb.base_water_cut
            + 0.03 * m.month_num
        ),
        2
    ) AS water_bbl

FROM well_base wb
CROSS JOIN months m;


SELECT COUNT(*) AS total_records
FROM production;
SELECT *
FROM production
limit 20;

SELECT SUM(oil_bbl) AS total_oil_production
FROM production;

-- How much oil did each well produce over the 6-month period?
SELECT
    well_id,
    SUM(oil_bbl) AS total_oil
FROM production
GROUP BY well_id
ORDER BY total_oil DESC;

SELECT
    well_id,
    SUM(oil_bbl) AS total_oil
FROM production
GROUP BY well_id
ORDER BY total_oil DESC
LIMIT 5;

-- What field and reservoir does W016 belong to? How deep is it? Is it active?
-- That's where JOIN comes in.

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
-- show tables;
-- select * from production;

SELECT
    w.field_name,
    SUM(p.oil_bbl) AS total_oil
FROM wells w
JOIN production p
    ON w.well_id = p.well_id
GROUP BY w.field_name
ORDER BY total_oil DESC;

-- First: calculate water cut for every well
-- then classify the wells
-- < 30%       → Low Water Cut
-- 30–50%      → Moderate
-- > 50%       → High
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
    ) AS water_cut_percent,

    CASE
        WHEN SUM(p.water_bbl) /
             (SUM(p.oil_bbl) + SUM(p.water_bbl)) * 100 < 30
            THEN 'Low'

        WHEN SUM(p.water_bbl) /
             (SUM(p.oil_bbl) + SUM(p.water_bbl)) * 100 <= 50
            THEN 'Moderate'

        ELSE 'High'
    END AS water_cut_category

FROM wells w
JOIN production p
    ON w.well_id = p.well_id

GROUP BY
    w.well_id,
    w.well_name,
    w.field_name

ORDER BY water_cut_percent DESC;

-- Step 6 — Monthly Oil Production Trend

-- Monthly Oil Production
-- Calculate total oil production for each month
-- to observe the production trend over time.

SELECT
    production_date,
    SUM(oil_bbl) AS monthly_oil_production
FROM production
GROUP BY production_date
ORDER BY production_date;

-- Step 7 Production Decline Analysis
-- LAG() gives us the previous month's production
-- so we can compare current production with previous production.

SELECT
    production_date,
    SUM(oil_bbl) AS monthly_oil_production,

    LAG(SUM(oil_bbl)) OVER (
        ORDER BY production_date
    ) AS previous_month_production

FROM production

GROUP BY production_date
ORDER BY production_date;

-- Step 8 Monthly Production Decline
-- First calculate current and previous month production.
-- Then calculate the percentage decline between the two months.

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

    -- Calculate percentage change from previous month.
    ROUND(
        (
            previous_month_production - monthly_oil_production
        ) / previous_month_production * 100,
        2
    ) AS decline_percent

FROM monthly_data

ORDER BY production_date;

-- Step 9 Well-Level Production Decline
-- Calculate month-to-month production decline for each well.
-- PARTITION BY well_id makes LAG() work separately for each well.

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

ORDER BY
    well_id,
    production_date;
    
-- Step10 Overall Well Production Decline
-- Compare each well's first-month production with
-- its last-month production to identify declining wells.

WITH well_production AS (

    SELECT
        well_id,

        -- First production value for each well.
        FIRST_VALUE(oil_bbl) OVER (
            PARTITION BY well_id
            ORDER BY production_date
        ) AS first_month_oil,

        -- Last production value for each well.
        LAST_VALUE(oil_bbl) OVER (
            PARTITION BY well_id
            ORDER BY production_date
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
        ) AS last_month_oil

    FROM production
)

SELECT DISTINCT
    well_id,
    first_month_oil,
    last_month_oil,

    ROUND(
        (first_month_oil - last_month_oil)
        / first_month_oil * 100,
        2
    ) AS overall_decline_percent

FROM well_production

ORDER BY overall_decline_percent DESC;



-- Check production history of W001 and W016.

SELECT
    well_id,
    production_date,
    oil_bbl
FROM production
WHERE well_id IN ('W001', 'W016')
ORDER BY well_id, production_date;

-- Update Oil & Gas Production
-- Assign different monthly decline rates to different wells
-- to create more realistic well-level production behavior.

UPDATE production
SET
    oil_bbl =
        ROUND(
            CASE

                WHEN well_id IN ('W001','W002','W003','W004','W005')
                    THEN
                        CASE well_id
                            WHEN 'W001' THEN 650
                            WHEN 'W002' THEN 580
                            WHEN 'W003' THEN 720
                            WHEN 'W004' THEN 500
                            WHEN 'W005' THEN 300
                        END
                        * POWER(0.95,
                            TIMESTAMPDIFF(
                                MONTH,
                                '2026-01-01',
                                production_date
                            ))

                WHEN well_id IN ('W006','W007','W008','W009','W010')
                    THEN
                        CASE well_id
                            WHEN 'W006' THEN 750
                            WHEN 'W007' THEN 680
                            WHEN 'W008' THEN 420
                            WHEN 'W009' THEN 390
                            WHEN 'W010' THEN 280
                        END
                        * POWER(0.97,
                            TIMESTAMPDIFF(
                                MONTH,
                                '2026-01-01',
                                production_date
                            ))

                WHEN well_id IN ('W011','W012','W013','W014','W015')
                    THEN
                        CASE well_id
                            WHEN 'W011' THEN 350
                            WHEN 'W012' THEN 400
                            WHEN 'W013' THEN 800
                            WHEN 'W014' THEN 720
                            WHEN 'W015' THEN 250
                        END
                        * POWER(0.93,
                            TIMESTAMPDIFF(
                                MONTH,
                                '2026-01-01',
                                production_date
                            ))

                WHEN well_id IN ('W016','W017','W018','W019','W020')
                    THEN
                        CASE well_id
                            WHEN 'W016' THEN 850
                            WHEN 'W017' THEN 780
                            WHEN 'W018' THEN 600
                            WHEN 'W019' THEN 550
                            WHEN 'W020' THEN 300
                        END
                        * POWER(0.96,
                            TIMESTAMPDIFF(
                                MONTH,
                                '2026-01-01',
                                production_date
                            ))

            END,
            2
        ),

    gas_mscf =
        ROUND(oil_bbl * 1.5, 2);
        
        
-- Check production behavior after applying
-- different decline rates to the wells.

SELECT
    well_id,
    production_date,
    oil_bbl
FROM production
WHERE well_id IN ('W001', 'W006', 'W013', 'W016')
ORDER BY well_id, production_date;

-- Check which database/schema is currently active.

SELECT DATABASE();


-- Step 11 Well Performance Summary
-- Combine production, water cut and decline
-- to compare the overall performance of each well.

WITH well_metrics AS (

    SELECT
        w.well_id,
        w.well_name,
        w.field_name,
        w.reservoir_name,
        w.status,

        SUM(p.oil_bbl) AS total_oil,
        SUM(p.water_bbl) AS total_water,

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

    GROUP BY
        w.well_id,
        w.well_name,
        w.field_name,
        w.reservoir_name,
        w.status,
        p.well_id,
        p.oil_bbl,
        p.production_date
),

final_metrics AS (

    SELECT
        well_id,
        well_name,
        field_name,
        reservoir_name,
        status,

        ROUND(SUM(total_oil), 2) AS total_oil,

        ROUND(
            SUM(total_water) /
            (SUM(total_oil) + SUM(total_water)) * 100,
            2
        ) AS water_cut_percent,

        ROUND(
            (MAX(first_month_oil) - MAX(last_month_oil))
            / MAX(first_month_oil) * 100,
            2
        ) AS decline_percent

    FROM well_metrics

    GROUP BY
        well_id,
        well_name,
        field_name,
        reservoir_name,
        status
)

SELECT *
FROM final_metrics
ORDER BY decline_percent DESC;

-- Step 13 Well Performance Classification
-- Combine production, water cut and decline
-- to classify each well as Strong, Moderate or Needs Attention.

WITH well_metrics AS (

    SELECT
        w.well_id,
        w.well_name,
        w.field_name,
        w.reservoir_name,
        w.status,

        SUM(p.oil_bbl) AS total_oil,
        SUM(p.water_bbl) AS total_water,

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

    GROUP BY
        w.well_id,
        w.well_name,
        w.field_name,
        w.reservoir_name,
        w.status,
        p.well_id,
        p.oil_bbl,
        p.production_date
),

final_metrics AS (

    SELECT
        well_id,
        well_name,
        field_name,
        reservoir_name,
        status,

        ROUND(SUM(total_oil), 2) AS total_oil,

        ROUND(
            SUM(total_water) /
            (SUM(total_oil) + SUM(total_water)) * 100,
            2
        ) AS water_cut_percent,

        ROUND(
            (MAX(first_month_oil) - MAX(last_month_oil))
            / MAX(first_month_oil) * 100,
            2
        ) AS decline_percent

    FROM well_metrics

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

        -- High decline or high water production
        -- indicates a potential performance concern.
        WHEN decline_percent > 25
             OR water_cut_percent > 35
             OR total_oil < 2000
        THEN 'Needs Attention'

        -- Strong production with relatively low
        -- water cut and decline.
        WHEN total_oil >= 3000
             AND water_cut_percent < 25
             AND decline_percent < 20
        THEN 'Strong'

        -- Everything between the two categories.
        ELSE 'Moderate'

    END AS performance_category

FROM final_metrics

ORDER BY
    CASE
        WHEN performance_category = 'Needs Attention' THEN 1
        WHEN performance_category = 'Moderate' THEN 2
        WHEN performance_category = 'Strong' THEN 3
    END;
    
    -- Well Performance View
-- Create one reusable view containing production,
-- water cut, decline and performance category for each well.

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
-- Check the final well performance view.

SELECT *
FROM well_performance
ORDER BY total_oil DESC;


SELECT * FROM well_performance;


