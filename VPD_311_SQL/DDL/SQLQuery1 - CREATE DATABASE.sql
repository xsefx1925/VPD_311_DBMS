USE master;
GO

CREATE DATABASE VPD_311_SQL
ON -- определ€ем параметры файла базы данных
(
	NAME		= VPD_311_SQL,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL.MDF',
	SIZE        =  8MB,
	MAXSIZE     =  500MB,
	FILEGROWTH  = 8MB

)
LOG ON -- определ€ем параметры файла  журналабазы данных
(
	NAME		= VPD_311_SQL_Log,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL_Log.ldf',
	SIZE        =  8MB,
	MAXSIZE     =  500MB,
	FILEGROWTH  = 8MB

)
GO