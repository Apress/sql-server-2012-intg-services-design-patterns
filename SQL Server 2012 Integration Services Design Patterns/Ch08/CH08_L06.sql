USE PDW_Source_Example;
GO

/* Execute in SSMS to estimate compression ratio */
EXECUTE sp_estimate_data_compression_savings 
'dbo', 'FactSales', NULL, NULL, 'PAGE';
