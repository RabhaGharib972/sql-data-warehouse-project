/******************************************************************************************
 Project       : SQL Data Warehouse Project
 Layer         : Bronze Layer (Raw Data Ingestion)
 File Name     : bronze_tables_setup.sql
 Author        : Rabha
 Created Date  : 30-01-2026

 Description   :
 This script creates the required tables for the Bronze Layer in the Data Warehouse.
 The Bronze Layer represents the raw ingestion zone where source data is loaded
 exactly as received from CRM and ERP systems, without transformation.

 The script performs the following steps:

   1. Checks if each Bronze table already exists.
   2. Drops the table if it exists (for clean re-deployment).
   3. Recreates the tables with the appropriate raw schema structure.

 Tables Included :
   - bronze.crm_cust_info        : Raw customer information from CRM
   - bronze.crm_prd_info         : Raw product information from CRM
   - bronze.crm_sales_details    : Raw sales transaction details from CRM
   - bronze.erp_cust_az12        : Raw customer demographics from ERP
   - bronze.erp_loc_a101         : Raw customer location data from ERP
   - bronze.erp_px_cat_g1v2      : Raw product category mapping from ERP

 Notes         :
 - These tables are designed for staging raw data before cleaning and transformation
   in the Silver Layer.
 - Data is typically loaded into these tables using BULK INSERT procedures.
 - Drop-and-create approach is suitable for development/testing environments.

******************************************************************************************/


if OBJECT_ID ('bronze.crm_cust_info','u') is not null
	drop table bronze.crm_cust_info; 
create table bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);



if OBJECT_ID ('bronze.crm_prd_info','u') is not null
	drop table bronze.crm_prd_info; 
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);



if OBJECT_ID ('bronze.crm_sales_details','u') is not null
	drop table bronze.crm_sales_details; 
create table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);



if OBJECT_ID ('bronze.erp_cust_az12','u') is not null
	drop table bronze.erp_cust_az12; 
create table bronze.erp_cust_az12(
	cid nvarchar(50),
	bdate date,
	gen nvarchar(50)
);



if OBJECT_ID ('bronze.erp_loc_a101','u') is not null
	drop table bronze.erp_loc_a101; 
create table bronze.erp_loc_a101(
	cid nvarchar(50),
	cntry nvarchar(50)
);



if OBJECT_ID ('bronze.erp_px_cat_g1v2','u') is not null
	drop table bronze.erp_px_cat_g1v2; 
create table bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);
