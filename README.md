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
+ [Data Pipeline](#Data-Pipeline)
+ [Process](#Process)
+ [Key Findings](#Key-Finfings)
+ [Recommendations](#Recommendations)
+ [Limitations](#Limitations)
+ [Dashboard](#Dashboard)

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

## Data Pipeline
Files in the following stages:
+ Inital Review and Exploring: Cleaning, validating and basic analyzing. [Excel](CRM-and-Sales-Pipeline.xlsx)
+ Exploratory Data Analysis: Detailed analyzing. [SQL Script](CRM_SQL_query.sql)
+ Dashboard building: Load, Power Query, measuring with DAX and building Dashboard [Dashboard](CRM-and-Sales-Pipeline.pdf)

---

## Process

**Step 1: Inital Review and Exploring** <br />

Initial review focused on the columns most relevant to funnel and outcome analysis: Status, Status sequence, Stage, Stage sequence, Deal Value, and Probability. These steps are done using Excel Pivot Table. <br />

Status and Status sequence <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image.png?w=591) <br />
Industry <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-3-3.png?w=438) <br />
Country <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-1.png?w=289) <br />

**Null value handling**

- The Status sequence values in the raw data did not match the data dictionary and were corrected to align with it.
- 2,133 records have null Stage and Stage sequence values. This is expected, Stage and Stage sequence only apply once a record reaches Status = “Opportunity” (Status sequence = 4).

![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-1-3.png?w=356)

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
