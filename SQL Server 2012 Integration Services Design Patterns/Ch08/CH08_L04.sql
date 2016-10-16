/* Retrieve sales for 2010 */
SELECT
      orderID
    , orderDate
    , customerID
    , webID
FROM PDW_Source_Example.dbo.FactSales
WHERE orderDate >= '2010-01-01'
    AND orderDate < '2011-01-01';
