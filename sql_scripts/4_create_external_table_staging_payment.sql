USE udacityproject
GO

-- Create external table: staging_payment
IF OBJECT_ID('dbo.staging_payment') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_payment;

CREATE EXTERNAL TABLE dbo.staging_payment (
	payment_id int,
	date varchar(50),
	amount float,
	rider_id int
	)
	WITH (
	LOCATION = 'raw/payment.csv',
	DATA_SOURCE = [bike_share_data_src],
	FILE_FORMAT = [csv_file_format]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO