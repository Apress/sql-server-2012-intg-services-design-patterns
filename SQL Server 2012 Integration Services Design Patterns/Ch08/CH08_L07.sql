/* Execute in Nexus to create a new destination database and table */
CREATE DATABASE PDW_Destination_Example 
WITH 
(
      REPLICATED_SIZE   	= 1 GB
    , DISTRIBUTED_SIZE		= 5 GB
    , LOG_SIZE          	= 1 GB
);

CREATE TABLE PDW_Destination_Example.dbo.FactSales 
(
     orderID        	INT
   , orderDate      	DATETIME
   , customerID     	INT
   , webID          	CHAR(38)
)
WITH 
(
      CLUSTERED INDEX (orderDate)
    , DISTRIBUTION = HASH (orderID)
);
