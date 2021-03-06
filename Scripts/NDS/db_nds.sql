use master
go

if db_id ('NDS') is not null
drop database NDS;
go

create database NDS 
on primary (name = 'nds_fg1'
, filename = '/var/opt/mssql/disk/data1/nds_fg1.mdf'
, size = 10 MB, filegrowth = 2 MB)
, filegroup nds_fg2 (name = 'nds_fg2'
, filename = '/var/opt/mssql/disk/data2/nds_fg2.ndf'
, size = 10 MB, filegrowth = 2 MB)
, filegroup nds_fg3 (name = 'nds_fg3'
, filename = '/var/opt/mssql/disk/data3/nds_fg3.ndf'
, size = 10 MB, filegrowth = 2 MB)
, filegroup nds_fg4 (name = 'nds_fg4'
, filename = '/var/opt/mssql/disk/data4/nds_fg4.ndf'
, size = 10 MB, filegrowth = 2 MB)
, filegroup nds_fg5 (name = 'nds_fg5'
, filename = '/var/opt/mssql/disk/data5/nds_fg5.ndf'
, size = 10 MB, filegrowth = 2 MB)
, filegroup nds_fg6 (name = 'nds_fg6'
, filename = '/var/opt/mssql/disk/data6/nds_fg6.ndf'
, size = 10 MB, filegrowth = 2 MB)
log on (name = 'nds_log'
, filename = '/var/opt/mssql/disk/log2/nds_log.ldf'
, size = 1 MB, filegrowth = 512 KB)
collate SQL_Latin1_General_CP1_CI_AS
go

alter database NDS set recovery simple 
go
alter database NDS set auto_shrink off
go
alter database NDS set auto_create_statistics on
go
alter database NDS set auto_update_statistics on
go