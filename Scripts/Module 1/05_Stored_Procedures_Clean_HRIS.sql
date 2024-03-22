-- Data Quality Issues:

-- #1 - Non-ASCII characters for the github_user column.
-- #2 - Improperly formatted IP addresses.
-- #3 - Inconsistently formatted social security numbers.

USE PS_AUTOMATING_DATA_CLEANSING

--VIEW SOURCE DATA
SELECT 
[Employee_Number], 
[First_Name], 
[Last_Name], 
[Gender], 
[Date_Of_Birth], 
[Position], 
[Department], 
[Location], 
[address], 
[address2], 
[salary], 
[email], 
[ssn], 
[github_username], 
[ip_address]

FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]

-- SOLUTION 1 - NON ASCII CHARACTERS
SELECT [github_username] FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]
WHERE [github_username] COLLATE Latin1_General_BIN LIKE '%[^ -~]%'

SELECT CASE WHEN [github_username] COLLATE Latin1_General_BIN LIKE '%[^ -~]%' THEN NULL ELSE [github_username] END AS [github_username] 
FROM  [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]

-- SOLUTION 2 - INVALID IP ADDRESS

CREATE VIEW VW_BAD_IP_ADDRESSES
AS

SELECT * 
FROM(
SELECT 
EMPLOYEE_NUMBER,
LEFT([ip_address],3) AS LEFT_3_IP,
ip_address,
CASE WHEN TRY_PARSE(LEFT([ip_address],3) AS INT) > 255 THEN 'Y' ELSE 'N' END AS Incorrect_Ip
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS])
AS X 
WHERE INCORRECT_IP = 'Y'


-- SOLUTION 3 - INCONSISTENTLY FORMATTED SOCIAL SECURITY NUMBERS
SELECT [ssn] FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]

SELECT [ssn], CASE WHEN SUBSTRING([ssn],4,1) != '-' THEN 'Y' ELSE 'N' END AS Invalid_SSN,
CASE WHEN SUBSTRING([ssn],4,1) != '-' THEN SUBSTRING([ssn],1,3) + '-' +  SUBSTRING([ssn],4,2) + '-' +  SUBSTRING([ssn],6,4) ELSE [ssn] END AS Formatted_ssn
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS]

CREATE PROC SPX_CLEAN_HRIS_TABLE

AS

BEGIN

IF OBJECT_ID(N'dbo.HRIS_Cleaned', N'U') IS NOT NULL  
   DROP TABLE HRIS_Cleaned;  

SELECT 
HR.[Employee_Number], 
[First_Name], 
[Last_Name],
[Gender],
[Date_Of_Birth], 
[Position], 
[Department],
[Location], 
[address], 
[address2], 
[salary], 
[email], 
CASE WHEN SUBSTRING([ssn],4,1) != '-' THEN SUBSTRING([ssn],1,3) + '-' +  SUBSTRING([ssn],4,2) + '-' +  SUBSTRING([ssn],6,4) ELSE [ssn] END AS [ssn],
CASE WHEN [github_username] COLLATE Latin1_General_BIN LIKE '%[^ -~]%' THEN NULL ELSE [github_username] END AS [github_username],
CASE WHEN BAD_IP.INCORRECT_IP = 'Y' THEN NULL ELSE HR.[ip_address] END AS [ip_address]

INTO [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS_Cleaned]
FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS] as HR
	LEFT JOIN VW_BAD_IP_ADDRESSES AS BAD_IP
		ON HR.EMPLOYEE_NUMBER = BAD_IP.EMPLOYEE_NUMBER

END

EXEC SPX_CLEAN_HRIS_TABLE

SELECT * FROM [PS_AUTOMATING_DATA_CLEANSING].[dbo].[HRIS_Cleaned]