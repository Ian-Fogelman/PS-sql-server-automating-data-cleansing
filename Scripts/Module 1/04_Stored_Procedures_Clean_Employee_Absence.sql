
-- Data Quality Issues:
-- #1 - Inconsistently formatted date fields in last absence column.
-- #2 - Null values in the length_of_service column.
USE [PS_AUTOMATING_DATA_CLEANSING]


--VIEW SOURCE DATA
SELECT
[Employee_Number], 
[Employee_Name], 
[Stored_Location], 
[Business_Unit], 
[Division],
[Age],
[Length_Of_Service] , 
[Hours_Absent],
[Last_Absent_Date], 
[Hire_Date]

FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]

--SOLUTION 1
SELECT 
[Employee_Number], 
[Employee_Name], 
[Stored_Location], 
[Business_Unit], 
[Division],
[Age],
[Length_Of_Service] , 
[Hours_Absent],
FORMAT ([Last_Absent_Date], 'MM-dd-yyyy') as [Last_Absent_Date],
FORMAT ([Hire_Date], 'MM-dd-yyyy') as [Hire_Date]
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]
		
--SOLUTION 2
SELECT DATEDIFF(YEAR,HIRE_DATE,GETDATE()) AS CALCULATED_LENGTH_OF_SERVICE
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]

--SOLUTION 2 IN QUERY FORMAT
SELECT 
[Employee_Number], 
[Employee_Name], 
[Stored_Location], 
[Business_Unit], 
[Division],
[Age],
CASE WHEN [Length_Of_Service] IS NULL THEN DATEDIFF(YEAR,HIRE_DATE,GETDATE()) ELSE [Length_Of_Service] END AS [Length_Of_Service] , 
[Hours_Absent],
[Last_Absent_Date], 
[Hire_Date]
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]

-- BOTH SOLUTIONS IN A STORED PROCEDURE THAT PERSISTS THE CLEANSED DATA

CREATE PROC SPX_CLEAN_EMPLOYEE_ABSENCE_TABLE

AS

BEGIN

IF OBJECT_ID(N'dbo.Employee_Absence_Cleaned', N'U') IS NOT NULL  
   DROP TABLE Employee_Absence_Cleaned;  

SELECT 
[Employee_Number], 
[Employee_Name], 
[Stored_Location], 
[Business_Unit], 
[Division],
[Age],
CASE WHEN [Length_Of_Service] IS NULL THEN DATEDIFF(YEAR,HIRE_DATE,GETDATE()) ELSE [Length_Of_Service] END AS [Length_Of_Service] , 
[Hours_Absent],
FORMAT ([Last_Absent_Date], 'MM-dd-yyyy') AS [Last_Absent_Date],
FORMAT ([Hire_Date], 'MM-dd-yyyy') AS [Hire_Date]
INTO [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence_Cleaned]
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence]

END

EXEC SPX_CLEAN_EMPLOYEE_ABSENCE_TABLE

SELECT * FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Employee_Absence_Cleaned]

