USE udacityproject
GO

-- Create gold.fact_trip table
IF OBJECT_ID('gold.fact_trip') IS NOT NULL
    DROP EXTERNAL TABLE gold.fact_trip
GO

CREATE EXTERNAL TABLE gold.fact_trip
WITH (
    LOCATION = 'gold/fact_trip',
    DATA_SOURCE = bike_share_data_src,
    FILE_FORMAT = csv_file_format
)
AS 
SELECT 
    trip_id,
    rideable_type,
    CONVERT(DATE, start_at) AS trip_date,
    TIME(DATETRUNC(HOUR, start_at)) AS trip_time,
    start_at AS start_time,
    ended_at AS end_time,
    DATEDIFF(MINUTE, start_at, ended_at) AS duration,
    start_station_id,
    end_station_id,
    rider_id
FROM dbo.staging_trip
GO

SELECT TOP 100 * 
FROM gold.fact_trip
GO