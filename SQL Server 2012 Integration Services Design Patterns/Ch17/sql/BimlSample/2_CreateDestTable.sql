USE SSISIncrementalLoad_Dest
GO

If Not Exists(Select name
              From sys.tables
              Where name = 'tblDest')
CREATE TABLE dbo.tblDest
 (ColID int NOT NULL 
 ,ColA varchar(10) NULL
 ,ColB datetime NULL
 ,ColC int NULL)

 If Not Exists(Select name
              From sys.tables
              Where name = 'stgUpdates')
 CREATE TABLE dbo.stgUpdates
  (ColID int NULL
  ,ColA varchar(10) NULL
  ,ColB datetime NULL
  ,ColC int NULL) 