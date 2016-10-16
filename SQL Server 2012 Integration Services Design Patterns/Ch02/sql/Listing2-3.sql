Declare @ExecId bigint
Exec SSISDB.custom.execute_catalog_package 'Chapter2','Chapter 2','Chapter2.dtsx',
@ExecId Output
