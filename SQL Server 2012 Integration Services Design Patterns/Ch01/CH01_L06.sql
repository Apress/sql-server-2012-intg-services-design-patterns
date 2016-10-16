USE dbaCentralLogging;
GO

/* Check to see if the table already exists; if it does, drop it */
IF (SELECT OBJECT_ID('dbo.dba_monitor_databaseGrowth')) IS NOT NULL
    DROP TABLE dbo.dba_monitor_databaseGrowth;

/* T-SQL to create a table to store data and log file size information */
CREATE TABLE dbo.dba_monitor_databaseGrowth
(
      log_id        INT IDENTITY(1,1)
    , captureDate   DATETIME
    , serverName    NVARCHAR(128)
    , databaseName  SYSNAME
    , fileSizeInKB  BIGINT
    , logSizeInKB   BIGINT

    CONSTRAINT PK_dba_monitor_databaseGrowth
        PRIMARY KEY NONCLUSTERED(log_id)
);

CREATE CLUSTERED INDEX CIX_dba_monitor_databaseGrowth
    ON dbo.dba_monitor_databaseGrowth(captureDate, serverName, databaseName);
