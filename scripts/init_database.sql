/******************************************************************************************
 Project       : sql_data-warehouse-project
 File Name     : init_database.sql
 Author        : Rabha
 Created Date  : 2026-01-29

 Description   :
 This script initializes the Data Warehouse environment by performing the following:

   1. Drops the existing database (DataWarehouse) if it already exists.
   2. Creates a fresh Data Warehouse database.
   3. Switches context to the new database.
   4. Creates the main schemas used in the Medallion Architecture:
        - bronze : Raw/Ingested data layer
        - silver : Cleaned and transformed layer
        - gold   : Business-ready analytics layer

 Notes         :
 - SINGLE_USER mode with ROLLBACK IMMEDIATE is used to force close active connections
   before dropping the database.
 - This script is intended for development/testing environments.

******************************************************************************************/


USE master;
GO
-- drop DB if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
    ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Datawarehouse;
END
GO

-- create the database 'Datawarehouse'
CREATE DATABASE DataWarehouse;
Go

USE DataWarehouse;

--create schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
Go
