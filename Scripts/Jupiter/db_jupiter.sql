use master
go

if db_id ('Jupiter') is not null
drop database Jupiter;
go

create database Jupiter
on primary (name = 'Jupiter_fg1'
, filename = 'd:\disk\source1\Jupiter_fg1.mdf'
, size = 2 MB, filegrowth = 512 MB)
log on (name = 'Jupiter_log'
, filename = 'd:\disk\source1\Jupiter_log.ldf'
, size = 128 MB, filegrowth = 128 KB)
collate SQL_Latin1_General_CP1_CI_AS
go

