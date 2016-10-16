/* T-SQL to update the LastMonitored value in dba_monitor_SQLServerInstances */ 
UPDATE dbo.dba_monitor_SQLServerInstances 
SET LastMonitored = GETDATE() 
WHERE SQLServerInstance = ?;
