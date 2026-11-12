# Consumer Complaint Analysis

> An end-to-end analysis of **62,516 consumer complaints** (CFPB, 2017–2023): a SQL extraction query, an interactive four-page Power BI dashboard, and a written report of findings, KPIs and recommendations.

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-MySQL%20syntax-4479A1?logo=mysql&logoColor=white)
![Data](https://img.shields.io/badge/Data-CFPB%20complaints%202017--2023-1F6F8B)

![Executive Complaint Overview dashboard](images/01-executive-complaint-overview.png)

## Table of Contents

1. [Overview](#overview)
2. [Business Questions](#business-questions)
3. [Repository Contents](#repository-contents)
4. [Data](#data)
5. [SQL Query](#sql-query)
6. [Dashboard](#dashboard)
7. [Key Insights](#key-insights)
8. [KPI Definitions](#kpi-definitions)
9. [Recommendations](#recommendations)
10. [Limitations and Notes](#limitations-and-notes)
11. [How to Use](#how-to-use)
12. [Tools](#tools)
13. [Author](#author)

## Overview

Consumers file complaints about financial products and services with the U.S. Consumer Financial Protection Bureau (CFPB), which forwards them to the companies concerned. This project turns that complaint data into decision-ready insight:

- **Extract:** a SQL query adds year, month and a processing-timeline field to the complaints table.
- **Visualise:** a four-page Power BI report, with Year, State and Submission-mode filters on every page.
- **Interpret:** a written report covering findings, business insights, recommendations, KPI definitions and data limitations.

Workflow: `consumer.consumer_complaints` → `query.sql` → Power BI model (`Query1`) → four-page dashboard (`week4.pbix`, `week4.pdf`) → written report.

**At a glance**

| Metric | Value |
|---|---|
| Complaints analysed | 62,516 (2017–2023) |
| Largest product category | Checking or savings account: 24.81K (39.69%) |
| Complaints with a timely response | 93.77% (58.62K) |
| Average forwarding timeline | 1.22 days |
| Most common company response | Closed with explanation |
| Most common submission channel | Web: 72.66% (45.42K) |

## Business Questions

| # | Question | Where to look |
|---|---|---|
| 1 | How have complaint volumes changed between 2017 and 2023? | Page 1, Page 4 (annual and monthly trends) |
| 2 | Which financial products have the highest complaint volumes? | Page 1 (product distribution), Page 2 |
| 3 | What are the most frequently reported consumer issues? | Page 2 |
| 4 | How do reported issues differ across financial product categories? | Page 2 (product-versus-issue table) |
| 5 | How much time passes between CFPB receipt and forwarding to the company? | Pages 1, 3 and 4 |
| 6 | What company response categories are most frequently recorded? | Page 3 |
| 7 | What percentage of complaints has a recorded timely response? | Pages 1 and 3 |
| 8 | Have complaint patterns and company response categories changed over time? | Pages 3 and 4 (use the Year slicer) |
| 9 | Can historical complaint patterns support future volume forecasting? | Page 4 (annual and monthly history) |
| 10 | How can stakeholders explore validated complaint insights interactively? | The Power BI report (Year, State and Submission-mode slicers) |

## Repository Contents

```text
.
├── README.md
├── query.sql
├── week4.pbix
├── week4.pdf
├── consumer_complaint_analysis1.pdf
└── images/
    ├── 01-executive-complaint-overview.png
    ├── 02-product-and-issue-analysis.png
    ├── 03-company-response-analysis.png
    └── 04-complaint-timeline-analysis.png
```

| File | Description |
|---|---|
| `query.sql` | SQL used to prepare the dataset. Adds the year, the month and `complaint_processing_timeline`. |
| `week4.pbix` | Power BI report: four pages built on a single model table named `Query1`. |
| `week4.pdf` | Static PDF export of the four dashboard pages. |
| `consumer_complaint_analysis1.pdf` | Written report: analysis questions, insights, recommendations, KPI definitions and limitations. |
| `images/` | Dashboard screenshots used in this README. |

## Data

- **Source:** consumer complaint data from the [CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/), covering 2017–2023.
- **Database table:** `consumer.consumer_complaints`, the table queried by `query.sql`.
- **Volume:** 62,516 complaints (the dashboard total with no filters applied).
- **Raw data is not included in this repository.**

### Fields used in the dashboard

These are the fields of the `Query1` model table that the report's visuals use.

| Field | Used for |
|---|---|
| `Complaint_ID` | Counted for every volume metric ("Count of Complaint_ID") |
| `Product` | Complaints by financial product; forwarding interval by product |
| `Sub_product` | Complaints by sub-product |
| `Issue` | Product-versus-issue table |
| `Sub_issue` | Most frequently reported issues |
| `Company_response_to_consumer` | Company response categories |
| `Company_public_response` | Public response categories |
| `Timely_response` | Timely versus untimely response (Yes / No) |
| `Submitted_via` | Submission channels; Submission-mode slicer |
| `State` | State slicer |
| `year(date_submitted)` | Year slicer; annual trend (derived in SQL) |
| `month(date_submitted)` | Monthly trend (derived in SQL) |
| `complaint_processing_timeline` | Average forwarding timeline; interval distribution; interval by product (derived in SQL) |

## SQL Query

[`query.sql`](query.sql) selects every column of the complaints table and adds three derived columns:

```sql
SELECT *,
       year(date_submitted),
       month(date_submitted),
       datediff(date_received, date_submitted) AS complaint_processing_timeline
FROM consumer.consumer_complaints;
```

| Derived column | Expression | Purpose |
|---|---|---|
| `year(date_submitted)` | `year(date_submitted)` | Year slicer and annual trend charts |
| `month(date_submitted)` | `month(date_submitted)` | Monthly trend (seasonality) |
| `complaint_processing_timeline` | `datediff(date_received, date_submitted)` | Days between `date_submitted` and `date_received`; shown in the dashboard as the *forwarding timeline / interval* |

Notes:

- The query uses MySQL-style syntax. In MySQL, `DATEDIFF(a, b)` returns `a − b` in **days**, so the timeline is measured in days.
- The year and month columns are not aliased, which is why they appear in Power BI under the names `year(date_submitted)` and `month(date_submitted)`.

## Dashboard

Every page has the same three slicers: **Year** (2017–2023), **State** and **Submission mode** (`Submitted_via`). The tabs in `week4.pbix` are named *Page 1* to *Page 4*.

### Page 1: Executive Complaint Overview

![Executive Complaint Overview](images/01-executive-complaint-overview.png)

| Visual | Shows |
|---|---|
| Total complaints (card) | Count of `Complaint_ID`: 62,516 |
| Average forwarding timeline (card) | Average of `complaint_processing_timeline`: 1.22 |
| Complaint trends over time (area chart) | Complaints per year, 2017–2023 |
| Recorded timely-response percentage (donut) | Yes 93.77% (58.62K), No 3.84% (2.40K), plus an unlabelled remainder |
| Product distribution (column chart) | Complaints by `Product` |

### Page 2: Product and Issue Analysis

![Product and Issue Analysis](images/02-product-and-issue-analysis.png)

| Visual | Shows |
|---|---|
| Product-versus-issue analysis (table) | `Product` and `Issue` combinations |
| Complaints by sub-product (donut) | Share of complaints per `Sub_product` |
| Most frequently reported issues (donut) | Share of complaints per `Sub_issue` |
| Complaints by financial product (donut) | Share of complaints per `Product` |

### Page 3: Company Response Analysis

![Company Response Analysis](images/03-company-response-analysis.png)

| Visual | Shows |
|---|---|
| Timely versus untimely response distribution (donut) | `Timely_response` split |
| Company response categories (bar chart) | Complaints per `Company_response_to_consumer` |
| Processing-timeline distribution (donut, lower left) | Complaints per `complaint_processing_timeline` value (titled "Timely versus untimely response distribution" in the report) |
| Public response categories (donut) | Complaints per `Company_public_response` |

### Page 4: Complaint Timeline Analysis

![Complaint Timeline Analysis](images/04-complaint-timeline-analysis.png)

| Visual | Shows |
|---|---|
| Complaint submission channels distribution (donut) | Complaints per `Submitted_via` |
| Monthly complaint trends (area chart) | Complaints per calendar month, all years combined |
| Annual complaint trends (area chart) | Complaints per year |
| Complaint-forwarding interval distribution (table) | `Complaint_ID` with its interval, longest first |
| Complaint-forwarding interval distribution (donut) | Complaints per interval value |
| Forwarding interval by product (area chart) | Average interval per `Product` |

## Key Insights

All figures come from the dashboard. Values marked **≈** are read from chart axes where the dashboard shows no data label (see [Limitations and Notes](#limitations-and-notes)).

### Volume and trend

- The dashboard records **62,516 complaints** between 2017 and 2023.
- Complaints rose from about 5.4K in 2017 to a peak of about 13.0K in 2022, then fell to about 9.1K in 2023.

  | Year | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 |
  |---|---|---|---|---|---|---|---|
  | Complaints (≈) | 5.4K | 7.9K | 7.1K | 8.9K | 11.1K | 13.0K | 9.1K |

- With all years combined, complaints peak around **July (≈6.5K)** and are lowest around **February (≈4.6K)**.

### Products

| Product | Complaints | Share |
|---|---|---|
| Checking or savings account | 24.81K | 39.69% |
| Credit card or prepaid card | 16.20K | 25.91% |
| Credit reporting, credit repair services, or other personal consumer reports | 7.71K | 12.33% |
| Mortgage | 6.60K | 10.56% |
| Money transfer, virtual currency, or money service | 3.45K | 5.52% |
| Debt collection | 2.74K | 4.38% |

- Checking or savings accounts and credit card or prepaid cards together account for **65.60%** of all complaints.
- The largest sub-products are checking account (20.77K, 33.22%), general-purpose credit card or charge card (13.40K, 21.44%) and credit reporting (7.34K, 11.74%).

### Issues

- **17.37% of complaints (10.86K) have no sub-issue recorded.** This is the largest slice of the sub-issue chart and appears as an unlabelled legend entry.
- The most frequent recorded sub-issues are:

  | Sub-issue | Complaints | Share |
  |---|---|---|
  | Deposits and withdrawals | 5.60K | 8.95% |
  | Problem using a debit or ATM card | 3.36K | 5.37% |
  | Credit card company isn't resolving a … (label truncated in the visual) | 2.77K | 4.43% |
  | Information belongs to someone else | 2.40K | 3.84% |
  | Company closed your account | 2.31K | 3.70% |

### Company response and timeliness

- **93.77%** of complaints (58.62K) have a timely response and **3.84%** (2.40K) do not. The remaining **≈2.39%** has no Yes/No value recorded.
- **Closed with explanation** is by far the most common company response (≈41K), followed by closed with monetary relief (≈15K), closed with non-monetary relief (≈5K) and in progress (≈1.5K).
- For public responses, 96.47% of complaints (60.31K) carry the "Company has responded to the consumer…" category and 3.48% (2.18K) have no value.

### Forwarding timeline

- The average forwarding timeline is **1.22 days**.
- **79.39%** of complaints (49.63K) have a 0-day interval and **8.92%** (5.58K) have a 1-day interval, so 88.31% are forwarded within a day.
- A few cases run much longer: the table on Page 4 lists intervals of 100 to **275 days** (for example Complaint_ID 4481803 at 275), which pulls the average above what most complaints experience.
- By product, student loan complaints have the longest average interval (about 2 days) and credit reporting the shortest (under 1 day).

### Submission channels

- Web: 45.42K (72.66%), Referral: 10.77K (17.22%), Phone: 4.68K (7.49%), Postal mail: 0.09K (0.14%). Fax, Web Referral and Email make up the small remainder.

## KPI Definitions

| KPI | Definition / calculation | Dashboard result |
|---|---|---|
| Total complaints | Count of `Complaint_ID` for the selected period and filters | 62,516 |
| Annual complaint volume | Count of `Complaint_ID` grouped by `year(date_submitted)` | ≈5.4K (2017) rising to ≈13.0K (2022); ≈9.1K (2023) |
| Monthly complaint volume | Count of `Complaint_ID` grouped by `month(date_submitted)` | Peak around July (≈6.5K); low around February (≈4.6K) |
| Complaints by product | Count of `Complaint_ID` grouped by `Product` | Checking or savings account: 24.81K (39.69%) |
| Product complaint share | (Complaints for product ÷ total complaints) × 100 | Shown as category percentages |
| Complaints by issue / sub-issue | Count of `Complaint_ID` grouped by `Issue` or `Sub_issue` | No sub-issue recorded: 10.86K (17.37%); Deposits and withdrawals: 5.60K (8.95%) |
| Average forwarding timeline | Average of `complaint_processing_timeline` | 1.22 days |
| Timely-response percentage | (Complaints marked Yes ÷ total complaints) × 100 | 93.77% (58.62K) |
| Untimely-response percentage | (Complaints marked No ÷ total complaints) × 100 | 3.84% (2.40K) |
| Response-category volume | Count of `Complaint_ID` grouped by `Company_response_to_consumer` | Closed with explanation is largest (≈41K) |
| Submission-channel share | (Complaints via channel ÷ total complaints) × 100 | Web 72.66%; Referral 17.22%; Phone 7.49% |

## Recommendations

1. **Prioritise the biggest complaint drivers.** Checking or savings accounts and credit card or prepaid cards generate 65.60% of complaints. Review their processes first, using the product and issue views to isolate recurring themes.
2. **Close the sub-issue data gap, then target the recorded issues.** 17.37% of complaints have no sub-issue. Capture it consistently, then address deposits and withdrawals (5.60K) and debit or ATM card problems (3.36K).
3. **Monitor forwarding delays.** Most complaints are forwarded within a day, but a small number take 100 days or more. Track the longest intervals to find bottlenecks.
4. **Improve response-status completeness.** About 2.39% of complaints have no timely-response value and 3.48% have no public-response value, so reported response rates are not complete.
5. **Review response outcomes by product and year.** Use the Year and State slicers to compare outcomes and to check for patterns in complaints that remain in progress.
6. **Use the history as forecasting input.** The 2017–2023 annual and monthly patterns can feed a separately validated forecast. Test it against actual volumes before using it for resource planning.

## Limitations and Notes

- **Approximate values (≈).** Where the dashboard shows no data label (annual and monthly volumes, company response counts, interval by product), values are read from chart axes. Run a `GROUP BY` in SQL or add data labels for exact figures.
- **Timeline unit.** The dashboard card shows 1.22 without a unit. Days is taken from the SQL (`DATEDIFF` in MySQL returns days).
- **Blank categories.** Some categories have no label: sub-issue (17.37%), timely response (≈2.39%) and public response (3.48%). They appear as unlabelled legend entries in the donut charts and are treated here as "not recorded". Confirm this against the source data.
- **Descriptive only.** The dashboard contains no forecast, predictive model or accuracy results.
- **Time window.** Confirm that the 2023 data covers a full year before comparing it with earlier years.
- **Raw data not included.** `query.sql` assumes a `consumer.consumer_complaints` table with the columns listed under [Data](#data).

## How to Use

1. **Explore the dashboard:** open `week4.pbix` in Power BI Desktop and use the Year, State and Submission-mode slicers. The model table is `Query1`.
2. **Quick look:** open `week4.pdf` for a static export of all four pages.
3. **Rebuild the dataset:** load your complaint data into a MySQL table named `consumer.consumer_complaints`, run `query.sql`, and load the result into Power BI.
4. **Read the analysis:** see `consumer_complaint_analysis1.pdf` for the written report.

## Tools

- **SQL (MySQL syntax):** data extraction and derived fields
- **Power BI Desktop:** data model and four-page interactive dashboard

## Author

_Add your name and contact links here._
