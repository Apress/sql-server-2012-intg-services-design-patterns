Use master
Go

If Not Exists(Select name
              From sys.databases
			  Where name = 'SSISIncrementalLoad_Stage')
 Create Database SSISIncrementalLoad_Stage
Go

Use SSISIncrementalLoad_Stage
Go


CREATE TABLE dbo.tblSource(
	ColID int NOT NULL,
	ColA varchar(10) NULL,
	ColB datetime NULL,
	ColC int NULL
)

CREATE TABLE dbo.stgUpdates_tblSource(
	ColID int NOT NULL,
	ColA varchar(10) NULL,
	ColB datetime NULL,
	ColC int NULL
)
Go

INSERT INTO dbo.tblSource
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'B', '1/1/2007 12:02 AM', -2),
 (2, 'N', '1/1/2007 12:03 AM', -3)
 Go


CREATE TABLE dbo.Source1(
	ColID int NOT NULL,
	ColA varchar(10) NULL,
	ColB datetime NULL,
	ColC int NULL
)

CREATE TABLE dbo.stgUpdates_Source1(
	ColID int NOT NULL,
	ColA varchar(10) NULL,
	ColB datetime NULL,
	ColC int NULL
)
Go

 INSERT INTO dbo.Source1
 (ColID,ColA,ColB,ColC)
 VALUES
 (0, 'A', '1/1/2007 12:01 AM', -1),
 (1, 'Z', '1/1/2007 12:02 AM', -2)
Go


CREATE TABLE dbo.Source2(
	ColID int NOT NULL,
	Name varchar(25) NULL,
	Value int NULL
)

CREATE TABLE dbo.stgUpdates_Source2(
	ColID int NOT NULL,
	Name varchar(25) NULL,
	Value int NULL
)
Go

 INSERT INTO dbo.Source2
 (ColID,Name,Value)
 VALUES
 (0, 'Willie', 11),
 (1, 'Waylon', 22),
 (2, 'Stevie', 33)
Go

CREATE TABLE dbo.Source3(
	ColID int NOT NULL,
	Value int NULL,
	Name varchar(100) NULL
) 

CREATE TABLE dbo.stgUpdates_Source3(
	ColID int NOT NULL,
	Value int NULL,
	Name varchar(100) NULL
)
Go

 INSERT INTO dbo.Source3
 (ColID,Value,Name)
 VALUES
 (0, 101, 'Good-Hearted Woman'),
 (1, 202, 'Are You Sure Hank Done It This Way?')
Go
