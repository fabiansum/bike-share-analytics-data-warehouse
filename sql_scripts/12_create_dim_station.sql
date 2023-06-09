USE udacityproject
GO

-- Create gold.dim_station table
IF OBJECT_ID('gold.dim_station') IS NOT NULL
    DROP EXTERNAL TABLE gold.dim_station

CREATE EXTERNAL TABLE gold.dim_station
WITH (
    LOCATION = 'gold/dim_station',
    DATA_SOURCE = bike_share_data_src,
    FILE_FORMAT = csv_file_format
)
AS 
SELECT 
    station_id, 
    name,
    latitude,
    longitude
FROM dbo.staging_station
GO

SELECT TOP 100 * 
FROM gold.dim_station
GO
