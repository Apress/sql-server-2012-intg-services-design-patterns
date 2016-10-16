/* Retrieve sales for 2011 */
SELECT
      orderID
    , orderDate
    , customerID
    , webID
FROM PDW_Source_Example.dbo.FactSales
WHERE orderDate >= '2011-01-01'
    AND orderDate < '2012-01-01';
