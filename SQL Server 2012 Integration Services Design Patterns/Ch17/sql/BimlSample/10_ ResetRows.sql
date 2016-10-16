Use SSISIncrementalLoad_Source
Go

TRUNCATE TABLE dbo.tblSource

-- insert an "unchanged" row, a "changed" row, and a "new" row
INSERT INTO dbo.tblSource
(ColID,ColA,ColB,ColC)
VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'B', '1/1/2007 12:02 AM', -2),
 (2, 'N', '1/1/2007 12:03 AM', -3)

Use SSISIncrementalLoad_Stage
Go

TRUNCATE TABLE dbo.stgUpdates_tblSource
TRUNCATE TABLE dbo.tblSource

-- insert an "unchanged" row and a "changed" row
INSERT INTO dbo.tblSource
(ColID,ColA,ColB,ColC)
VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'C', '1/1/2007 12:02 AM', -2)

 Truncate Table dbo.stgUpdates_Source1
 Truncate Table dbo.Source1

 INSERT INTO dbo.Source1
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'Z', '1/1/2007 12:02 AM', -2)

 Truncate Table dbo.stgUpdates_Source2
 Truncate Table dbo.Source2

  INSERT INTO dbo.Source2
 (ColID,Name,Value)
 VALUES
 (0, 'Willie', 11),
 (1, 'Waylon', 22),
 (2, 'Stevie', 33)

 Truncate Table dbo.stgUpdates_Source3
 Truncate Table dbo.Source3

 INSERT INTO dbo.Source3
 (ColID,Value,Name)
 VALUES
 (0, 101, 'Good-Hearted Woman'),
 (1, 202, 'Are You Sure Hank Done It This Way?')

