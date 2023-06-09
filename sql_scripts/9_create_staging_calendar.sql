USE udacityproject
GO

-- Create external table: dim_calendar
IF OBJECT_ID('dbo.staging_calendar') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_calendar;

CREATE EXTERNAL TABLE dbo.staging_calendar (
	[date] datetime2(0),
	[day_of_week] int,
	[day_of_month] int,
	[day_of_year] int,
	[week_of_year] int,
	[month] int,
	[quarter] int,
	[year] int,
	[is_weekend] bit
	)
	WITH (
	LOCATION = 'raw/calendar.csv',
	DATA_SOURCE = [bike_share_data_src],
	FILE_FORMAT = [csv_file_format]
	)
GO


SELECT TOP 100 * FROM dbo.staging_calendar
GO