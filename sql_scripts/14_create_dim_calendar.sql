USE udacityproject
GO

IF OBJECT_ID('gold.dim_calendar') IS NOT NULL
    DROP EXTERNAL TABLE gold.dim_calendar

CREATE EXTERNAL TABLE gold.dim_calendar
WITH (
    LOCATION = 'gold/dim_calendar',
    DATA_SOURCE = bike_share_data_src,
    FILE_FORMAT = csv_file_format
)
AS 
SELECT 
	LEFT([date], 10) AS date_id,
	[day_of_week],
	[day_of_month],
	[day_of_year] ,
	[week_of_year] ,
	[month] ,
	[quarter] ,
	[year] ,
	[is_weekend]
FROM dbo.staging_calendar
GO

SELECT TOP 100 * FROM gold.dim_calendar
GO