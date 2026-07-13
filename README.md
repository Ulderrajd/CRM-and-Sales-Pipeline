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

# Step 1: Inital Review and Exploring <br />

Initial review focused on the columns most relevant to funnel and outcome analysis: Status, Status sequence, Stage, Stage sequence, Deal Value, and Probability. These steps are done using Excel Pivot Table. <br />

**Status and Status sequence** <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image.png?w=591) <br />
**Industry** <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-3-3.png?w=438) <br />
**Country** <br />
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-1.png?w=289) <br />

**Null value handling**
- The Status sequence values in the raw data did not match the data dictionary and were corrected to align with it.
- 2,133 records have null Stage and Stage sequence values. This is expected, Stage and Stage sequence only apply once a record reaches Status = “Opportunity” (Status sequence = 4).

![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-1-3.png?w=356)

- Actual close date has 2,652 null values, which is also expected, this field only populates once a lead becomes a customer (Status sequence = 5) or churns (Status sequence = 6).
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-3.png?w=298)

Overall, these nulls are structural, not data-quality defects, and require no imputation or cleanup.

# Step 2: Analyze

Two questions anchor this stage of the analysis:

- Where is the pipeline bottleneck?
- Where is the business losing value, through churned customers and lost deals?

**Pipeline Health: Locating the Bottleneck**
This dataset is a **point-in-time snapshot**, not a cohort tracked over time. As a result, whether current leads (or records sitting in earlier stages) will eventually convert is unknown, and a traditional time-based funnel-conversion analysis isn’t appropriate here. <br />

Instead, records are split into two states:

- **Resolved:** Disqualified, Customer, Churned Customer, and Won/Lost (the two terminal stages within Opportunity status)
- **Active:** New, Qualified, Sales Accepted, and Opportunity (excluding Won and Lost)

One modeling decision worth flagging: per the data dictionary, reaching the “Won” stage does not by itself confirm the lead has become a paying customer. This analysis treats “Won” as Resolved regardless, to avoid adding an extra unresolved category, a simplification, not a data fact. <br />

Of all leads, the majority are still moving through the pipeline and have not yet reached a final outcome. Among the leads that **have** reached a resolved state (Customer, Churned, Won, Lost, or Disqualified), the large majority converted to paying customers. <br />

![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-3-8.png?w=591)
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-3-7.png?w=593)

Opportunities carry the largest share of active leads. Within that, the earliest three sub-stages (Initial contact, Nurturing, and Opened) account for roughly two-thirds of all active records. This concentration suggests friction in the early relationship-building stages, which would create a likely bottleneck, but confirming this requires stage-transition (cohort-level) data that isn’t available in this snapshot.

**Lead Distribution**

**Business question:** which countries and industries have the most customers, and which represent the most future potential?

Four metrics anchor this analysis: Total Leads, Successful Deals, % of Successful Deals (among Resolved deals), and Average Value of Successful Deals:

- **Total Leads** tells us where the pipeline volume is concentrated. It can show how big the opportunity is.
- **Successful Deals** is the actual output. However, it may be biased toward whichever country, industry… has the larger “total leads”. A bigger market tends to produce more wins just because of the massive size.
- **% of Successful Deals over Resolved** corrects for that bias, measuring win rate independent of volume.
- **Average Value of Successful Deals** measures the average value of won deals.

<img width="1112" height="557" alt="image" src="https://github.com/user-attachments/assets/535bf216-e71f-4997-bc44-5e51a9d9cbeb" />
Overall resolved/won/lost split <br />

Resolved outcomes account for roughly a fifth of total leads — likely reflecting how time-consuming the lead-to-close journey is. Among resolved deals, about two-thirds are Won, with roughly a third Lost. <br />

*By Country*
<img width="1607" height="546" alt="image" src="https://github.com/user-attachments/assets/d70f532d-f9df-43f1-9c46-82cabeb8abc0" />
Country-level lead distribution table

- Italy, France, and Germany generate the most leads and the most successful deals.
- The Netherlands stands out with the highest win rate.
- Germany produces the highest average value per successful deal.

To identify the most promising countries, each metric was scored on a 1–5 scale and summed into a composite score. By this method, **Germany, Italy, and the Netherlands** rank as the most prominent markets.

*By Industry*
<img width="1855" height="653" alt="image" src="https://github.com/user-attachments/assets/b0e77e29-fff0-4700-b7d0-cdc17045ca44" />
Industry-level lead distribution table

- Transportation & Logistics, Banking & Finance, and IT & IT Services generate the most leads and successful deals.
- Retail & Distribution has the highest win rate (74%).
- Education & Science and Government Administration/Healthcare generate the highest average value per successful deal.

Using the same composite scoring method, **Government Administration/Healthcare** and **Transportation & Logistics** rank highest, with Education & Science, Retail & Distribution, Banking & Finance, and IT & IT Services also notable.

*By Product*
<img width="1645" height="397" alt="image" src="https://github.com/user-attachments/assets/f4e79a72-57b9-408c-a5e5-e0df3c8be182" />
Product-level lead distribution table

- SAAS has the most leads and successful deals, but the lowest average deal value.
- Custom Solution has the highest win rate and highest average deal value, but represents a small share of total leads.

Each product carries distinct trade-offs: SAAS and Services account for the bulk of lead volume, but SAAS deals are comparatively low-value and Services doesn’t guarantee a strong win rate. Custom Solution is the most lucrative per deal but under-represented in overall volume, a plausible area for deliberate growth investment rather than a segment to scale purely on current traction. <br />

**Sales Team Performance**
<img width="1657" height="561" alt="image" src="https://github.com/user-attachments/assets/d612fdf3-9ab6-4259-bcd8-3c8adb5c5d71" />
Sales rep performance table

- Laura Thompson has the highest lead volume and the most successful deals, which offsets a comparatively lower average value per deal.
- Kevin Anderson and Laura Thompson post the highest win rates.
- David Wilson underperforms across every measured metric and warrants a closer look.

Using the same 1–5 composite scoring approach, **Laura Thompson** ranks highest, followed by Jessica Martinez and Kevin Anderson. **David Wilson** ranks lowest and is a reasonable candidate for coaching or performance review.

**Churn and Lost Deals**
**Churned Customers**
Among established customers, 49.1% have churned, representing 45.7% of total historical deal value.
![](https://billybonka1602.wordpress.com/wp-content/uploads/2026/07/image-1-4.png?w=700)
Churn overview




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
