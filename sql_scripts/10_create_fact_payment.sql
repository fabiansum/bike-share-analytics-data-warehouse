USE udacityproject
GO

-- Create gold.fact_payment table
IF OBJECT_ID('gold.fact_payment') IS NOT NULL
    DROP EXTERNAL TABLE gold.fact_payment
GO

CREATE EXTERNAL TABLE gold.fact_payment
WITH (
    LOCATION = 'gold/fact_payment',
    DATA_SOURCE = bike_share_data_src,
    FILE_FORMAT = csv_file_format
)
AS 
SELECT payment_id, LEFT(date, 10) as date, amount, rider_id
FROM dbo.staging_payment
GO

SELECT TOP 100 * 
FROM gold.fact_payment
GO