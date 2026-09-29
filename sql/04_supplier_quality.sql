-- 04 Supplier quality
-- Do better-rated suppliers give lower defect rates and fewer high-defect records?
-- SupplierQuality is a decimal column, so bands use >= and < to leave no gaps
-- between them (BETWEEN would miss values like 84.995).

USE defects_analysis;

SELECT
    CASE
        WHEN SupplierQuality >= 80 AND SupplierQuality < 85 THEN '80-84.99'
        WHEN SupplierQuality >= 85 AND SupplierQuality < 90 THEN '85-89.99'
        WHEN SupplierQuality >= 90 AND SupplierQuality < 95 THEN '90-94.99'
        ELSE '95-100'
    END                               AS supplier_quality_band,
    COUNT(*)                          AS total_records,
    SUM(DefectStatus)                 AS high_defect_records,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage,
    ROUND(AVG(DefectRate), 2)         AS avg_defect_rate,
    -- Total production-run cost, NOT the price paid to the supplier
    -- (the dataset has no supplier pricing).
    ROUND(AVG(ProductionCost), 2)     AS avg_production_cost
FROM manufacturing_defects
GROUP BY supplier_quality_band
ORDER BY MIN(SupplierQuality);
