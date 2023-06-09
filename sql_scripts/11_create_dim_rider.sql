USE udacityproject
GO

-- Create gold.dim_rider table
IF OBJECT_ID('gold.dim_rider') IS NOT NULL
    DROP EXTERNAL TABLE gold.dim_rider

CREATE EXTERNAL TABLE gold.dim_rider
WITH (
    LOCATION = 'gold/dim_rider',
    DATA_SOURCE = bike_share_data_src,
    FILE_FORMAT = csv_file_format
)
AS 
SELECT 
    rider_id, 
    first AS first_name,
    last AS last_name,
    address,
    birthday,
    account_start_date,
    account_end_date,
    is_member
FROM dbo.staging_rider
GO

SELECT TOP 100 * 
FROM gold.dim_rider
GO