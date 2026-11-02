# Oil Well Production & Performance Analysis

## Overview

This project focuses on analyzing oil well production data using MySQL and Excel. I worked with data from 20 wells across 4 fields to understand production performance, water cut, and production decline.

The main aim was to identify the better-performing wells, compare field production, and find wells that may need further attention.

## Tools Used
- MySQL
- SQL
- Microsoft Excel

## Analysis Performed
- Total oil production and field-wise comparison
- Top 10 producing wells
- Water cut analysis
- Production decline analysis
- Active and inactive well status
- Well performance classification

## Well Performance Classification

Based on production, water cut and decline, wells were grouped into three categories:
- Strong
- Moderate
- Needs Attention

## Excel Dashboard

Created an Excel dashboard to present the analysis through KPIs, tables and charts.

### Dashboard Overview
![Dashboard Overview](Screenshots/Screenshot%202026-11-02%20171547.png)

### Well Performance Analysis
![Well Performance](Screenshots/Screenshot%202026-11-02%20172329.png)

### Monthly Production Trends
![Monthly Trends](Screenshots/Screenshot%202026-11-02%20172315.png)

## Key Findings
- Total Oil Production: 58,036.27 bbl
- Average Water Cut: 25.98%
- Active Wells: 16
- Wells Needing Attention: 8
- Highest Producing Field: Delta Field

## Project Structure

```text
oil-well-production-analysis/
│
├── SQL/
│   └── oil_well_production_analysis_final.sql
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

**Note:** The project uses synthetic production data for learning and analysis. The performance categories are based on project-defined criteria.
