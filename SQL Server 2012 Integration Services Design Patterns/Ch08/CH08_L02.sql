USE PDW_Source_Example;
GO

/* Check to see if the partition function already exists; if it does, do nothing */
IF NOT EXISTS (SELECT * FROM sys.partition_functions WHERE name = 'example_yearlyDateRange_pf') 
BEGIN
    /* Create your partition function */
    CREATE PARTITION FUNCTION example_yearlyDateRange_pf
    (DATETIME) AS RANGE RIGHT
    FOR VALUES('2010-01-01', '2011-01-01', '2012-01-01', '2013-01-01', '2014-01-01');
END;

/* Check to see if the partition scheme already exists; if it does, do nothing */
IF NOT EXISTS (SELECT * FROM sys.partition_schemes WHERE name = 'example_yearlyDateRange_ps') 
BEGIN
    /* Associate your partition function with a partition scheme */
    CREATE PARTITION SCHEME example_yearlyDateRange_ps 
    AS PARTITION example_yearlyDateRange_pf ALL TO([Primary]);
END;

/* Check to see if the table already exists; if it does, drop it */
IF (SELECT OBJECT_ID('dbo.FactSales')) IS NOT NULL
    DROP TABLE dbo.FactSales;

/* Create a partitioned fact table to experiment with */
CREATE TABLE PDW_Source_Example.dbo.FactSales (
     orderID        	INT IDENTITY(1,1)
   , orderDate      	DATETIME 
   , customerID     	INT
   , webID          	UNIQUEIDENTIFIER DEFAULT (NEWID())

    CONSTRAINT PK_FactSales
        PRIMARY KEY CLUSTERED
        (
              orderDate
            , orderID
        )   
) ON example_yearlyDateRange_ps(orderDate); /* Comment out if you don't have Enterprise or Developer edition */
-- ON [Primary]; /* Uncomment if you don't have Enterprise or Developer edition */