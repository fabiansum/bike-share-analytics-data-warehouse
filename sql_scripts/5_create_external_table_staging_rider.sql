USE udacityproject
GO

-- Create external table: staging_rider
IF OBJECT_ID('dbo.staging_rider') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_rider;

CREATE EXTERNAL TABLE dbo.staging_rider (
	rider_id int,
	first varchar(50),
	last varchar(50),
	address varchar(100),
	birthday varchar(50),
	account_start_date datetime2(0),
	account_end_date datetime2(0),
	is_member bit
	)
	WITH (
	LOCATION = 'raw/rider.csv',
	DATA_SOURCE = [bike_share_data_src],
	FILE_FORMAT = [csv_file_format] 
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO