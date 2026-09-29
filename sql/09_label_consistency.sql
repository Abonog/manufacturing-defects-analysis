-- 09 Label consistency
-- Does the DefectStatus label agree with the actual DefectRate?

USE defects_analysis;

-- Part A: mismatches, as counts and as a share of each label group.
-- The CROSS JOIN attaches the overall average defect rate to every row.
SELECT
    SUM(CASE WHEN DefectStatus = 1 THEN 1 ELSE 0 END) AS high_defect_total,
    SUM(CASE WHEN DefectStatus = 1 AND DefectRate < a.avg_rate
             THEN 1 ELSE 0 END)                       AS high_defect_but_low_rate,
    ROUND(100 * SUM(CASE WHEN DefectStatus = 1 AND DefectRate < a.avg_rate THEN 1 ELSE 0 END)
              / SUM(CASE WHEN DefectStatus = 1 THEN 1 ELSE 0 END), 2)
                                                      AS pct_of_high_defect,
    SUM(CASE WHEN DefectStatus = 0 THEN 1 ELSE 0 END) AS low_defect_total,
    SUM(CASE WHEN DefectStatus = 0 AND DefectRate > a.avg_rate
             THEN 1 ELSE 0 END)                       AS low_defect_but_high_rate,
    ROUND(100 * SUM(CASE WHEN DefectStatus = 0 AND DefectRate > a.avg_rate THEN 1 ELSE 0 END)
              / SUM(CASE WHEN DefectStatus = 0 THEN 1 ELSE 0 END), 2)
                                                      AS pct_of_low_defect
FROM manufacturing_defects
CROSS JOIN (
    SELECT AVG(DefectRate) AS avg_rate
    FROM manufacturing_defects
) AS a;

-- Part B: how many "high-defect but low-rate" records fall into the two risk zones
-- found in questions 3 and 6 (maintenance > 10 hours, production volume > 800)?
SELECT
    COUNT(*) AS high_label_low_rate,
    SUM(CASE WHEN MaintenanceHours > 10 OR ProductionVolume > 800
             THEN 1 ELSE 0 END) AS explained_by_risk_zones,
    ROUND(100 * SUM(CASE WHEN MaintenanceHours > 10 OR ProductionVolume > 800
                         THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_explained
FROM manufacturing_defects
WHERE DefectStatus = 1
  AND DefectRate < (SELECT AVG(DefectRate) FROM manufacturing_defects);
