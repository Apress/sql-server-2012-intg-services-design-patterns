USE dbaCentralLogging;
GO

/* Check to see if the table already exists; if it does, drop it */
IF (SELECT OBJECT_ID('dbo.dba_monitor_unusedIndexes')) IS NOT NULL
    DROP TABLE dbo.dba_monitor_unusedIndexes;

/* T-SQL to create the a table to log unused index information */
CREATE TABLE dbo.dba_monitor_unusedIndexes
( log_id                    INT IDENTITY(1,1)
, captureDate               DATETIME
, serverName                NVARCHAR(128)
, schemaName                SYSNAME
, databaseName              SYSNAME
, tableName                 SYSNAME
, indexName                 SYSNAME
, indexType                 NVARCHAR(60)
, isFiltered                BIT
, isPartitioned             BIT
, numberOfRows              BIGINT
, userSeeksSinceReboot      BIGINT
, userScansSinceReboot      BIGINT
, userLookupsSinceReboot    BIGINT
, userUpdatesSinceReboot    BIGINT
, indexSizeInMB             BIGINT
, lastReboot                DATETIME

    CONSTRAINT PK_dba_monitor_unusedIndexes
        PRIMARY KEY NONCLUSTERED(log_id)
);

CREATE CLUSTERED INDEX CIX_dba_monitor_unusedIndexes
    ON dbo.dba_monitor_unusedIndexes(captureDate);
