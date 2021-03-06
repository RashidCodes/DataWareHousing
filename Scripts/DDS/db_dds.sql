/* Database Configuration

Considerations
--------------
1. Keep database names short and concise.
2. Keep the collation of all data warehouse databases the same.
3. Consider case-sensitivity
4. Create six filegroups. This is necessary so that when we create a new database (for example, a new DDS) SQL Server
will put the database data and log files in the correct locations.
5. Arrange the data files: When creating the database, place data files as per the filegroup locations. We have six physical disks for data, so use
them wel by spreading the filegroups into different physical disks. Maintain the data and log files manually; do not rely on autogrowth. If there is a
data load operation that requires more log space than what's the available, the operation will take a long time to complete because it has to wait
until the grow operation completes.
6.



/var/opt/mssql/disk/data1 to /var/opt/mssql/disk/data6 and /var/opt/mssql/disk/log1 to /var/opt/mssql/disk/log4
are the mount points of the six data volumes and four log volumes that we built in the SAN */

USE MASTER
GO

IF DB_ID('DDS') IS NOT NULL
  DROP DATABASE DDS;
GO

CREATE DATABASE DDS
ON PRIMARY (NAME = 'dds_fg1'
, FILENAME = "/var/opt/mssql/disk/data1/dds_fg1.mdf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg2 (NAME = 'dds_fg2'
, FILENAME = "/var/opt/mssql/disk/data2/dds_fg2.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg3 (NAME = 'dds_fg3'
, FILENAME = "/var/opt/mssql/disk/data3/dds_fg3.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg4 (NAME = 'dds_fg4'
, FILENAME = "/var/opt/mssql/disk/data4/dds_fg4.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg5 (NAME = 'dds_fg5'
, FILENAME = "/var/opt/mssql/disk/data5/dds_fg5.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg6 (NAME = 'dds_fg6'
, FILENAME = "/var/opt/mssql/disk/data5/dds_fg6.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
LOG ON (NAME = 'dds_log'
, FILENAME = "/var/opt/mssql/disk/log1/dds_log.ldf"
, size = 1 MB, FILEGROWTH = 512 KB)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DDS SET RECOVERY SIMPLE
GO
ALTER DATABASE DDS SET AUTO_SHRINK OFF
GO
ALTER DATABASE DDS SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE DDS SET AUTO_UPDATE_STATISTICS ON
GO

--==================================================


IF DB_ID('NDS') IS NOT NULL
  DROP DATABASE NDS;
GO

CREATE DATABASE NDS
ON PRIMARY (NAME = 'nds_fg1'
, FILENAME = "/var/opt/mssql/disk/data1/nds_fg1.mdf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP nds_fg2 (NAME = 'nds_fg2'
, FILENAME = "/var/opt/mssql/disk/data2/nds_fg2.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP nds_fg3 (NAME = 'nds_fg3'
, FILENAME = "/var/opt/mssql/disk/data3/nds_fg3.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP nds_fg4 (NAME = 'nds_fg4'
, FILENAME = "/var/opt/mssql/disk/data4/nds_fg4.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP nds_fg5 (NAME = 'nds_fg5'
, FILENAME = "/var/opt/mssql/disk/data5/nds_fg5.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP nds_fg6 (NAME = 'nds_fg6'
, FILENAME = "/var/opt/mssql/disk/data5/nds_fg6.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
LOG ON (NAME = 'nds_log'
, FILENAME = "/var/opt/mssql/disk/log1/nds_log.ldf"
, size = 1 MB, FILEGROWTH = 512 KB)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE NDS SET RECOVERY SIMPLE
GO
ALTER DATABASE NDS SET AUTO_SHRINK OFF
GO
ALTER DATABASE NDS SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE NDS SET AUTO_UPDATE_STATISTICS ON
GO


--==================================================
/*

1. For the stage database, we don't need automatic statistic updating
because we don't usually index tables.

2. We still want the simple recovery model

3. We don't need autoshrink for the stage database.

4. Put the stage log file on a different disk from the NDS and DDS log; this is important
for ETL performance because it minimizes the contention of the log traffic between data stores.

5. Because of the size and the nature of loading, we don't need to split the stage database
over six disks. Three of four would be more than enough because we can allocate different
stage tables in three of four different disks that can be loaded simultaneously.
*/

IF DB_ID('Stage') IS NOT NULL
  DROP DATABASE Stage;
GO

CREATE DATABASE Stage
ON PRIMARY (NAME = 'stage_fg1'
, FILENAME = "/var/opt/mssql/disk/data1/stage_fg1.mdf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP stage_fg2 (NAME = 'stage_fg2'
, FILENAME = "/var/opt/mssql/disk/data2/stage_fg2.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP stage_fg3 (NAME = 'stage_fg3'
, FILENAME = "/var/opt/mssql/disk/data3/stage_fg3.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP stage_fg4 (NAME = 'stage_fg4'
, FILENAME = "/var/opt/mssql/disk/data4/stage_fg4.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP stage_fg5 (NAME = 'stage_fg5'
, FILENAME = "/var/opt/mssql/disk/data1/stage_fg5.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP stage_fg6 (NAME = 'stage_fg6'
, FILENAME = "/var/opt/mssql/disk/data2/stage_fg6.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
LOG ON (NAME = 'stage_log'
, FILENAME = "/var/opt/mssql/disk/log2/stage_log.ldf"
, size = 1 MB, FILEGROWTH = 512 KB)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE Stage SET RECOVERY SIMPLE
GO
ALTER DATABASE Stage SET AUTO_CREATE_STATISTICS ON
GO

--=======================================
/* Because the size of the metadata database is small and because the way we use the metadata
database is more like OLTP, we don't need to spread it across six disks. Two disks are enough.

We still need to put the metadata log file on a separate disk, though, not for the benefit of the
metadata database itself, but so that we don't affect the performance the NDS, the DDS, and the Stage log files.
*/

IF DB_ID('Meta') IS NOT NULL
  DROP DATABASE Meta;
GO

CREATE DATABASE Meta
ON PRIMARY (NAME = 'dds_fg1'
, FILENAME = "/var/opt/mssql/disk/data5/dds_fg1.mdf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg2 (NAME = 'dds_fg2'
, FILENAME = "/var/opt/mssql/disk/data5/dds_fg2.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg3 (NAME = 'dds_fg3'
, FILENAME = "/var/opt/mssql/disk/data5/dds_fg3.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg4 (NAME = 'dds_fg4'
, FILENAME = "/var/opt/mssql/disk/data6/dds_fg4.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg5 (NAME = 'dds_fg5'
, FILENAME = "/var/opt/mssql/disk/data6/dds_fg5.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
, FILEGROUP dds_fg6 (NAME = 'dds_fg6'
, FILENAME = "/var/opt/mssql/disk/data6/dds_fg6.ndf"
, SIZE = 30 MB, FILEGROWTH = 5 MB)
LOG ON (NAME = 'dds_log'
, FILENAME = "/var/opt/mssql/disk/log4/dds_log.ldf"
, size = 1 MB, FILEGROWTH = 512 KB)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE Meta SET RECOVERY FULL
GO
ALTER DATABASE Meta SET AUTO_SHRINK OFF
GO
ALTER DATABASE Meta SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE Meta SET AUTO_UPDATE_STATISTICS ON
GO



--=============================
-- Dummy database to create FGs
--=============================
CREATE DATABASE Dummy
ON PRIMARY (NAME = 'dummy_fg1'
, FILENAME = "/var/opt/mssql/disk/source1/dummy_fg1.mdf"
, SIZE = 1MB, FILEGROWTH = 5MB)
GO
