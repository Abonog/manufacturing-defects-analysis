# What Drives High-Defect Production? A Manufacturing Quality Analysis

An end-to-end analysis of 3,240 manufacturing production records in two parts: **SQL (MySQL)** to answer the stakeholder's business questions, and **Python** (pandas, seaborn, scipy, scikit-learn) to go deeper with distributions, statistical tests, a risk rule, and a decision tree.

I'm a Quality Engineer in the automotive industry moving into quality data analytics. This project applies the questions I'd ask on the shop floor to a public dataset, using SQL and Python instead of manual analysis.

![Dashboard](images/dashboard.png)

---

## The business question

**Stakeholder:** a Plant Operations Director preparing next year's budget.
**Question:** where should money go to reduce high-defect production: maintenance, suppliers, logistics, or production planning?

## Headline finding

**The "high-defect" label is triggered by four operational thresholds, not by the measured defect rate.** A record is labeled high-defect if *any one* of these is true:

| Threshold | High-defect rate below → above |
|---|---|
| Maintenance hours > 10 per week | about 70% → about 95% |
| Quality score < 75 | 77% → 96% |
| Production volume > 800 units | about 80% → 96–98% |
| Defect rate > 3 | about 74% → about 96% |

This four-rule checklist flags **99.5%** of high-defect records, with **96%** of flags correct. A decision tree given all 16 factors and no guidance found **the same four rules**, with the same accuracy on unseen data (95.5%).

## The dataset

- **Source:** [Predicting Manufacturing Defects Dataset](https://www.kaggle.com/datasets/rabieelkharoua/predicting-manufacturing-defects-dataset) (Kaggle). See `data/README.md`.
- **Size:** 3,240 records × 17 numeric columns: production (volume, cost), supply chain (supplier quality, delivery delay), quality (defect rate, quality score), maintenance, and energy.
- **Label:** `DefectStatus`, where 1 = high defects and 0 = low defects (84% of records are 1).
- **No IDs, dates, or categories**, so all grouping is done by building bands.

> **Note on the data:** this dataset is almost certainly synthetic. Every column is evenly spread across its range, averages sit at the range midpoints, and the label changes in sharp one-step cliffs. The findings demonstrate analysis methods and judgment; they aren't conclusions about a real plant.

## Repository structure

```
sql/
  00_setup.sql              create the table and load the CSV
  01_baseline.sql           overall high-defect share
  02_data_validation.sql    completeness and range checks for all 17 columns
  03_maintenance_hours.sql  banded and hour-by-hour view
  04_supplier_quality.sql   supplier quality bands
  05_delivery_delay.sql     delivery delay (0-5 days)
  06_production_volume.sql  production volume bands
  07_cost_per_unit.sql      cost per unit, plus a confounding check
  08_worst_10_percent.sql   worst 10% by defect rate vs. overall (NTILE)
  09_label_consistency.sql  does the label match the defect rate?
python/
  manufacturing_defects_analysis.ipynb   questions 1-8, with outputs
images/                     charts used in this README
presentation/               stakeholder deck (PowerPoint)
data/                       download instructions for the CSV
```

**To run:** download the CSV into `data/`. For SQL, run `00_setup.sql` in MySQL (update the CSV path), then any numbered file. For Python, `pip install -r requirements.txt` and open the notebook from the `python/` folder.

---

## Part 1: SQL findings

| # | Question | Finding |
|---|---|---|
| 1 | Baseline | 84% of records (2,723 of 3,240) are high-defect. Low-defect production is the exception. |
| 2 | Can the data be trusted? | Valid and complete: no missing or impossible values. But averages sit at range midpoints, a sign of synthetic data. |
| 3 | Maintenance hours | Sharp cliff above **10 hours/week**: about 70% high-defect at 0–10 hours, 91–99% from 11 hours up. |
| 4 | Supplier quality | **No effect.** 82–87% high-defect across all rating bands. |
| 5 | Delivery delay | **No effect.** 82–85% high-defect whether on time or 5 days late. |
| 6 | Production volume | Sharp cliff above **about 800 units**: 78–84% below, 96–98% above. |
| 7 | Cost of poor quality | High-defect records *look* about $5/unit cheaper, but that's caused by production volume. Holding volume steady, the gap disappears. |
| 8 | Worst 10% by defect rate | Identical to the overall data on every operational factor. |
| 9 | Label consistency | 45% of high-defect records have a *below-average* defect rate. Maintenance and volume explain 84% of these mismatches, leaving a puzzle for Part 2. |

## Part 2: Python findings

| # | Question | Finding |
|---|---|---|
| 1 | Distributions | Every column is close to uniform, confirming synthetic data. Apparent spikes in maintenance hours were a binning artifact (24 whole-number values in 20 bins). |
| 2 | Correlations | Only four factors stand out: maintenance hours (0.30), defect rate (0.25), quality score (−0.20), production volume (0.13). Correlation understates them, because they're cliffs, not straight lines. |
| 2b | Closing SQL Q9 | Quality score has a cliff at **75**. Adding it explains **98.9%** of the label mismatches (up from 84%). |
| 3 | Box plots | All four medians differ, but the boxes overlap heavily: no single factor separates the groups on its own. |
| 4 | Tipping point | Confidence bands show the 0–10 hour zigzag is noise, and the jump at 11 hours is real. |
| 5 | Hypothesis tests | Quality score gap of 6.3 points: significant (p < 0.001), medium effect (d ≈ 0.6), confirmed by Mann-Whitney. Delivery delay: no association (chi-square p = 0.68). |
| 6 | Risk rule | Studying only the records the 3-rule version missed revealed a fourth rule (defect rate > 3). The 4-rule checklist catches 99.5% of high-defect records. |
| 7 | Decision tree | Independently found the same four rules (10.5 / 2.99 / 74.88 / 802). Same 95.5% test accuracy as the hand-built rule. |
| 8 | Dashboard | Four panels, each titled with its conclusion (shown at the top of this page). |

![Maintenance tipping point](images/maintenance_tipping_point.png)

## What this means for the Director

1. **Production volume is the most actionable lever.** Run size is planned before production, so it can't be a result of defects. Before scheduling runs over 800 units, check what changes at that scale: line speed, shift length, tool wear, inspection coverage.
2. **Maintenance hours are a warning sign, not a cause.** Use more than 10 hours/week as an early-warning flag for root-cause investigation, **not** as a reason to cut maintenance.
3. **Quality score below 75 is a reliable early signal**, and the four-rule checklist could screen production records before inspection results are in.
4. **Supplier ratings and delivery delays don't matter here.** Budget aimed at premium suppliers or faster logistics wouldn't be expected to reduce high-defect production. (No supplier pricing, so value for money can't be assessed.)
5. **Confirm the label's definition before it drives decisions.** A metric called "defect status" that disagrees with the defect rate for nearly half of high-defect records should be checked with whoever defined it.

---

## Lessons learned

### Analytical judgment

- **A correct query can still give a misleading answer (confounding).** High-defect records appeared cheaper per unit because large runs are both mostly high-defect *and* cheaper per unit. Filtering to runs under 800 units made the gap vanish (37.24 vs. 37.39).
- **"No correlation" is not "no relationship."** Production volume's correlation is only 0.13, yet it has a 17-point cliff.
- **Signal vs. noise.** Differences of 2–5 points between bands of 500–800 records aren't findings; the 17–30 point cliffs are. Confidence bands and hypothesis tests made this formal.
- **Significant isn't the same as important.** With 3,240 records even tiny gaps get tiny p-values, so effect size (Cohen's d) is reported alongside.
- **Compare rates, not counts.** 1,583 high-defect records above the quality cutoff sounded alarming, until converted to a rate (77% vs. 96% below).
- **Study the unexplained part.** The fourth rule only became visible after removing records already explained by the first three, the same logic as root-cause analysis.
- **Chart settings can create or hide patterns.** Histogram bins created fake spikes; an uncentered heatmap scale made every cell look related; a truncated y-axis exaggerated noise.
- **Correlation isn't causation, and domain knowledge tells you which way it runs.** More maintenance going with more defects doesn't mean maintenance causes defects.
- **A null result is a result.** Showing that suppliers and delivery delays don't matter is as valuable as showing what does.

### SQL

- **Dividing twice.** `100 * AVG(DefectStatus) / COUNT(*)` made every result about 1,000 times too small. Caught by comparing against the 84% baseline.
- **Text labels sort as text** (`'11-15'` before `'6-10'`). Fixed with `ORDER BY MIN(<numeric column>)`.
- **`BETWEEN` is only safe on whole numbers**; decimal columns use `>=` and `<`.
- **`MIN`/`MAX`/`AVG` ignore NULLs**, so completeness needs `COUNT(*) - COUNT(column)`.
- **`NTILE` splits by row count, not value**, so ties need a tiebreaker (`ORDER BY value, id`).
- **Use `DOUBLE` for 15-decimal data** to avoid silent precision loss on import.

### Python

- **Off-by-one cutoffs.** `>= 10` instead of `> 10` pulled in hour 10, the *lowest* point on the chart, adding 43 false alarms.
- **Stale variables.** A dashboard panel showed the old 3-rule results because its table was built before the rule changed. Rebuilding inputs at the top of the cell prevents it.
- **Data leakage.** A helper column (`DefectStatus × 100`) was the answer in disguise; the model's inputs are listed explicitly so it can't see it.

---

## Limitations

- Synthetic data: the findings show method, not facts about a real process.
- No dates, so no trends over time or SPC control charts.
- `ProductionCost` likely excludes the real cost of poor quality (scrap, rework, warranty, returns).
- No supplier pricing, so supplier value for money can't be assessed.
- 13 high-defect records (0.5%) aren't explained by any rule, likely random noise added by the data generator.

---

*Author: Areej · [github.com/Abonog](https://github.com/Abonog)*
