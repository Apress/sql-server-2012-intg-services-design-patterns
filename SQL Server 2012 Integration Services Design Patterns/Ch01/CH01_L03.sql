USE dbaCentralLogging;
GO

/* Clean up the dbo.dba_monitor_SQLServerInstances table */
TRUNCATE TABLE dbo.dba_monitor_SQLServerInstances;

/* Example code to populate the dba_monitor_SQLServerInstances table */
INSERT INTO dbo.dba_monitor_SQLServerInstances
(
	  SQLServerInstance
)
SELECT @@SERVERNAME -- The name of the server that hosts the central repository
UNION ALL
SELECT 'YourSQLServer' -- Example of a SQL Server instance
UNION ALL
SELECT 'YourSQLServer\Instance'; -- Example of a server with multiple instances 
