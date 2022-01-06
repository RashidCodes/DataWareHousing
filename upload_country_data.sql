USE Stage;
GO

-- Create the table
IF OBJECT_ID('country') IS NOT NULL
  DROP TABLE country;

CREATE TABLE country
(
   country_code varchar(10) not null, 
   country_name varchar(100) not null
);

-- Insert the data
BULK INSERT 
  Stage.dbo.country 
FROM '/var/opt/mssql/building-a-data-warehouse/dw_project/seeds/my_country.csv'
WITH (FORMAT = 'CSV', FIELDTERMINATOR=',', FIRSTROW=2);


-- Add the country code
ALTER TABLE dbo.country ADD country_key int PRIMARY KEY IDENTITY(1,1);


-- Add the control columns
ALTER TABLE dbo.country 
  ADD 
    source_system_code INT, 
    create_timestamp DATETIME,
    update_timestamp DATETIME;


-- Set the data
UPDATE dbo.country 
   SET 
     source_system_code = 2, 
     create_timestamp = CURRENT_TIMESTAMP, 
     update_timestamp = CURRENT_TIMESTAMP;


-- Insert the unknown record. It's used when we have an unknown value.
SET IDENTITY_INSERT dbo.country on;

INSERT INTO dbo.country
 (country_key, country_code, country_name,
  source_system_code, create_timestamp, update_timestamp)
VALUES (0, N'UN', N'Unknown', 0, '19000101', '19000101')

SET IDENTITY_INSERT dbo.country OFF;


-- We are now ready to push the data to the NDS
SET IDENTITY_INSERT NDS.dbo.country ON;
INSERT INTO NDS.dbo.country
  (country_key, country_code, country_name,
   source_system_code, create_timestamp, update_timestamp)
 SELECT country_key, country_code, country_name,
       source_system_code, create_timestamp, update_timestamp
 FROM Stage.dbo.country;

SET IDENTITY_INSERT NDS.dbo.country OFF;
