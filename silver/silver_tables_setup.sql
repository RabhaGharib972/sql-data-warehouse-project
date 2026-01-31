/******************************************************************************************
 Project       : SQL Data Warehouse Project
 Layer         : Silver Layer (Cleaned & Standardized Data)
 File Name     : silver_tables_setup.sql
 Author        : Rabha
 Created Date  : 31/01/2026

 Description   :
 This script creates the required tables for the Silver Layer in the Data Warehouse.

 The Silver Layer represents the cleaned, standardized, and enriched version of the
 raw Bronze data. It serves as an intermediate transformation layer before building
 the business-ready Gold Layer.

 The script performs the following actions:

   1. Drops existing Silver tables if they already exist.
   2. Recreates Silver tables with the appropriate data types and structure.
   3. Adds metadata columns such as:
        - dwh_create_date : Load timestamp for auditing and tracking purposes.

 Tables Included :
   CRM Tables:
     - silver.crm_cust_info         : Cleaned customer master data
     - silver.crm_prd_info          : Cleaned product master data with category mapping
     - silver.crm_sales_details     : Standardized sales transaction data

   ERP Tables:
     - silver.erp_cust_az12         : Customer demographic attributes
     - silver.erp_loc_a101          : Customer location reference data
     - silver.erp_px_cat_g1v2       : Product category and maintenance reference mapping

 Notes         :
 - Silver tables store structured and validated data derived from Bronze layer.
 - These tables are typically populated through transformation procedures
   such as: silver.load_silver.
 - Drop-and-create approach is mainly intended for development/testing environments.

******************************************************************************************/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
