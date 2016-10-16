USE SSISIncrementalLoad_Dest
GO

If Not Exists(Select name
              From sys.tables
              Where name = 'Dest1')
CREATE TABLE dbo.Dest1
 (ColID int NOT NULL 
 ,ColA varchar(10) NULL
 ,ColB datetime NULL
 ,ColC int NULL
 ,constraint PK_Dest1 primary key clustered (ColID))
 Go

  -- Load Dest1
 INSERT INTO dbo.Dest1
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'Z', '1/1/2007 12:02 AM', -2)

 -- Create Dest1
If Not Exists(Select name
              From sys.tables
              Where name = 'Dest2')
CREATE TABLE dbo.Dest2
 (ColID int NOT NULL 
 ,Name varchar(25) NULL
 ,Value int NULL
 ,constraint PK_Dest2 primary key clustered (ColID))
 Go

  -- Load Dest2
 INSERT INTO dbo.Dest2
 (ColID,Name,Value)
 VALUES
 (0, 'Willie', 11),
 (1, 'Waylon', 22),
 (2, 'Stevie', 33)
 
 -- Create Dest3
If Not Exists(Select name
              From sys.tables
              Where name = 'Dest3')
CREATE TABLE dbo.Dest3
 (ColID int NOT NULL 
 ,Value int NULL
 ,Name varchar(100) NULL
 ,constraint PK_Dest3 primary key clustered (ColID))
 Go

  -- Load Dest3
 INSERT INTO dbo.Dest3
 (ColID,Value,Name)
 VALUES
 (0, 101, 'Good-Hearted Woman'),
 (1, 202, 'Are You Sure Hank Done It This Way?')
