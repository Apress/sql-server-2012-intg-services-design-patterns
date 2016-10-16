USE SSISIncrementalLoad_Source
GO

 -- insert an "unchanged" row
INSERT INTO dbo.tblSource
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'B', '1/1/2007 12:02 AM', -2),
 (2, 'N', '1/1/2007 12:03 AM', -3)



USE SSISIncrementalLoad_Dest
GO

 -- insert an "unchanged" row
INSERT INTO dbo.tblDest
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'C', '1/1/2007 12:02 AM', -2)
