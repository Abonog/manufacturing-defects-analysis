-- 08 Worst performers
-- How do the worst 10% of records by DefectRate compare to the overall data
-- on every other factor?
--
-- NTILE(10) splits rows into 10 equal-sized groups. The id tiebreaker makes the
-- split deterministic if two records ever share the same DefectRate (with
-- 15-decimal values that is practically impossible here, but it matters on
-- whole-number columns).
-- avg_defect_rate and high_defect_percentage are included to prove the filter
-- selected a genuinely different group.

USE defects_analysis;

WITH ranked_data AS (
    SELECT
        *,
        NTILE(10) OVER (ORDER BY DefectRate DESC, id ASC) AS defect_tile
    FROM manufacturing_defects
),
worst_10 AS (
    SELECT *
    FROM ranked_data
    WHERE defect_tile = 1
)

SELECT
    'Worst 10%'                       AS group_name,
    COUNT(*)                          AS records,
    ROUND(AVG(DefectRate), 2)         AS avg_defect_rate,
    ROUND(100 * AVG(DefectStatus), 2) AS high_defect_percentage,
    ROUND(AVG(ProductionVolume), 2)   AS avg_production_volume,
    ROUND(AVG(ProductionCost), 2)     AS avg_production_cost,
    ROUND(AVG(SupplierQuality), 2)    AS avg_supplier_quality,
    ROUND(AVG(DeliveryDelay), 2)      AS avg_delivery_delay,
    ROUND(AVG(QualityScore), 2)       AS avg_quality_score,
    ROUND(AVG(MaintenanceHours), 2)   AS avg_maintenance_hours,
    ROUND(AVG(DowntimePercentage), 2) AS avg_downtime_percentage,
    ROUND(AVG(InventoryTurnover), 2)  AS avg_inventory_turnover,
    ROUND(AVG(StockoutRate), 4)       AS avg_stockout_rate,
    ROUND(AVG(WorkerProductivity), 2) AS avg_worker_productivity,
    ROUND(AVG(SafetyIncidents), 2)    AS avg_safety_incidents,
    ROUND(AVG(EnergyConsumption), 2)  AS avg_energy_consumption,
    ROUND(AVG(EnergyEfficiency), 4)   AS avg_energy_efficiency,
    ROUND(AVG(AdditiveProcessTime), 2)  AS avg_additive_process_time,
    ROUND(AVG(AdditiveMaterialCost), 2) AS avg_additive_material_cost
FROM worst_10

UNION ALL

SELECT
    'Overall',
    COUNT(*),
    ROUND(AVG(DefectRate), 2),
    ROUND(100 * AVG(DefectStatus), 2),
    ROUND(AVG(ProductionVolume), 2),
    ROUND(AVG(ProductionCost), 2),
    ROUND(AVG(SupplierQuality), 2),
    ROUND(AVG(DeliveryDelay), 2),
    ROUND(AVG(QualityScore), 2),
    ROUND(AVG(MaintenanceHours), 2),
    ROUND(AVG(DowntimePercentage), 2),
    ROUND(AVG(InventoryTurnover), 2),
    ROUND(AVG(StockoutRate), 4),
    ROUND(AVG(WorkerProductivity), 2),
    ROUND(AVG(SafetyIncidents), 2),
    ROUND(AVG(EnergyConsumption), 2),
    ROUND(AVG(EnergyEfficiency), 4),
    ROUND(AVG(AdditiveProcessTime), 2),
    ROUND(AVG(AdditiveMaterialCost), 2)
FROM manufacturing_defects;
