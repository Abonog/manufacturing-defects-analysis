-- 00 Setup: create the database and table, then load the Kaggle CSV.
-- Dataset: https://www.kaggle.com/datasets/rabieelkharoua/predicting-manufacturing-defects-dataset
--
-- Notes:
--   * Decimal columns use DOUBLE: values have up to 15 decimal places, and FLOAT or a
--     tight DECIMAL would silently lose precision.
--   * The CSV has no ID column, so an AUTO_INCREMENT id is added. It is used as a
--     deterministic tiebreaker for window functions (see 08_worst_10_percent.sql).

CREATE DATABASE IF NOT EXISTS defects_analysis;
USE defects_analysis;

DROP TABLE IF EXISTS manufacturing_defects;

CREATE TABLE manufacturing_defects (
    id                   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductionVolume     INT,
    ProductionCost       DOUBLE,
    SupplierQuality      DOUBLE,
    DeliveryDelay        INT,
    DefectRate           DOUBLE,
    QualityScore         DOUBLE,
    MaintenanceHours     INT,
    DowntimePercentage   DOUBLE,
    InventoryTurnover    DOUBLE,
    StockoutRate         DOUBLE,
    WorkerProductivity   DOUBLE,
    SafetyIncidents      INT,
    EnergyConsumption    DOUBLE,
    EnergyEfficiency     DOUBLE,
    AdditiveProcessTime  DOUBLE,
    AdditiveMaterialCost DOUBLE,
    DefectStatus         TINYINT
);

-- Update the file path to where you saved the CSV.
-- Requires local_infile to be enabled on both the server and the client.
-- Alternative: MySQL Workbench's Table Data Import Wizard (slower, no setup needed).
LOAD DATA LOCAL INFILE '/path/to/manufacturing_defect_dataset.csv'
INTO TABLE manufacturing_defects
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ProductionVolume, ProductionCost, SupplierQuality, DeliveryDelay, DefectRate,
 QualityScore, MaintenanceHours, DowntimePercentage, InventoryTurnover, StockoutRate,
 WorkerProductivity, SafetyIncidents, EnergyConsumption, EnergyEfficiency,
 AdditiveProcessTime, AdditiveMaterialCost, DefectStatus);

-- Sanity check: expect 3240 rows.
SELECT COUNT(*) AS rows_loaded FROM manufacturing_defects;
