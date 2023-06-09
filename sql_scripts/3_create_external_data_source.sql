USE udacityproject
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bike_share_data_src') 
	CREATE EXTERNAL DATA SOURCE [bike_share_data_src] 
	WITH (
		LOCATION = 'abfss://bike-share-data@synapsebikesharedlake.dfs.core.windows.net' 
	)
GO