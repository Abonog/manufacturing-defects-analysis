-- 02 Data validation
-- For every column: missing values, min, average, and max.
-- MIN/MAX/AVG silently skip NULLs, so Missing = COUNT(*) - COUNT(column) checks completeness.
-- Min and max are left unrounded on purpose: values just inside round numbers (e.g. 80.0048)
-- are one of the signs this dataset is synthetic.

USE defects_analysis;

SELECT 'ProductionVolume' AS Variable,
       COUNT(*) - COUNT(ProductionVolume) AS Missing,
       MIN(ProductionVolume) AS Min_Value,
       ROUND(AVG(ProductionVolume), 2) AS Average_Value,
       MAX(ProductionVolume) AS Max_Value
FROM manufacturing_defects

UNION ALL
SELECT 'ProductionCost',
       COUNT(*) - COUNT(ProductionCost),
       MIN(ProductionCost), ROUND(AVG(ProductionCost), 2), MAX(ProductionCost)
FROM manufacturing_defects

UNION ALL
SELECT 'SupplierQuality',
       COUNT(*) - COUNT(SupplierQuality),
       MIN(SupplierQuality), ROUND(AVG(SupplierQuality), 2), MAX(SupplierQuality)
FROM manufacturing_defects

UNION ALL
SELECT 'DeliveryDelay',
       COUNT(*) - COUNT(DeliveryDelay),
       MIN(DeliveryDelay), ROUND(AVG(DeliveryDelay), 2), MAX(DeliveryDelay)
FROM manufacturing_defects

UNION ALL
SELECT 'DefectRate',
       COUNT(*) - COUNT(DefectRate),
       MIN(DefectRate), ROUND(AVG(DefectRate), 2), MAX(DefectRate)
FROM manufacturing_defects

UNION ALL
SELECT 'QualityScore',
       COUNT(*) - COUNT(QualityScore),
       MIN(QualityScore), ROUND(AVG(QualityScore), 2), MAX(QualityScore)
FROM manufacturing_defects

UNION ALL
SELECT 'MaintenanceHours',
       COUNT(*) - COUNT(MaintenanceHours),
       MIN(MaintenanceHours), ROUND(AVG(MaintenanceHours), 2), MAX(MaintenanceHours)
FROM manufacturing_defects

UNION ALL
SELECT 'DowntimePercentage',
       COUNT(*) - COUNT(DowntimePercentage),
       MIN(DowntimePercentage), ROUND(AVG(DowntimePercentage), 2), MAX(DowntimePercentage)
FROM manufacturing_defects

UNION ALL
SELECT 'InventoryTurnover',
       COUNT(*) - COUNT(InventoryTurnover),
       MIN(InventoryTurnover), ROUND(AVG(InventoryTurnover), 2), MAX(InventoryTurnover)
FROM manufacturing_defects

UNION ALL
SELECT 'StockoutRate',
       COUNT(*) - COUNT(StockoutRate),
       MIN(StockoutRate), ROUND(AVG(StockoutRate), 4), MAX(StockoutRate)
FROM manufacturing_defects

UNION ALL
SELECT 'WorkerProductivity',
       COUNT(*) - COUNT(WorkerProductivity),
       MIN(WorkerProductivity), ROUND(AVG(WorkerProductivity), 2), MAX(WorkerProductivity)
FROM manufacturing_defects

UNION ALL
SELECT 'SafetyIncidents',
       COUNT(*) - COUNT(SafetyIncidents),
       MIN(SafetyIncidents), ROUND(AVG(SafetyIncidents), 2), MAX(SafetyIncidents)
FROM manufacturing_defects

UNION ALL
SELECT 'EnergyConsumption',
       COUNT(*) - COUNT(EnergyConsumption),
       MIN(EnergyConsumption), ROUND(AVG(EnergyConsumption), 2), MAX(EnergyConsumption)
FROM manufacturing_defects

UNION ALL
SELECT 'EnergyEfficiency',
       COUNT(*) - COUNT(EnergyEfficiency),
       MIN(EnergyEfficiency), ROUND(AVG(EnergyEfficiency), 4), MAX(EnergyEfficiency)
FROM manufacturing_defects

UNION ALL
SELECT 'AdditiveProcessTime',
       COUNT(*) - COUNT(AdditiveProcessTime),
       MIN(AdditiveProcessTime), ROUND(AVG(AdditiveProcessTime), 2), MAX(AdditiveProcessTime)
FROM manufacturing_defects

UNION ALL
SELECT 'AdditiveMaterialCost',
       COUNT(*) - COUNT(AdditiveMaterialCost),
       MIN(AdditiveMaterialCost), ROUND(AVG(AdditiveMaterialCost), 2), MAX(AdditiveMaterialCost)
FROM manufacturing_defects

UNION ALL
SELECT 'DefectStatus',
       COUNT(*) - COUNT(DefectStatus),
       MIN(DefectStatus), ROUND(AVG(DefectStatus), 4), MAX(DefectStatus)
FROM manufacturing_defects;
