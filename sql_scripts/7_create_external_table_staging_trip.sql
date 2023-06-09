USE udacityproject
GO

-- Create external table: staging_trip
IF OBJECT_ID('dbo.staging_trip') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_trip;

CREATE EXTERNAL TABLE dbo.staging_trip (
	trip_id varchar(50),
	rideable_type varchar(50),
	start_at datetime2(0),
	ended_at datetime2(0),
	start_station_id varchar(50),
	end_station_id varchar(50),
	rider_id int
	)
	WITH (
	LOCATION = 'raw/trip.csv',
	DATA_SOURCE = [bike_share_data_src],
	FILE_FORMAT = [csv_file_format]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO