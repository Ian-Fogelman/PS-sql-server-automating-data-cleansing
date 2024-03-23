IF OBJECT_ID(N'dbo.ALERT_LOGGING', N'U') IS NOT NULL  
   DROP TABLE ALERT_LOGGING;  

CREATE TABLE ALERT_LOGGING
(
 ID INT PRIMARY KEY IDENTITY(1,1),
 DATETIME DATETIME,
 MESSAGE VARCHAR(MAX)
)

SELECT * FROM ALERT_LOGGING