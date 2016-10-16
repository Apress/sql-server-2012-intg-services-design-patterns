/* Make sure we're starting with an empty table */
TRUNCATE TABLE PDW_Source_Example.dbo.FactSales;

/* Declare variables and initialize with an arbitrary date */
DECLARE @startDate DATETIME = '2010-01-01';

/* Perform an iterative insert into the FactSales table */
WHILE @startDate < GETDATE()
BEGIN

INSERT INTO PDW_Source_Example.dbo.FactSales
(orderDate, customerID)
    SELECT @startDate
        , DATEPART(WEEK, @startDate) + DATEPART(HOUR, @startDate);

    /* Increment the date value by hour */
    SET @startDate = DATEADD(HOUR, 1, @startDate);
    /* 
    Optionally, you can generate more test data by replacing HOUR with MINUTE or SECOND, i.e. 
    SET @startDate = DATEADD(SECOND, 1, @startDate);
    */

END;
