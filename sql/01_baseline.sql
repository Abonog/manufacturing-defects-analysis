-- 01 Baseline
-- How many production records are there, and what percentage are high-defect?
-- DefectStatus is coded 0/1, so AVG(DefectStatus) is the share of 1s.

USE defects_analysis;

SELECT
    COUNT(*)                          AS total_production_records,
    SUM(DefectStatus)                 AS high_defect_records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage
FROM manufacturing_defects;
