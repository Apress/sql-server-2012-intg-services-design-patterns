/* Retrieve sales for 2012 */
SELECT
      orderID
    , orderDate
    , customerID
    , webID
FROM PDW_Source_Example.dbo.FactSales
WHERE orderDate >= '2012-01-01'
    AND orderDate < '2013-01-01';
