USE PS_AUTOMATING_DATA_CLEANSING
GO

CREATE PROC SPX_LOAD_LEARNING_MANAGEMENT

AS

BEGIN 

IF OBJECT_ID(N'dbo.Learning_Management', N'U') IS NOT NULL  
   DROP TABLE Learning_Management;  

CREATE TABLE Learning_Management
(
 Employee_Number INT,
 Employee_Name VARCHAR(200),
 Course_Id VARCHAR(20),
 Course_Name VARCHAR(50),
 Completion_Date Date,
 Completion_Status VARCHAR(50)
)

BULK INSERT [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management]
FROM 'C:\PluralSight\Courses\Automating Data Cleansing in SQL Server\Data\Learning_Management.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2
)

DECLARE @ROWS_LOADED INT = (SELECT COUNT(*) FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management])
DECLARE @COLUMN_COUNT INT = (SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('Learning_Management'))
PRINT('The [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS] table has been successfully loaded with a shape of [' + CAST(@COLUMN_COUNT AS VARCHAR(20)) + ' columns ,' + CAST(@ROWS_LOADED AS VARCHAR(20)) + ' rows]')

END

EXEC SPX_LOAD_LEARNING_MANAGEMENT

SELECT * FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management]