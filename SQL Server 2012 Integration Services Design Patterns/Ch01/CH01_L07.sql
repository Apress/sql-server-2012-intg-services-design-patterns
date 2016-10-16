/* T-SQL to retrieve unused indexes */

/* Create a variable to hold a list of indexes */
DECLARE @Indexes    TABLE
( serverName        NVARCHAR(128)
, schemaName        SYSNAME
, schemaID          INT
, databaseName      SYSNAME
, databaseID        INT
, tableName         SYSNAME
, objectID          INT
, indexName         SYSNAME
, indexID           INT
, indexType         NVARCHAR(60)
, isPrimaryKey      BIT
, isUnique          BIT
, isFiltered        BIT
, isPartitioned     BIT
, numberOfRows      BIGINT
, totalPages        BIGINT);

/* Iterate through all databases */
INSERT INTO @Indexes (serverName, schemaName, schemaID, databaseName, databaseID, tableName, objectID, indexName, indexID, indexType, isUnique, isPrimaryKey, isFiltered, isPartitioned, numberOfRows, totalPages)
EXECUTE sys.sp_MSforeachdb
' USE ?; 
SELECT @@SERVERNAME
    , SCHEMA_NAME(t.schema_id)
    , t.schema_id
    , DB_NAME()
    , DB_ID()
    , t.name
    , t.object_id
    , i.name
    , i.index_id
    , i.type_desc
    , i.is_primary_key
    , i.is_unique
    , i.has_filter
    , CASE WHEN COUNT(p.partition_id) > 1 THEN 1 ELSE 0 END
    , SUM(p.rows)
    , SUM(au.total_pages)
FROM sys.tables             AS t WITH (NOLOCK)
JOIN sys.indexes            AS i WITH (NOLOCK)
ON i.object_id = t.object_id
JOIN sys.partitions         AS p WITH (NOLOCK)
ON p.object_id = i.object_id
AND p.index_id = i.index_id
JOIN sys.allocation_units   AS au WITH (NOLOCK)
ON au.container_id = p.partition_id
WHERE i.index_id <> 0 /* exclude heaps */
GROUP BY SCHEMA_NAME(t.schema_id)
, t.schema_id
, t.name
, t.object_id
, i.name
, i.index_id
, i.type_desc
, i.has_filter
, i.is_unique
, i.is_primary_key;';

/* Retrieve index stats for return to our central repository */
SELECT GETDATE()                AS [captureDate]
    , i.serverName
    , i.schemaName
    , i.databaseName
    , i.tableName
    , i.indexName
    , i.indexType
    , i.isFiltered
    , i.isPartitioned
    , i.numberOfRows
    , ddius.user_seeks          AS [userSeeksSinceReboot]
    , ddius.user_scans          AS [userScansSinceReboot]
    , ddius.user_lookups        AS [userLookupsSinceReboot]
    , ddius.user_updates        AS [userUpdatesSinceReboot]
    , (i.totalPages * 8) / 1024 AS [indexSizeInMB] /* pages are 8KB */
    , dosi.sqlserver_start_time AS [lastReboot]
FROM @Indexes                       AS i
JOIN sys.dm_db_index_usage_stats    AS ddius
     ON i.databaseID = ddius.database_id
    AND i.objectID = ddius.object_id
    AND i.indexID = ddius.index_id
CROSS APPLY sys.dm_os_sys_info      AS dosi
WHERE /* exclude system databases */
        i.databaseName    NOT IN ('master', 'msdb', 'tempdb', 'model') 
    /* exclude unique indexes; assume they are serving a business function */
    AND i.isUnique      = 0 
    /* exclude primary keys; assume they are serving a business function */
    AND i.isPrimaryKey  = 0 
    /* no seeks have been performed since the last server reboot */
    AND user_seeks      = 0; 
