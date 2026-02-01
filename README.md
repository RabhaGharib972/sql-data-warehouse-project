# 🚀 SQL Data Warehouse Project

This project is an end-to-end **Data Warehouse pipeline** built using **Microsoft SQL Server**.  
It follows the modern **Medallion Architecture** approach:

- **Bronze Layer** (Raw Data Ingestion)
- **Silver Layer** (Cleaned & Standardized Data)
- **Gold Layer** (Star Schema for Analytics)

The final Gold layer is analytics-ready and can be consumed by BI tools such as  
**Power BI** or **Tableau**.

---

## 🏗 Architecture Diagram

_(Add your project diagram here)_

(images/data_architecture.png)



---

## 📌 Layers Overview

- **Bronze Layer**
  - Stores raw source data as-is  
  - Loaded using `BULK INSERT`

- **Silver Layer**
  - Cleans and standardizes the data  
  - Removes duplicates, fixes invalid values, applies transformations

- **Gold Layer**
  - Final business-ready model  
  - Provides Dimensions & Fact views for reporting

---

## ⚙️ How to Run the Project

Execute the load procedures in order:

```sql
EXEC bronze.load_bronze;
EXEC silver.load_silver;
```

---

#query the Gold layer:
```
SELECT * FROM gold.fact_sales;
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
```


## Author

- [@Rabha Gharib](https://github.com/RabhaGharib972)


## Credits

This project was built as part of my learning journey, based on a tutorial by Baraa.
All implementation and customization were done by me.

