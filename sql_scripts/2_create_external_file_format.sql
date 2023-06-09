USE udacityproject
GO

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'csv_file_format') 
	CREATE EXTERNAL FILE FORMAT [csv_file_format] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 STRING_DELIMITER = '"',
			 FIRST_ROW = 2,
			 USE_TYPE_DEFAULT = FALSE
			))
GO