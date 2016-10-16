USE SSISIncrementalLoad_Source
GO

 -- Create Source1
If Not Exists(Select name
              From sys.tables
              Where name = 'Source1')
CREATE TABLE dbo.Source1
 (ColID int NOT NULL 
 ,ColA varchar(10) NULL
 ,ColB datetime NULL
 ,ColC int NULL
 ,constraint PK_Source1 primary key clustered (ColID))
 Go

  -- Load Source1
 INSERT INTO dbo.Source1
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'B', '1/1/2007 12:02 AM', -2),
 (2, 'C', '1/1/2007 12:03 AM', -3),
 (3, 'D', '1/1/2007 12:04 AM', -4),
 (4, 'E', '1/1/2007 12:05 AM', -5),
 (5, 'F', '1/1/2007 12:06 AM', -6)


 -- Create Source1
If Not Exists(Select name
              From sys.tables
              Where name = 'Source2')
CREATE TABLE dbo.Source2
 (ColID int NOT NULL 
 ,Name varchar(25) NULL
 ,Value int NULL
 ,constraint PK_Source2 primary key clustered (ColID))
 Go

  -- Load Source2
 INSERT INTO dbo.Source2
 (ColID,Name,Value)
 VALUES
 (0, 'Willie', 11),
 (1, 'Waylon', 22),
 (2, 'Stevie Ray', 33),
 (3, 'Johnny', 44),
 (4, 'Kris', 55)
 
 -- Create Source3
If Not Exists(Select name
              From sys.tables
              Where name = 'Source3')
CREATE TABLE dbo.Source3
 (ColID int NOT NULL 
 ,Value int NULL
 ,Name varchar(100) NULL
 ,constraint PK_Source3 primary key clustered (ColID))
 Go

  -- Load Source3
 INSERT INTO dbo.Source3
 (ColID,Value,Name)
 VALUES
 (0, 101, 'Good-Hearted Woman'),
 (1, 202, 'Lonesome, Onry, and Mean'),
 (2, 303, 'The Sky Is Crying'),
 (3, 404, 'Ghost Riders in the Sky'),
 (4, 505, 'Sunday Morning, Coming Down')
