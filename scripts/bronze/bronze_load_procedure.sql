/******************************************************************************************
 Project       : SQL Data Warehouse Project
 Layer         : Bronze Layer (Raw Data Load)
 File Name     : bronze_load_procedure.sql
 Author        : Rabha
 Created Date  : 30-01-2026

 Description   :
 This stored procedure performs the full loading process for the Bronze Layer tables
 in the Data Warehouse using BULK INSERT from CSV source files.

 The procedure executes the following tasks:

   1. Truncates each Bronze table before loading (full refresh ingestion).
   2. Loads raw data from CRM and ERP source datasets into Bronze tables.
   3. Prints detailed progress messages for monitoring execution.
   4. Tracks load duration for each table as well as the total batch load time.
   5. Handles runtime errors using TRY...CATCH with informative error output.

 Source Data Files :
   - datasets/source_crm/cust_info.csv
   - datasets/source_crm/prd_info.csv
   - datasets/source_crm/sales_details.csv
   - datasets/source_erp/cust_az12.csv
   - datasets/source_erp/px_cat_g1v2.csv
   - datasets/source_erp/loc_a101.csv

 Target Tables (Bronze Schema) :
   - bronze.crm_cust_info
   - bronze.crm_prd_info
   - bronze.crm_sales_details
   - bronze.erp_cust_az12
   - bronze.erp_px_cat_g1v2
   - bronze.erp_loc_a101

 Notes         :
 - This procedure implements a Full Load strategy (TRUNCATE + BULK INSERT).
 - Bronze tables store raw source data without transformations.
 - This procedure can be scheduled via SQL Server Agent or orchestration tool
******************************************************************************************/



create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime
	begin try
	    set @batch_start_time = getdate();
		print'===========================================';
		print 'Loading Bronze Layer';
		print'===========================================';

		print'-------------------------------------------';
		print 'Loading CRM Table';
		print'-------------------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;

		print'>> Inserting Date Into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'D:\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds'
		print'>>-----------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;

		print'>> Inserting Date Into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'D:\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds';
		print'>>-----------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;

		print'>> Inserting Date Into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'D:\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds';
		print'>>-----------------------------------';


		print'-------------------------------------------';
		print 'Loading ERP Table';
		print'-------------------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;

		print'>> Inserting Date Into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'D:\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds';
		print'>>-----------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.erp_px_cat_g1v';
		truncate table bronze.erp_px_cat_g1v2;

		print'>> Inserting Date Into: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'D:\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds';
		print'>>-----------------------------------';

		set @start_time = getdate();
		print'>> Truncating Table: bronze.erp_loc_a10';
		truncate table bronze.erp_loc_a101;

		print'>> Inserting Date Into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'D:\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = getdate();
		print'>> Load Duration:' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'seconds';
		print'>>-----------------------------------';
		set @batch_end_time = getdate();
		print'==============================================';
		print'Loding Bronze Layer is Complated';
		print'>> Total Load Duration:' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + 'Seconds';
		print'==============================================';
	end try
	begin catch
		print'===============================================';
		print'ERROR DURING BRONZE LAYER';
		print'ERROR MESSAGE:'+ ERROR_MESSAGE();
		print'ERROR MESSAGE:'+ CAST(ERROR_NUMBER()AS NVARCHAR);
		print'ERROR MESSAGE:'+ CAST(ERROR_STATE()AS NVARCHAR);
		print'===============================================';
	end catch
end;
