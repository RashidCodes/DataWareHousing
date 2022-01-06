# Datawarehousing with SQL Server

In this repo, I teach myself the essentials of datawarehousing using a book titled  Building a Data Warehouse by Vincent Rainardi. SQL server is implemented with docker. I'll be highlighting the major I've learned soon.

# Biggest difficulty
The book is using SSIS and SQL Server for the project. I've had to implement everything in the book using tools like ```bash```, ```docker```, ```dbt```, and ```airbyte```. Very soon I'll be adding ```airflow``` to orchestrate the tasks because there's so many of them - data matching, database restoration, data population, etc.

<br/>


# What's all this for?

Well, my hypothetical bosses at Rashid Inc. have asked me to develop a datawarehouse for analytical purposes. The have a few functional requirements that I'll mention soon. Also, I just love data engineering and I couldn't wait to hop on a project, even if it was for free :).

<br/>

# DW Architecture

<img src="dw arch.png" />

<br/>

# Process

## Starting the server

The server is started using the ```start_server.sh``` bash script. The script also creates all fact and dimension tables in the DDS. Moreover, it creates the Stage and NDS databases. Lastly, it populates the NDS with all the necessary relations to meet the business requirements. 

<br/>

## Importing data from files

The data is uploaded using the ```upload_country.sh``` file.

<br/>

## Importing the source data 

The business has three systems with multiple data stores. All datastores are loaded into the server using the ```setup_sources.sh``` file.

<br/>

## Populate the Stage 

The Stage database is populated using Airbyte. Basically, all source data is loaded into Stage database. The data is not normalized for to reduce redundancy, however the data is prepared for the population of the NDS. Normalization is performed in the NDS. I won't be keeping days-worth of data in the staging database. I'll truncate all relations in the Stage database prior to data extraction and loading from the source systems. All I have to do is set the right Sync mode in Airbyte.




## NDS Population
We need to add some control columns namely:

 - source_system_code
 - created_timestamp
 - updated_timestamp

We can use a task orchestrator like Airflow to add the columns with SQL after before the data is loaded into the NDS with airbyte. I'll have to do this with some sort of bash script. Let's take an example:

### Goal
Extract the country data from the Stage database and Load it into the NDS.

<br/>

### Problem
The country relation has already been defined in the NDS. Thus, I have to prepare the data - model it to suit the country relation in the NDS.

These are the headers of the country relation that was uploaded from a CSV file.

<img src="original"/>

But these are the headers that my business people want.

<img src="modified" />

<br/>

### Solution

1. Use airbyte to extract and load the data.
2. Run some bash script which uses the ```sqlcmd``` tool to add the control columns.

```sql
USE Stage;
GO

-- Create the table
IF OBJECT_ID('country') IS NOT NULL
  DROP TABLE country;

CREATE TABLE country(Code varchar(10) not null, Country varchar(100) not null);

-- Insert the data
BULK INSERT
  Stage.dbo.country
FROM '/var/opt/mssql/building-a-data-warehouse/dw_project/seeds/my_country.csv'
WITH (FORMAT = 'CSV', FIELDTERMINATOR=',', FIRSTROW=2);

-- country code key
alter table dbo.country add country_code_key int PRIMARY KEY IDENTITY(1,1);

-- Add the required columns
alter table dbo.country add
  source_system_code int,
  create_timestamp datetime,
  update_timestamp datetime;

-- Set the data
update dbo.country
   set
     source_system_code = 2,
     create_timestamp = CURRENT_TIMESTAMP,
     update_timestamp = current_timestamp;

-- Insert the unknown record. It's used when we have an unknown value.
set IDENTITY_INSERT dbo.country on;
insert into dbo.country
  (country_code_key, code, country,
  source_system_code, create_timestamp, update_timestamp)
values (0, N'UN', N'Unknown', 0, '19000101', '19000101')
set IDENTITY_INSERT dbo.country off;
```

3. We're now ready to populate the country relation in the NDS. Unfortunately we can't use Airbyte due to the metadata it appends to relations. However, we can use a simple ```INSERT SELECT``` statement to move the data from the Stage to the NDS. 
```sql
SET IDENTITY_INSERT NDS.dbo.country ON;
INSERT INTO NDS.dbo.country
  (country_key, country_code, country_name,
   source_system_code, create_timestamp, update_timestamp)
 SELECT country_key, country_code, country_name, 
       source_system_code, create_timestamp, update_timestamp
 FROM Stage.dbo.country;

SET IDENTITY_INSERT NDS.dbo.country OFF;
```


