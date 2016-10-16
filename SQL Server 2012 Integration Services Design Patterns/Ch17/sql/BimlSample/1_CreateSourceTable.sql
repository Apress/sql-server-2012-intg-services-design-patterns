USE SSISIncrementalLoad_Source
GO

If Not Exists(Select name
              From sys.tables
              Where name = 'tblSource')
CREATE TABLE dbo.tblSource
 (ColID int NOT NULL 
 ,ColA varchar(10) NULL
 ,ColB datetime NULL constraint df_ColB default (getDate())
 ,ColC int NULL
 ,constraint PK_tblSource primary key clustered (ColID))

