USE PS_AUTOMATING_DATA_CLEANSING
GO

CREATE PROC SPX_LOAD_EMPLOYEE_ABSENCE

AS

BEGIN 

IF OBJECT_ID(N'dbo.Employee_Absence', N'U') IS NOT NULL  
   DROP TABLE Employee_Absence;  

CREATE TABLE Employee_Absence
(
 Employee_Number INT,
 Employee_Name VARCHAR(200),
 Stored_Location VARCHAR(20),
 Business_Unit VARCHAR(50),
 Division VARCHAR(20),
 Age INT,
 Length_Of_Service INT,
 Hours_Absent VARCHAR(200),
 Last_Absent_Date DATE,
 Hire_Date DATE
)

BULK INSERT [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]
FROM 'C:\PluralSight\Courses\Automating Data Cleansing in SQL Server\Data\Employee_Absence.csv' -- full C:/ Path
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

DECLARE @ROWS_LOADED INT = (SELECT COUNT(*) FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence])
DECLARE @COLUMN_COUNT INT = (SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('Employee_Absence'))
PRINT('The [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence] table has been successfully loaded with a shape of [' + CAST(@COLUMN_COUNT AS VARCHAR(20)) + ' columns ,' + CAST(@ROWS_LOADED AS VARCHAR(20)) + ' rows]')

END

EXEC SPX_LOAD_EMPLOYEE_ABSENCE