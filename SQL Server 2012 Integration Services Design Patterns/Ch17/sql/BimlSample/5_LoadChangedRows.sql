
SELECT d.ColID, d.ColA, d.ColB, d.ColC--, s.*
FROM SSISIncrementalLoad_Dest.dbo.tblDest d
INNER JOIN SSISIncrementalLoad_Source.dbo.tblSource s
 ON s.ColID = d.ColID
WHERE (
   (d.ColA != s.ColA)
 OR (d.ColB != s.ColB) 
 OR (d.ColC != s.ColC)
 )


UPDATE d
SET
 d.ColA = s.ColA
,d.ColB = s.ColB
,d.ColC = s.ColC
FROM SSISIncrementalLoad_Dest.dbo.tblDest d
INNER JOIN SSISIncrementalLoad_Source.dbo.tblSource s ON s.ColID = d.ColID
WHERE (
   (d.ColA != s.ColA)
 OR (d.ColB != s.ColB) 
 OR (d.ColC != s.ColC)
 )

SELECT ColID, ColA, ColB, ColC
FROM SSISIncrementalLoad_Dest.dbo.tblDest
