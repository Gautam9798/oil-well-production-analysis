# 🛢️ Oil Well Production & Performance Analysis

## 📌 Project Overview

An oil production surveillance and data analytics project developed using **MySQL and Microsoft Excel** to evaluate the production performance of oil wells across multiple fields.

The project analyzes oil production, water cut, production decline, and well performance to identify high-performing wells, monitor production trends, and flag wells that may require further engineering investigation.

The objective is to demonstrate how production data can support well performance monitoring and data-driven engineering decisions.

## 🛠️ Tools & Technologies

- **MySQL:** Database management and data analysis
- **SQL:** Data extraction, aggregation, joins, CTEs, subqueries and window functions
- **Microsoft Excel:** KPI reporting, data visualization and interactive-style dashboard presentation

## 📊 Dataset Overview

| Parameter | Details |
|---|---|
| Total Wells | 20 |
| Number of Fields | 4 |
| Production Period | January – June 2026 |
| Production Records | 120 well-month observations |
| Dataset Type | Synthetic |
| Analysis Level | Well-wise and Field-wise |

**Note:** The dataset is synthetically generated for analytical and educational purposes. It does not represent actual operating data from any oilfield or operator.

## 🔍 Analysis Performed

### 1. Production Analysis
- Calculated total oil production across all wells.
- Analyzed field-wise oil production.
- Identified the top 10 producing wells.
- Evaluated active and inactive well status.

### 2. Water Cut Analysis
- Calculated water cut for individual wells.
- Compared water cut across different wells and fields.
- Identified wells with relatively high water-cut percentages.

### 3. Production Decline Analysis
- Evaluated first-to-last production reduction over the observation period.
- Compared production performance across wells and fields.
- Identified wells showing relatively higher production reduction.

### 4. Well Performance Classification

Wells were classified into three categories based on cumulative oil production, water cut and production reduction:

- **Strong:** Wells demonstrating relatively better production performance.
- **Moderate:** Wells showing intermediate performance.
- **Needs Attention:** Wells flagged for further production performance investigation.

The classification uses project-defined screening thresholds and should not be interpreted as a universal industry standard or a root-cause diagnosis.

## 📈 Excel Dashboard

An Excel dashboard was developed to summarize the analysis through key performance indicators and visualizations.

### Dashboard Overview

![Oil Well Production Dashboard](Screenshots/dashboard_overview.png)

### Well Performance Analysis

![Top Producing Wells and Water Cut Analysis](Screenshots/well_performance.png)

### Monthly Production Trends

![Monthly Oil Production Trend](Screenshots/monthly_trends.png)

## 📌 Key Performance Indicators

- Total Oil Production
- Average Water Cut
- Average First-to-Last Production Reduction
- Active Wells
- Wells Requiring Attention

## 💡 Key Findings

- **Total Oil Production:** 58,036.27 bbl
- **Average Water Cut:** 25.98%
- **Average First-to-Last Production Reduction:** 21.41%
- **Active Wells:** 16
- **Wells Needing Attention:** 8
- **Highest Producing Field:** Delta Field (16,727.63 bbl)

These findings are based on the synthetic dataset and the project's defined calculation methodology.

## 📂 Project Structure

```text
oil-well-production-analysis/
│
├── SQL/
│   └── oil_well_production_analysis.sql
│
├── Excel/
│   └── Oil_Well_Production_Analysis_SLb_Ready.xlsx
│
├── Screenshots/
│   ├── dashboard_overview.png
│   ├── well_performance.png
│   └── monthly_trends.png
│
└── README.md
```

## ⚙️ Methodology & Important Calculations

**Water Cut (%)**

Water Cut = Water Production / (Oil Production + Water Production) × 100

**First-to-Last Production Reduction (%)**

Production Reduction = [(Initial Oil Production − Final Oil Production) / Initial Oil Production] × 100

Note: This production reduction metric represents the percentage change between the first and last observations. It is not an Arps decline-rate estimate or an annualized decline rate.

## ⚠️ Project Limitations

- The dataset is synthetic and based on predefined assumptions.
- The analysis covers six monthly observations.
- Performance classifications use project-defined thresholds.
- Identifying a well as requiring attention does not establish the actual cause of underperformance.
- Further investigation would require additional operating data such as flowing pressure, downtime, choke settings, artificial-lift parameters and well test information.

## 🎯 Learning Outcomes

- Applied SQL techniques to petroleum production datasets.
- Developed production surveillance and well performance KPIs.
- Analyzed water cut and production trends.
- Used Excel to build a structured production monitoring dashboard.
- Connected data analytics with practical petroleum engineering applications.

---

**Developed using MySQL, SQL and Microsoft Excel.**

*Petroleum Engineering | Production Surveillance | Data Analytics*
