-- Data Quality Issues:

-- #1 - Missing employee_name values for employees who completed courses.

USE PS_AUTOMATING_DATA_CLEANSING

--VIEW SOURCE DATA
SELECT 
[Employee_Number], 
[Employee_Name], 
[Course_Id], 
[Course_Name], 
[Completion_Date], 
[Completion_Status]

FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management] 

SELECT * FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]

-- SOLUTION #1
SELECT 
LM.[Employee_Number], 
CASE WHEN LM.[Employee_Name] IS NULL THEN HR.FIRST_NAME + ' ' + HR.LAST_NAME ELSE LM.[Employee_Name] END AS [Employee_Name], 
LM.[Course_Id],
LM.[Course_Name],
LM.[Completion_Date], 
LM.[Completion_Status]

FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management] AS LM
	JOIN [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS] AS HR
		ON LM.EMPLOYEE_NUMBER = HR.EMPLOYEE_NUMBER

CREATE PROC SPX_CLEAN_LEARNING_MANAGEMENT_TABLE 

AS

BEGIN

SELECT 
LM.[Employee_Number], 
CASE WHEN LM.[Employee_Name] IS NULL THEN HR.FIRST_NAME + ' ' + HR.LAST_NAME ELSE LM.[Employee_Name] END AS [Employee_Name], 
LM.[Course_Id],
LM.[Course_Name],
LM.[Completion_Date], 
LM.[Completion_Status]
INTO [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management_Cleaned]
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management] AS LM
	JOIN [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS] AS HR
		ON LM.EMPLOYEE_NUMBER = HR.EMPLOYEE_NUMBER

END

EXEC SPX_CLEAN_LEARNING_MANAGEMENT_TABLE

SELECT * FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[Learning_Management_Cleaned]
