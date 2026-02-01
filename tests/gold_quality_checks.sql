/******************************************************************************************
 Project       : SQL Data Warehouse Project
 Layer         : Gold Layer (Data Model Validation)
 File Name     : gold_quality_checks.sql
 Author        : Rabha
 Created Date  : 01/02/2026

 Description   :
 This script performs validation and integrity checks on the Gold Layer views,
 ensuring that the Star Schema model is consistent, reliable, and ready for
 analytics and reporting.

 The checks included in this script focus on:

   - Surrogate key uniqueness in dimension views
   - Data model connectivity between fact and dimension views
   - Detection of orphan records in the fact view (missing dimension references)

 Views Validated :
   Dimensions:
     - gold.dim_customers : Customer dimension view
     - gold.dim_products  : Product dimension view

   Facts:
     - gold.fact_sales    : Sales fact view

 Usage :
   Run this script after creating the Gold Layer views:

       SELECT * FROM gold.dim_customers;
       SELECT * FROM gold.dim_products;
       SELECT * FROM gold.fact_sales;

 Expected Results :
   - Dimension key uniqueness checks should return NO ROWS.
   - Fact-to-dimension connectivity check should return NO ROWS.
   Any returned rows indicate potential data quality or join issues.

 Notes         :
 - These checks help confirm referential consistency in the Star Schema design.
 - Gold Layer data is intended for direct consumption by BI tools such as
   Power BI, Tableau, and reporting platforms.

******************************************************************************************/



-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  

