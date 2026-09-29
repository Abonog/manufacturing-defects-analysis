-- 06 Production volume
-- Do large production runs have more high-defect records than small ones?
-- ProductionVolume runs from 100 to 999 (900 distinct values), so it is banded
-- in steps of 100 units, giving each band roughly 330-390 records.

USE defects_analysis;

SELECT
    CASE
        WHEN ProductionVolume < 200 THEN '100-199'
        WHEN ProductionVolume < 300 THEN '200-299'
        WHEN ProductionVolume < 400 THEN '300-399'
        WHEN ProductionVolume < 500 THEN '400-499'
        WHEN ProductionVolume < 600 THEN '500-599'
        WHEN ProductionVolume < 700 THEN '600-699'
        WHEN ProductionVolume < 800 THEN '700-799'
        WHEN ProductionVolume < 900 THEN '800-899'
        ELSE '900-999'
    END                               AS production_volume_band,
    COUNT(*)                          AS total_production_records,
    SUM(DefectStatus)                 AS high_defect_records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage
FROM manufacturing_defects
GROUP BY production_volume_band
ORDER BY MIN(ProductionVolume);
