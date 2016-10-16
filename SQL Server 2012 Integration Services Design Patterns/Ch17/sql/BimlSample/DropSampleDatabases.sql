use master
go

If Exists(Select name
              From sys.databases
              Where name = 'SSISIncrementalLoad_Source')
 DROP DATABASE [SSISIncrementalLoad_Source]


If Exists(Select name
              From sys.databases
              Where name = 'SSISIncrementalLoad_Dest')
 DROP DATABASE [SSISIncrementalLoad_Dest] 