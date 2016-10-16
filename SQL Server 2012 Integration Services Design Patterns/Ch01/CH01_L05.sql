/* T-SQL to retrieve current data and log file sizes for all databases on the server */
SELECT GETDATE()        AS [captureDate]
    , @@SERVERNAME      AS [serverName]
    , instance_name     AS [databaseName]
    , SUM(
        CASE 
            WHEN counter_name = 'Data File(s) Size (KB)' 
            THEN cntr_value
        END
      )                 AS 'dataSizeInKB'
    , SUM(
        CASE 
            WHEN counter_name = 'Log File(s) Size (KB)' 
            THEN cntr_value
        END
      )                 AS 'logSizeInKB'
FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Data File(s) Size (KB)'
                     , 'Log File(s) Size (KB)')
    /* optional: remove _Total to avoid accidentially 
       double-counting in queries */
    AND instance_name <> '_Total' 
GROUP BY instance_name;
