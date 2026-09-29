-- 07 Cost of poor quality
-- Does high-defect production cost more (or less) per unit?

USE defects_analysis;

-- Part A: naive comparison across all records.
-- Result: high-defect records look about $5 cheaper per unit.
SELECT
    CASE WHEN DefectStatus = 1 THEN 'High' ELSE 'Low' END AS defect_status,
    COUNT(*)                                          AS total_records,
    ROUND(AVG(ProductionCost / ProductionVolume), 2)  AS avg_cost_per_unit
FROM manufacturing_defects
GROUP BY defect_status;

-- Part B: confounding check.
-- Large runs (> ~800 units) are almost all high-defect AND have a lower cost per unit,
-- because cost is spread over more units. Holding volume steady removes that effect.
-- Result: the gap disappears, so volume, not quality, explained Part A.
SELECT
    CASE WHEN DefectStatus = 1 THEN 'High' ELSE 'Low' END AS defect_status,
    COUNT(*)                                          AS total_records,
    ROUND(AVG(ProductionCost / ProductionVolume), 2)  AS avg_cost_per_unit
FROM manufacturing_defects
WHERE ProductionVolume < 800
GROUP BY defect_status;
