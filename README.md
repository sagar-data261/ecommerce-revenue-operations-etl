# E-Commerce Revenue & Operations ETL Pipeline

An end-to-end data analytics pipeline built on **5,000 retail transactions** to identify promotional revenue leakage, fulfillment SLA breaches, and customer spending concentration.

## 📊 Executive Dashboard Preview

## 🔍 Key Business Insights

- **Discounts Erode Revenue Without Increasing Volume:** Transactions with **≥30% discounts** generated an average revenue of **$854**, compared with **$1,175** for lower-discount transactions — a **27.3% decline** in revenue, while average order volume remained nearly flat at **~4 units**.

- **Discounts Show No Customer Satisfaction Gain:** Average customer ratings remained virtually unchanged at **~2.97/5**, regardless of discount depth.

- **37.7% Logistics SLA Breach Rate:** **37.7% of shipments** exceeded the 7-day fulfillment threshold, despite an average delivery time of **6.1 days**. Late deliveries also showed little impact on review scores, potentially masking customer retention risks.

- **Customer Revenue Concentration:** The **top 20% of customers generated 37.4% of total net sales**, highlighting a significant concentration of revenue among high-value customers.

## 🛠️ Tech Stack

- **ETL & Data Processing:** Python, Pandas, SQLAlchemy, PyMySQL
- **Database & Analysis:** MySQL, CTEs, `NTILE(5)`, Conditional Aggregation, Window Functions
- **Business Intelligence:** Power BI, DAX, Custom Ordinal Sorting
