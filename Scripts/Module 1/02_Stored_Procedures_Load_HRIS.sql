USE PS_AUTOMATING_DATA_CLEANSING
GO

CREATE PROC SPX_LOAD_HRIS

AS

BEGIN 

IF OBJECT_ID(N'dbo.HRIS', N'U') IS NOT NULL  
	DROP TABLE HRIS;  

CREATE TABLE HRIS
(
	Employee_Number INT,
	First_Name VARCHAR(200),
	Last_Name VARCHAR(20),
	Gender VARCHAR(50),
	Date_Of_Birth VARCHAR(20),
	Position VARCHAR(50),
	Department VARCHAR(50),
	Location VARCHAR(50),
	address VARCHAR(50),
	address2 VARCHAR(50),
	salary INT,
	email VARCHAR(50),
	ssn VARCHAR(20),
	github_username VARCHAR(50),
	ip_address VARCHAR(50)
)

BULK INSERT [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]
FROM 'C:\PluralSight\Courses\Automating Data Cleansing in SQL Server\Data\HRIS.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

DECLARE @ROWS_LOADED INT = (SELECT COUNT(*) FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence])
DECLARE @COLUMN_COUNT INT = (SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('Employee_Absence'))
PRINT('The [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence] table has been loaded with a shape of [' + CAST(@COLUMN_COUNT AS VARCHAR(20)) + ' columns ,' + CAST(@ROWS_LOADED AS VARCHAR(20)) + ' rows]')

END

EXEC SPX_LOAD_HRIS