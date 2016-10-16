/* Execute code from Nexus to create a new staging database in PDW */
CREATE DATABASE StageDB_Example
WITH 
(
      AUTOGROW          	= ON
    , REPLICATED_SIZE   	= 1 GB 
    , DISTRIBUTED_SIZE  	= 5 GB
    , LOG_SIZE          	= 1 GB
);
