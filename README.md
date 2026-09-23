# 📦 SAP S/4HANA MM: P2P Procurement Analytics & Multi-Criteria Vendor Risk Scoring

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC292B?style=for-the-badge\&logo=microsoftsqlserver\&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge\&logo=powerbi\&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![Scikit-Learn](https://img.shields.io/badge/scikit--learn-F7931E?style=for-the-badge\&logo=scikit-learn\&logoColor=white)
![SAP](https://img.shields.io/badge/SAP%20S%2F4HANA-0FAAFF?style=for-the-badge\&logo=sap\&logoColor=white)

An end-to-end **Procurement Analytics and Decision Intelligence** case study simulating an enterprise electronics retail company, **Nova Teknoloji Ltd. Şti.**

The project models a **Procure-to-Pay (P2P)** workflow using an SAP S/4HANA Materials Management (**MM**) inspired relational schema and integrates:

* **SQL Server** for enterprise data modeling and analytical views
* **Power BI** for executive procurement analytics and Vendor 360 reporting
* **Python & Scikit-Learn** for multi-criteria vendor risk scoring
* **Statistical and analytical methods** for identifying supply chain exposure
* **Business analysis** for translating analytical findings into procurement actions

The primary objective is to demonstrate how ERP data can be transformed into actionable procurement intelligence through an integrated **SQL → Power BI → Python** analytics pipeline.

---

## 🎯 Business Context

In enterprise procurement, evaluating suppliers using only **On-Time Delivery (OTD %)** can hide important operational and financial risks.

For example, a supplier may maintain an acceptable delivery percentage while simultaneously having:

* A high volume of open purchase orders
* Significant outstanding financial exposure
* High procurement volume
* Delayed or partially fulfilled deliveries

Therefore, this project combines **delivery performance, open financial exposure, and operational order volume** into a composite vendor risk model.

---

## 🎯 Project Objectives

The project was designed around five main objectives:

### 1. ERP Relational Modeling

Simulate an SAP S/4HANA MM procurement data model using SQL Server.

Core tables include:

* `MARA` — Material Master
* `LFA1` — Vendor Master
* `EKKO` — Purchase Order Header
* `EKPO` — Purchase Order Line Items
* `MSEG` — Goods Receipt / Material Document

### 2. Analytical SQL Layer

Build reusable SQL views to calculate:

* Purchase order fulfillment
* Delivered and open quantities
* Fulfillment rates
* Delivery delays
* On-Time Delivery performance
* Vendor spend
* Open financial exposure
* Vendor scorecards

### 3. Executive Power BI Reporting

Create a **Vendor 360** dashboard providing:

* Executive KPIs
* Vendor segmentation
* Spend analysis
* Delivery performance
* Open exposure
* Regional and category analysis
* PO-level drill-through analysis

### 4. Multi-Criteria Vendor Risk Scoring

Develop a composite **0–100 vendor risk score** using Python and Scikit-Learn.

The model considers:

* Delivery delay exposure
* Open financial exposure
* Active order volume

### 5. Procurement Decision Support

Translate analytical results into procurement-oriented actions such as:

* Vendor monitoring
* Exposure reduction
* Order diversification
* Supply allocation review

---

# 🏗️ Solution Architecture

```text
┌──────────────────────────────────────────────┐
│        SAP S/4HANA MM Inspired Schema        │
│                                              │
│  MARA  │  LFA1  │  EKKO  │  EKPO  │  MSEG   │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│           SQL Server Analytical Layer        │
│                                              │
│  vw_FulfillmentStatus                        │
│  vw_VendorOTDPerformance                     │
│  vw_SpendAnalysis                            │
│  vw_VendorScorecard                          │
└───────────────┬───────────────────┬──────────┘
                │                   │
                ▼                   ▼
┌────────────────────────┐  ┌────────────────────────┐
│      Power BI          │  │       Python           │
│                        │  │                        │
│ Vendor 360 Dashboard  │  │ Min-Max Scaling        │
│ Executive KPIs        │  │ Risk Scoring           │
│ A/B/C Segmentation    │  │ Risk Classification    │
│ Drill-through         │  │ Risk Matrix            │
└────────────────────────┘  └────────────────────────┘
```

---

# 🗄️ Database Architecture

## Database

**Database:** `SAP_Procurement`

**DBMS:** Microsoft SQL Server

**Collation:** `Turkish_CI_AS`

## Dataset Overview

| Table  | Description                       | Records |
| ------ | --------------------------------- | ------: |
| `MARA` | Material Master                   |      16 |
| `LFA1` | Vendor Master                     |       7 |
| `EKKO` | Purchase Order Headers            |      12 |
| `EKPO` | Purchase Order Line Items         |      29 |
| `MSEG` | Goods Receipt / Movement Type 101 |      22 |

### Data Characteristics

* **16 materials**

  * 10 HAWA trading goods
  * 6 ROH raw materials
* **7 corporate vendors**
* Vendor locations include:

  * Türkiye
  * Germany
  * China
  * United States
* **12 Purchase Orders**
* Date range: **November 2024 – February 2025**
* **29 PO line items**
* **22 goods receipt records**
* Movement type: `BWART = 101`

The dataset intentionally contains multiple fulfillment scenarios:

* On-time deliveries
* Delayed deliveries
* Partial deliveries
* Open deliveries
* Multiple/split goods receipts

This enables the analytical layer to simulate realistic procurement situations.

---

# 🔗 SAP MM Data Model

The project uses a simplified SAP S/4HANA MM-inspired structure.

```text
             ┌───────────────┐
             │     LFA1      │
             │ Vendor Master │
             └───────┬───────┘
                     │
                     │ LIFNR
                     ▼
             ┌───────────────┐
             │     EKKO      │
             │  PO Header    │
             └───────┬───────┘
                     │
                     │ EBELN
                     ▼
             ┌───────────────┐
             │     EKPO      │
             │ PO Line Item  │
             └───┬───────┬───┘
                 │       │
       MATNR     │       │ EBELN/EBELP
                 ▼       ▼
        ┌────────────┐  ┌────────────┐
        │    MARA    │  │    MSEG    │
        │  Material  │  │   Goods    │
        │   Master   │  │  Receipt   │
        └────────────┘  └────────────┘
```

### Main Relationships

* `LFA1.LIFNR → EKKO.LIFNR`
* `EKKO.EBELN → EKPO.EBELN`
* `EKPO.MATNR → MARA.MATNR`
* `EKPO.EBELN + EKPO.EBELP → MSEG.EBELN + MSEG.EBELP`

---

# 📊 Analytical SQL Views

The SQL analytical layer converts transactional procurement data into reusable business-level datasets.

## `vw_FulfillmentStatus`

Core PO line-level fulfillment view.

Key calculations include:

* `SiparisMiktari`
* `GelenMiktar`
* `AcikMiktar`
* `KarsilanmaOraniYuzde`
* Fulfillment status
* Open quantity
* Delivered quantity

### Business Logic

```text
Open Quantity
    = Ordered Quantity - Received Quantity
```

```text
Fulfillment Rate
    = Received Quantity / Ordered Quantity × 100
```

---

## `vw_VendorOTDPerformance`

Measures vendor delivery reliability.

The view calculates delivery variance using:

```sql
DATEDIFF(
    DAY,
    TaahhutTarihi,
    FiiliTeslimTarihi
)
```

This supports:

* Delivery delay analysis
* On-Time Delivery percentage
* Average delay
* Vendor-level delivery performance
* Split/multiple goods receipt analysis

---

## `vw_SpendAnalysis`

Aggregates vendor financial metrics.

Main metrics include:

* `ToplamSiparisTutari`
* `ToplamGelenTutar`
* `AcikTutar`
* Average unit price
* Vendor procurement volume

This view connects procurement activity with financial exposure.

---

## `vw_VendorScorecard`

Creates a delivery-based vendor segmentation.

| Segment | OTD Performance | Description     |
| ------- | --------------: | --------------- |
| A       |        `>= 85%` | Reliable        |
| B       |    `70% – <85%` | Monitor         |
| C       |          `<70%` | Critical / Risk |

> **Note:** The A/B/C segmentation is a descriptive business classification created specifically for this case study. It is separate from the Python composite risk score.

---

# 📈 Power BI — Executive Vendor 360

The Power BI layer transforms the SQL analytical views into an executive procurement dashboard.

## 1. Executive Vendor Scorecard

### KPI Metrics

The dashboard includes:

* **Total Spend:** ₺7.35M
* **Open Risk Exposure:** ₺2.99M
* Overall Delivery Rate
* Vendor count
* Vendor segmentation

### Vendor Segmentation

Vendors are distributed across:

```text
A → Reliable
B → Monitor
C → Critical / Risk
```

### Spend Analysis

The dashboard provides visibility into:

* Procurement spend by category
* Vendor spend distribution
* Regional distribution
* Open financial exposure

---

# 🔎 2. Operational Vendor 360

The Vendor 360 section provides detailed vendor-level analysis.

Users can drill through from summary-level vendor information into individual purchase orders.

The drill-through view provides visibility into:

* Purchase order history
* PO line items
* Ordered quantities
* Received quantities
* Open quantities
* Fulfillment rates
* Delivery dates
* Delivery variances
* Vendor-level exposure

This creates a connection between:

```text
Executive KPI
      ↓
Vendor
      ↓
Purchase Order
      ↓
PO Line Item
      ↓
Delivery / Goods Receipt
```

---

# 🐍 Python Analytics

## Multi-Criteria Vendor Risk Scoring

A single KPI such as OTD may not fully represent supplier risk.

To address this, the project introduces a composite **Vendor Risk Score** using:

* Python
* Pandas
* Scikit-Learn
* `MinMaxScaler`

The model combines three dimensions:

1. Delivery delay exposure
2. Financial exposure
3. Operational volume

---

# 🧮 Risk Score Methodology

The composite risk score is calculated as:

$$
\text{Composite Risk Score} =
(0.40 \times \text{Delay Rate})
+
(0.35 \times \text{Norm Open Amount})
+
(0.25 \times \text{Norm Order Volume})
$$

Where:

### Delay Exposure — 40%

Calculated from OTD:

$$
\text{Delay Rate} =
\frac{100 - OTD}{100}
$$

A higher delay rate contributes more risk.

### Financial Exposure — 35%

The vendor's open financial balance is normalized using Min-Max scaling.

$$
X_{scaled} =
\frac{X-X_{min}}{X_{max}-X_{min}}
$$

### Operational Volume — 25%

The active order count is also normalized using Min-Max scaling.

This allows vendors to be compared across different numerical scales.

---

# ⚠️ Risk Classification

The resulting score is converted to a 0–100 scale for easier interpretation.

The model is designed to identify vendors whose risk emerges from the **combination** of multiple operational factors rather than from delivery performance alone.

---

# 📊 Analytical Results

| Vendor                        | Segment |     OTD | Open Amount | Risk Score | Risk Level     |
| ----------------------------- | ------- | ------: | ----------: | ---------: | -------------- |
| TeknoTedarik Dağıtım A.Ş.     | B       |  75.00% |  ₺1,338,500 |      70.00 | 🔴 High Risk   |
| Kuzey Bilişim Sistemleri Ltd. | C       |  50.00% |    ₺811,000 |      53.71 | 🟠 Medium Risk |
| Alfa Elektronik B.V.          | B       |  66.67% |    ₺315,000 |      34.07 | 🟢 Low Risk    |
| NovaTech Components Ltd.      | A       |  85.71% |    ₺174,600 |      22.78 | 🟢 Low Risk    |
| Pine Valley Systems Inc.      | C       |  50.00% |     ₺78,000 |      22.04 | 🟢 Low Risk    |
| Atlas Komponent Sanayi A.Ş.   | C       |  50.00% |          ₺0 |      20.00 | 🟢 Low Risk    |
| Ege Teknoloji Lojistik A.Ş.   | A       | 100.00% |    ₺277,500 |       7.26 | 🟢 Low Risk    |

---

# 💡 Key Analytical Insights

## Hidden Exposure Beyond OTD

One of the main findings is that **OTD alone does not capture the complete vendor risk picture**.

For example:

> **TeknoTedarik Dağıtım A.Ş.** has a 75% OTD rate and therefore falls into the B segment based on the project's OTD classification.

However, the vendor simultaneously carries:

* ₺1.34M open financial exposure
* High operational order volume
* Significant delivery exposure

The composite model therefore produces a substantially higher risk score than an OTD-only evaluation would suggest.

This demonstrates the value of combining multiple procurement indicators.

---

# 📌 Procurement Action Framework

Based on the analytical results, the case study proposes several potential procurement actions.

## 1. Review High-Exposure Vendors

Vendors with a combination of:

* High open exposure
* Significant order volume
* Weak delivery performance

should receive additional operational monitoring.

## 2. Review New Order Allocation

For vendors showing elevated composite risk, procurement teams can evaluate whether new orders should be:

* Temporarily limited
* Delayed
* Reallocated
* Split across alternative suppliers

The project uses **90% fulfillment** as an example internal target for evaluating the recovery of open deliveries.

## 3. Supplier Diversification

Open procurement exposure can be evaluated against vendors with stronger historical delivery performance.

In this simulated dataset:

* **Ege Teknoloji Lojistik A.Ş.** — 100% OTD
* **NovaTech Components Ltd.** — 85.71% OTD

represent examples of vendors that could be considered when evaluating volume diversification.

> These are analytical scenarios based on the simulated dataset rather than operational recommendations for a real company.

---

# 🧠 Why Multi-Criteria Risk Scoring?

Traditional supplier evaluation may focus heavily on one KPI.

For example:

```text
Vendor A
OTD = 90%
Open Exposure = ₺50K
Order Volume = Low
```

versus:

```text
Vendor B
OTD = 75%
Open Exposure = ₺1.3M
Order Volume = High
```

An OTD-only model may not adequately distinguish the operational exposure represented by Vendor B.

The proposed model instead evaluates:

```text
Delivery Performance
        +
Financial Exposure
        +
Operational Volume
        ↓
Composite Vendor Risk
```

This creates a more multidimensional view of procurement exposure.

---

# 🛠️ Technology Stack

## Database & SQL

* Microsoft SQL Server
* T-SQL
* Relational Data Modeling
* SQL Views
* Aggregations
* Joins
* Date Calculations
* Procurement Analytics

## Business Intelligence

* Power BI
* DAX
* KPI Design
* Drill-through
* Vendor 360
* Segmentation
* Executive Dashboard Design

## Python Analytics

* Python
* Pandas
* NumPy
* Scikit-Learn
* MinMaxScaler
* Data Normalization
* Risk Scoring
* Analytical Visualization

## ERP / Business Domain

* SAP S/4HANA MM concepts
* Procure-to-Pay (P2P)
* Purchase Orders
* Goods Receipts
* Vendor Management
* Procurement Spend
* Delivery Performance
* Supplier Risk

---

# 🚀 Installation & Setup

## Requirements

Before running the project, make sure the following are available:

* Microsoft SQL Server
* SQL Server Management Studio or `sqlcmd`
* Power BI Desktop
* Python 3.x
* Jupyter Notebook / JupyterLab

---

# 🗄️ Database Installation

The project provides an automated SQL build script for creating the procurement analytics database.

### Using `sqlcmd`

Open PowerShell and navigate to the SQL directory:

```powershell
Set-Location "sql"
```

Then execute the master build script:

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 00_master_build.sql
```

> Replace `<SQL_SERVER_INSTANCE>` with your local SQL Server instance name.

> Example: `localhost\SQLEXPRESS`

The database name used in this project is `SAP_Procurement`.

---

# 🔧 Modular Database Build

The database can also be created step-by-step.

### 1. Cleanup

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 01_cleanup.sql
```

### 2. Seed Material Master

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 02_seed_MARA.sql
```

### 3. Seed Vendor Master

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 03_seed_LFA1.sql
```

### 4. Seed Purchase Order Headers

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 04_seed_EKKO.sql
```

### 5. Seed Purchase Order Items

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 05_seed_EKPO.sql
```

### 6. Seed Goods Receipts

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 06_seed_MSEG.sql
```

### 7. Create Analytical Views

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 07_create_views.sql
```

### 8. Verify Database

```powershell
sqlcmd -S "<SQL_SERVER_INSTANCE>" -d SAP_Procurement -i 08_verify.sql
```

> **Note:** Run these commands from the `sql` directory, or adjust the file paths accordingly.

---

# 📊 Power BI Setup

Open:

```text
powerbi/SAP_Procurement_Vendor_Scorecard.pbix
```

The dashboard is designed around the SQL analytical views.

Primary analytical sources:

```text
vw_FulfillmentStatus
vw_VendorOTDPerformance
vw_SpendAnalysis
vw_VendorScorecard
```

The dashboard provides both executive-level KPIs and detailed vendor-level drill-through analysis.

---

# 🐍 Python Setup

The Python analysis is located in:

```text
python/
```

Main notebook:

```text
01_Vendor_Risk_Scoring_Model.ipynb
```

The notebook performs:

1. Data loading
2. Data preparation
3. Feature selection
4. Min-Max normalization
5. Composite risk calculation
6. Vendor risk classification
7. Risk visualization
8. CSV output generation

Output:

```text
vendor_risk_analysis_output.csv
```

---

# 📁 Repository Structure

```text
SAP-Procurement-Vendor-Scorecard/
│
├── sql/
│   ├── 00_master_build.sql
│   ├── 01_cleanup.sql
│   ├── 02_seed_MARA.sql
│   ├── 03_seed_LFA1.sql
│   ├── 04_seed_EKKO.sql
│   ├── 05_seed_EKPO.sql
│   ├── 06_seed_MSEG.sql
│   ├── 07_create_views.sql
│   ├── 08_verify.sql
│   └── 09_powerbi_queries.sql
│
├── powerbi/
│   └── SAP_Procurement_Vendor_Scorecard.pbix
│
├── python/
│   ├── 01_Vendor_Risk_Scoring_Model.ipynb
│   └── vendor_risk_analysis_output.csv
│
├── data/
│   └── vendor_analytics_data.csv
│
├── assets/
│   └── vendor_risk_matrix.png
│
└── README.md
```

---

# 📸 Dashboard & Analysis Preview

## Vendor Risk Matrix

![Vendor Risk Matrix](assets/vendor_risk_matrix.png)

---

# 🔄 End-to-End Workflow

The complete analytical workflow can be summarized as:

```text
SAP MM Inspired Data Model
            │
            ▼
     SQL Server Database
            │
            ▼
      Analytical Views
            │
      ┌─────┴─────┐
      ▼           ▼
   Power BI     Python
      │           │
      ▼           ▼
 Vendor 360   Risk Scoring
      │           │
      └─────┬─────┘
            ▼
   Procurement Insights
            │
            ▼
   Risk-Based Decision Support
```

---

# 🎓 Business & Technical Skills Demonstrated

This project demonstrates practical experience across multiple areas.

### Data Analytics

* Data cleaning and preparation
* KPI development
* Feature engineering
* Normalization
* Multi-dimensional analysis

### SQL

* Relational data modeling
* Complex joins
* Aggregations
* Analytical views
* Date-based calculations
* Business logic implementation

### Power BI

* Executive dashboards
* KPI cards
* Vendor segmentation
* Drill-through analysis
* Procurement analytics
* DAX-based metrics

### Python

* Pandas
* Scikit-Learn
* Feature normalization
* Composite scoring
* Analytical visualization

### Business Analysis

* Requirements-oriented thinking
* Procurement process modeling
* KPI definition
* Risk identification
* Decision-support analysis
* Translating technical results into business actions

### ERP / SAP Concepts

* SAP MM
* Procurement
* Purchase Orders
* Goods Receipts
* Vendor Management
* Procure-to-Pay workflows

---

# ⚠️ Disclaimer

This repository is an **educational and portfolio case study**.

The SAP S/4HANA tables and procurement records are simulated for analytical purposes and do not represent real company data.

The vendor names, financial values, purchase orders, delivery records, risk scores, and procurement scenarios are fictional.

The risk scoring methodology is a custom analytical framework created for this project and should not be interpreted as an official SAP methodology or a production-grade supplier risk model.

---

# 👩‍💻 Author

## Cansu Kahve

**Management Information Systems Graduate | Business & Data Analyst**

Interested in:

* Data Analytics
* Business Analysis
* Business Intelligence
* Machine Learning
* ERP & SAP Analytics
* Decision Intelligence

### Connect

* [GitHub](https://github.com/cansukahve)
* [LinkedIn](https://www.linkedin.com/in/cansukahve/)

---

## ⭐ Project Highlights

```text
SAP S/4HANA MM Inspired Data Model
              +
SQL Server Analytical Layer
              +
Power BI Vendor 360
              +
Python Risk Scoring
              ↓
Procurement Decision Intelligence
```

This project demonstrates how transactional ERP-style data can be transformed into **structured analytical insights, visual business intelligence, and multi-criteria supplier risk analysis**.
