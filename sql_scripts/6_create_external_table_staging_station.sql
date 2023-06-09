USE udacityproject
GO

-- Create external table: staging_station
IF OBJECT_ID('dbo.staging_station') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_station;

CREATE EXTERNAL TABLE dbo.staging_station (
	station_id varchar(50),
	name varchar(75),
	latitude float,
	longitude float
	)
	WITH (
	LOCATION = 'raw/station.csv',
	DATA_SOURCE = [bike_share_data_src],
	FILE_FORMAT = [csv_file_format]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO