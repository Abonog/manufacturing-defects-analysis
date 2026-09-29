-- 03 Maintenance hours
-- Does the share of high-defect records change with weekly maintenance hours?

USE defects_analysis;

-- Part A: banded view.
-- ORDER BY MIN(MaintenanceHours) sorts bands numerically; sorting by the text label
-- would put '11-15' before '6-10'.
SELECT
    CASE
        WHEN MaintenanceHours BETWEEN 0  AND 5  THEN '0-5'
        WHEN MaintenanceHours BETWEEN 6  AND 10 THEN '6-10'
        WHEN MaintenanceHours BETWEEN 11 AND 15 THEN '11-15'
        ELSE '16-23'
    END                               AS maintenance_band,
    COUNT(*)                          AS total_production_records,
    SUM(DefectStatus)                 AS high_defect_records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage
FROM manufacturing_defects
GROUP BY maintenance_band
ORDER BY MIN(MaintenanceHours);

-- Part B: hour by hour, to locate exactly where the jump happens.
-- Works because MaintenanceHours is a whole number (24 distinct values).
SELECT
    MaintenanceHours,
    COUNT(*)                          AS records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage
FROM manufacturing_defects
GROUP BY MaintenanceHours
ORDER BY MaintenanceHours;
