
SELECT s.ColID, s.ColA, s.ColB, s.ColC 
FROM SSISIncrementalLoad_Source.dbo.tblSource s
LEFT JOIN SSISIncrementalLoad_Dest.dbo.tblDest d ON d.ColID = s.ColID
WHERE d.ColID IS NULL

INSERT INTO SSISIncrementalLoad_Dest.dbo.tblDest
(ColID, ColA, ColB, ColC)
SELECT s.ColID, s.ColA, s.ColB, s.ColC 
FROM SSISIncrementalLoad_Source.dbo.tblSource s
LEFT JOIN SSISIncrementalLoad_Dest.dbo.tblDest d
 ON d.ColID = s.ColID
WHERE d.ColID IS NULL

SELECT ColID, ColA, ColB, ColC
FROM SSISIncrementalLoad_Dest.dbo.tblDest