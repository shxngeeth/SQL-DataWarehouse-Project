# SQL Data Warehouse Project

Building a modern data warehouse with SQL Server, covering the full journey from raw source data to analytics-ready star schema — including ETL pipelines, data cleaning, and data quality validation.

## 📐 Architecture

This project follows the **Medallion Architecture** (Bronze → Silver → Gold), a common pattern for modern data warehousing:

<img width="1856" height="1181" alt="Data Architecture" src="https://github.com/user-attachments/assets/71b8465c-e6c3-4dad-9831-74987a7330d1" />


Data Flow Diagram


<img width="1466" height="907" alt="dataflowdiagram" src="https://github.com/user-attachments/assets/dc33cc85-d5de-4dba-8721-61354b707070" />



- **🥉 Bronze Layer** — Raw data ingested as-is from source CRM and ERP CSV files via `BULK INSERT`, no transformations applied. Acts as the single source of truth for raw history.
- **🥈 Silver Layer** — Cleaned, standardized, and validated data. Includes deduplication, null handling, data type casting, and business rule enforcement (e.g., standardizing gender/marital status codes, deriving category IDs from product keys).
- **🥇 Gold Layer** — Business-ready data modeled as a **star schema** (`dim_customers`, `dim_products`, `fact_sales`) exposed as views, ready for reporting and analytics tools like Power BI.

## 🛠️ Tech Stack

- **SQL Server 2025 Express** — database engine
- **SQL Server Management Studio (SSMS)** — development environment
- **T-SQL** — all ETL, transformation, and modeling logic


## 🔍 Key Data Quality Checks Implemented

- **Deduplication** — used `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` to identify and keep only the most recent record per customer, removing stale duplicate CRM entries.
- **Null handling** — filtered out records with missing critical keys (e.g., `cst_id IS NOT NULL`) before they reached the silver layer.
- **Standardization** — normalized inconsistent categorical values (e.g., `'S'`/`'M'`/`'F'` codes mapped to `'Single'`/`'Married'`/`'Female'`, inconsistent country codes like `'US'`/`'USA'` unified to `'United States'`).
- **Business rule resolution** — resolved conflicting gender values across CRM and ERP source systems using a "CRM as master, fallback to ERP" rule via `CASE` + `COALESCE`.
- **Derived columns** — extracted `cat_id` from composite product keys using `SUBSTRING`/`REPLACE`.
- **Referential integrity checks** — validated that every fact table row correctly joins to its dimension tables with no orphaned foreign keys.

## 🚀 What I'd Do Next

- Automate the pipeline with a scheduling/orchestration tool (e.g., Azure Data Factory)
- Migrate to a cloud-hosted SQL instance (Azure SQL)
- Build a Power BI dashboard on top of the gold layer views

## 📊 Sample Query

```sql
SELECT
    c.country,
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY c.country, p.category
ORDER BY total_sales DESC;
```

## 👤 About Me

I'm Shangeeth Vanniyasingam, a Computing Science student at Coventry University London, building hands-on experience in data analysis and data engineering — SQL, Python, and Power BI.

This project was built setting up SQL Server myself, writing every script by hand, and debugging real issues along the way duplicate inserts, schema mismatches, data type errors, and messy source data. It reflects actually understanding *why* each transformation and validation step matters in a real data pipeline.

I'm currently expanding into Python-based ETL pipelines and Azure fundamentals, working toward a Data Analyst or Junior Data Engineer role.

📫 Let's connect: [LinkedIn](https://www.linkedin.com/in/shangeeth-vanniyasingam-773029284/) | 📧shangeeth909@gmail.com
