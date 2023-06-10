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
SELECT TOP 100
    trip_id,
    rideable_type,
    LEFT(start_at, 10) AS trip_date,
    LEFT(start_at, 19) AS start_time,
    LEFT(ended_at, 19) AS end_time,
    DATEDIFF(MINUTE, start_at, ended_at) AS duration,
    start_station_id,
    end_station_id,
    rider_id
FROM dbo.staging_trip
GO

SELECT TOP 100 * 
FROM gold.fact_trip
GO