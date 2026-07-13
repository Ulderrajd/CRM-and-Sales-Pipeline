# CRM Sales Pipeline Analysis

A B2B sales pipeline case study covering lead-to-close performance, lead distribution,
sales rep performance, customer churn, and lost-deal analysis — built with SQL (SQLite)
for exploration and Power BI for the interactive dashboard.

---

## Overview & Objects

This project analyzes a CRM dataset of B2B deal and lead records across European markets
to answer three linked business questions:

1. **Where is the sales pipeline losing momentum**, and which stage is the most likely
   bottleneck?
2. **Which countries, industries, and products** represent the strongest opportunities,
   and which sales reps are over- or under-performing relative to their peers?
3. **Where is revenue being lost** and which segments carry the most risk?

The full write-up, including methodology and every supporting chart, is in [Notion](https://cyan-leader-38f.notion.site/CRM-Pipeline-analysis-3958a3d3282080f49983e6d32919ca28?pvs=74)

---

## Table of Content
+ [Dataset](#Dataset)
+ [Tools & Approach](#Tools-&-Approach)
+ 


## Dataset

- **Scope:** B2B deal/lead records, European markets, 2024
- **Key fields:** `Status`, `Status sequence`, `Stage`, `Stage sequence`, `Deal Value`,
  `Probability`, `Owner`, `Country`, `Industry`, `Product`, `Lead acquisition date`,
  `Expected close date`, `Actual close date`
- **Null handling:** nulls in `Stage`/`Stage sequence` and `Actual close date` are
  **structural**, not data-quality issues — they reflect fields that only populate once a
  record reaches a specific status (see write-up, Section 3.1). No imputation was applied.

---

## Tools & Approach

| Tool | Purpose |
|---|---|
| SQLite / SQL | Data cleaning, exploratory analysis, cohort-style breakdowns (multi-CTE queries) |
| Power BI / DAX | Interactive dashboard — Overview, Sales, and Agents tabs |
| DB Browser for SQLite | Query development and validation |

---

## Methodology Summary

1. **Clean:** validated `Status sequence` against the data dictionary; confirmed all null
   patterns were structural (tied to pipeline stage, not missing data).
2. **Classify outcomes:** since the dataset is a point-in-time snapshot rather than a
   cohort tracked over time, deals were split into **Resolved** (Won, Lost, Disqualified,
   Customer, Churned Customer) and **Active** (New, Qualified, Sales Accepted, Opportunity)
   states rather than modeled as a time-based conversion funnel.
3. **Score and rank:** countries, industries, products, and reps were each scored on a
   1–5 scale across four metrics (lead volume, win count, win rate, average deal value)
   and ranked by composite score.
4. **Build the dashboard:** three Power BI tabs — Overview, Sales, Agents — surface the
   findings interactively.

---

## Dashboard

| Tab | Focus |
|---|---|
| **Overview** | Pipeline stage distribution, product mix, monthly value trends |
| **Sales** | Win rate, sales cycle length, stage bottlenecks, country performance |
| **Agents** | Rep-level leaderboard, win rate, and churn/loss contribution |


---

## Key Findings

- The pipeline is heavily weighted toward **Still Active** — the majority of leads haven't
  reached a resolved outcome yet, which limits how confidently conversion rate can be
  stated (see [Limitations](#limitations)).
- The largest concentration of active deals sits in the **earliest three sub-stages**
  (Initial contact, Nurturing, Opened) — a plausible bottleneck, though confirming this
  would require stage-transition data this snapshot doesn't contain.
- **Custom Solution** is disproportionately valuable: ~18.6% of leads generate ~22.65% of
  won value, compared to SAAS at ~43.17% of leads for ~38.77% of won value.
- **Germany, Italy, and the Netherlands** rank highest on the composite country
  opportunity score — though Germany, Switzerland, Spain, and Italy also show churn rates
  above 50%, meaning opportunity and retention risk aren't mutually exclusive signals here.
- **Laura Thompson** ranks highest on the composite rep performance score (highest volume
  and win count); **David Wilson** ranks lowest across every measured metric.
- Lost deals account for **35.6%** of resolved-deal count and **39%** of resolved-deal
  value — a meaningfully high loss rate worth investigating further.

---

## Recommendations

- Prioritize understanding the **post-Q2 revenue decline** — the dataset shows the pattern
  but can't distinguish seasonality from an execution gap.
- Focus process improvements on **accelerating Nurturing → Proposal Sent**, since that's
  where the largest share of active deals is currently concentrated.
- Increase investment in **Custom Solution**, given its outsized value contribution
  relative to lead volume.
- Review account health specifically in **Education & Science** (70% churn) and in deals
  owned by reps with high absolute lost/churn value contribution, independent of their
  overall win-rate performance.

---

## Limitations

- **Snapshot, not cohort data:** this dataset captures a single point in time. Conversion
  and bottleneck claims are directional hypotheses based on current-state distribution,
  not confirmed time-based funnel conversion rates.
- **Dataset size discrepancy:** an earlier draft of the write-up states 7 columns and
  3,000 rows; the schema used throughout this analysis has 17 columns, and later work in
  this project references a row count closer to 6,300. **This should be verified and
  corrected before the write-up is treated as final.**
- **"Won" stage classification:** deals in the "Won" stage are treated as Resolved
  throughout this analysis, even though the data dictionary notes this doesn't strictly
  confirm customer conversion. This is a deliberate simplification, not a data fact.

---

## Repository Structure

```
├── Data/
│   └── CRM and Sales Pipelines.xlsx        # Source dataset
├── Working File/
│   ├── CRM Pipeline Dashboard.pbix         # Power BI dashboard (Overview, Sales, Agents tabs)
│   └── CRM_SQL_query.xml                   # Saved SQL queries (cleaning, funnel, distribution, churn/loss)
└── README.md
```

---

Portfolio project — built to demonstrate SQL analysis, DAX measure design, and BI
dashboard development on a realistic B2B sales dataset. Findings are framed for
stakeholder review; see the [Limitations](#limitations) section for what these
results can and can't support.
