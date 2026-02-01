/******************************************************************************************
 Project       : SQL Data Warehouse Project
 Layer         : Gold Layer (Business-Ready Data Model)
 File Name     : gold_star_schema_views.sql
 Author        : Rabha
 Created Date  : 01/02/2026

 Description   :
 This script creates the Gold Layer presentation model using Star Schema concepts.
 The Gold Layer represents the final, analytics-ready data that supports reporting,
 dashboards, and business intelligence use cases.

 In this layer, data is organized into:

   - Dimension Views (Master Data)
   - Fact Views (Transactional Data)

 The script performs the following:

   1. Drops existing Gold views if they already exist.
   2. Creates dimension views for Customers and Products.
   3. Creates a fact view for Sales transactions.
   4. Generates surrogate keys using ROW_NUMBER().
   5. Integrates CRM and ERP datasets to provide a unified business model.

 Views Created :
   Dimensions:
     - gold.dim_customers : Customer master dimension enriched with demographic data
     - gold.dim_products  : Product master dimension enriched with category attributes

   Facts:
     - gold.fact_sales    : Sales fact view connecting customers and products

 Data Sources :
   - Silver Layer Tables:
       silver.crm_cust_info
       silver.crm_prd_info
       silver.crm_sales_details
       silver.erp_cust_az12
       silver.erp_loc_a101
       silver.erp_px_cat_g1v2

 Notes         :
 - The Gold Layer is designed for direct consumption by BI tools such as Power BI,
   Tableau, or reporting systems.
 - Views are used here for simplicity in development; physical tables may be used
   in production environments for performance optimization.
 - Surrogate keys are generated dynamically using ROW_NUMBER().

 Usage Example :
   Query analytics-ready data:

       SELECT * FROM gold.fact_sales;
       SELECT * FROM gold.dim_customers;
       SELECT * FROM gold.dim_products;

******************************************************************************************/


IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id                          AS customer_id,
    ci.cst_key                         AS customer_number,
    ci.cst_firstname                   AS first_name,
    ci.cst_lastname                    AS last_name,
    la.cntry                           AS country,
    ci.cst_marital_status              AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data
    END                                AS gender,
    ca.bdate                           AS birthdate,
    ci.cst_create_date                 AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
