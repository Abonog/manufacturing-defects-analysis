-- 05 Delivery delay
-- Do late deliveries go with more high-defect records?
-- DeliveryDelay has only 6 whole-number values (0-5 days), so no bands are needed.

USE defects_analysis;

SELECT
    DeliveryDelay,
    COUNT(*)                          AS total_production_records,
    SUM(DefectStatus)                 AS high_defect_records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage
FROM manufacturing_defects
GROUP BY DeliveryDelay
ORDER BY DeliveryDelay;
