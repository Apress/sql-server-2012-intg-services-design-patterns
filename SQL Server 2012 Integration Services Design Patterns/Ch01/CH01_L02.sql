USE dbaCentralLogging;
GO

/* Check to see if the table already exists; if it does, drop it */
IF (SELECT OBJECT_ID('dbo.dba_monitor_SQLServerInstances')) IS NOT NULL
    DROP TABLE dbo.dba_monitor_SQLServerInstances;

/* Create a table to store the instances we wish to monitor */
CREATE TABLE dbo.dba_monitor_SQLServerInstances
(
	  SQLServerInstance		NVARCHAR(128)
	, LastMonitored			SMALLDATETIME		NULL

	CONSTRAINT PK_dba_monitor_SQLServerInstances
		PRIMARY KEY CLUSTERED(SQLServerInstance)
);
