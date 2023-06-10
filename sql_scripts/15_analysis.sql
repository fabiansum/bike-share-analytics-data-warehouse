USE udacityproject
GO

-- how much time is spent per ride --
-- 1. date and time factors such as day of week and time of day
-- a. day of week and time of day
SELECT
    AVG(ft.duration) AS avg_duration,
    dc.day_of_week,
    ft.trip_time
FROM
    gold.fact_trip ft
    JOIN gold.dim_calendar dc ON ft.trip_date = dc.date_id
    JOIN gold.dim_station start_ds ON ft.start_station_id = start_ds.station_id
    JOIN gold.dim_station end_ds ON ft.end_station_id = end_ds.station_id
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
GROUP BY
    dc.day_of_week,
    ft.trip_time
ORDER BY
    avg_duration DESC;

--- b day of week only
SELECT
    AVG(ft.duration) AS avg_duration,
    dc.day_of_week
FROM
    gold.fact_trip ft
    JOIN gold.dim_calendar dc ON ft.trip_date = dc.date_id
    JOIN gold.dim_station start_ds ON ft.start_station_id = start_ds.station_id
    JOIN gold.dim_station end_ds ON ft.end_station_id = end_ds.station_id
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
GROUP BY
    dc.day_of_week
ORDER BY
    avg_duration DESC;

---- c. time of day only
SELECT
    AVG(ft.duration) AS avg_duration,
    ft.trip_time AS time_of_day
FROM
    gold.fact_trip ft
    JOIN gold.dim_calendar dc ON ft.trip_date = dc.date_id
    JOIN gold.dim_station start_ds ON ft.start_station_id = start_ds.station_id
    JOIN gold.dim_station end_ds ON ft.end_station_id = end_ds.station_id
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
GROUP BY
    ft.trip_time
ORDER BY
    avg_duration DESC;

-- 2. which station is the starting and / or ending station
---- a. average duration - starting station
SELECT
    AVG(ft.duration) AS avg_duration,
    start_ds.name AS start_station_name
FROM
    gold.fact_trip ft
    JOIN gold.dim_station start_ds ON ft.start_station_id = start_ds.station_id
GROUP BY
    start_ds.name
ORDER BY
    avg_duration DESC;


---- b. average -- ending station
SELECT
    AVG(ft.duration) AS avg_duration,
    end_ds.name AS end_station_name
FROM
    gold.fact_trip ft
    JOIN gold.dim_station end_ds ON ft.end_station_id = end_ds.station_id
GROUP BY
    end_ds.name
ORDER BY
    avg_duration DESC;


---- c. starting and ending station
SELECT
    AVG(ft.duration) AS avg_duration,
    start_ds.name AS start_station_name,
    end_ds.name AS end_station_name
FROM
    gold.fact_trip ft
    JOIN gold.dim_station start_ds ON ft.start_station_id = start_ds.station_id
    JOIN gold.dim_station end_ds ON ft.end_station_id = end_ds.station_id
GROUP BY
    start_ds.name,
    end_ds.name
ORDER BY
    avg_duration DESC;


-- 3. Based on age of the rider at time of the ride
SELECT
    AVG(ft.duration) AS avg_duration,
    DATEDIFF(year, dr.birthday, ft.start_time) AS age
FROM
    gold.fact_trip ft
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
GROUP BY
    DATEDIFF(year, dr.birthday, ft.start_time)
ORDER BY
    avg_duration DESC;

---- Based on whether the rider is a member or a casual rider
---- a. member
SELECT
    AVG(ft.duration) AS avg_duration,
    dr.is_member
FROM
    gold.fact_trip ft
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
WHERE dr.is_member = 1
GROUP BY
    dr.is_member
ORDER BY
    avg_duration DESC;

---- b. casual
SELECT
    AVG(ft.duration) AS avg_duration,
    dr.is_member
FROM
    gold.fact_trip ft
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
WHERE dr.is_member = 0
GROUP BY
    dr.is_member
ORDER BY
    avg_duration DESC;


-- how much money is spent --
---- 1. Per month, quarter, year
---- a. month
SELECT
    SUM(fp.amount) AS total_spent,
    dc.month
FROM
    gold.fact_payment fp
    JOIN gold.dim_calendar dc ON fp.date = dc.date_id
GROUP BY
    dc.month
ORDER BY
    total_spent DESC;

---- b. quarter
SELECT
    SUM(fp.amount) AS total_spent,
    dc.quarter
FROM
    gold.fact_payment fp
    JOIN gold.dim_calendar dc ON fp.date = dc.date_id
GROUP BY
    dc.quarter
ORDER BY
    total_spent DESC;

---- c. year
SELECT
    SUM(fp.amount) AS total_spent,
    dc.year
FROM
    gold.fact_payment fp
    JOIN gold.dim_calendar dc ON fp.date = dc.date_id
GROUP BY
    dc.year
ORDER BY
    SUM(fp.amount) DESC;

-- 2. based on the age of the rider at account start
SELECT
    SUM(fp.amount) AS total_spent,
    DATEDIFF(year, dr.birthday, dr.account_start_date) AS age
FROM
    gold.fact_payment fp
    JOIN gold.dim_rider dr ON fp.rider_id = dr.rider_id
    JOIN gold.dim_calendar dc ON fp.date = dc.date_id
    JOIN gold.fact_trip ft ON dc.date_id = ft.trip_date
WHERE dr.is_member = 1
GROUP BY
    DATEDIFF(year, dr.birthday, dr.account_start_date)
ORDER BY
    SUM(fp.amount) DESC;


-- how much money is spent per member --
-- 1. Average spent per member - on how many rides the rider averages per month

WITH member_monthly_rides AS (
    SELECT fp.rider_id, COUNT(*) AS rides_per_month
    FROM gold.fact_trip fp
    JOIN gold.dim_calendar dc ON fp.trip_date = dc.date_id
    JOIN gold.dim_rider dr ON fp.rider_id = dr.rider_id
    WHERE is_member = 1
    GROUP BY fp.rider_id, dc.year, dc.month
),

member_average_rides AS (
    SELECT rider_id, AVG(rides_per_month) AS avg_rides_per_month
    FROM member_monthly_rides
    GROUP BY rider_id
),

member_monthly_spent AS (
    SELECT fp.rider_id, SUM(fp.amount) AS spent_per_month
    FROM gold.fact_payment fp
    JOIN gold.dim_calendar dc ON fp.date = dc.date_id
    JOIN gold.dim_rider dr ON fp.rider_id = dr.rider_id
    WHERE dr.is_member = 1
    GROUP BY fp.rider_id, dc.year, dc.month
),

member_average_spent AS (
    SELECT rider_id, AVG(spent_per_month) AS avg_spent_per_month
    FROM member_monthly_spent
    GROUP BY rider_id
)

SELECT dr.rider_id, dr.first_name, dr.last_name, AVG(member_average_spent.avg_spent_per_month) AS avg_spent_per_month, AVG(member_average_rides.avg_rides_per_month) AS avg_rides_per_month
FROM gold.dim_rider dr
JOIN member_average_spent ON dr.rider_id = member_average_spent.rider_id
JOIN member_average_rides ON dr.rider_id = member_average_rides.rider_id
GROUP BY dr.rider_id, dr.first_name, dr.last_name
ORDER BY AVG(member_average_spent.avg_spent_per_month) DESC, AVG(member_average_rides.avg_rides_per_month) DESC

-- 2. Average spent per member -- Based on how many minutes the rider spends on a bike per month
WITH member_monthly_rides AS (
    SELECT fp.rider_id, COUNT(*) AS rides_per_month
    FROM gold.fact_trip fp
    JOIN gold.dim_calendar dc ON fp.trip_date = dc.date_id
    JOIN gold.dim_rider dr ON fp.rider_id = dr.rider_id
    WHERE is_member = 1
    GROUP BY fp.rider_id, dc.year, dc.month
),

member_average_rides AS (
    SELECT rider_id, AVG(rides_per_month) AS avg_rides_per_month
    FROM member_monthly_rides
    GROUP BY rider_id
),

member_monthly_minutes AS (
    SELECT ft.rider_id, SUM(ft.duration) AS duration_per_month
    FROM gold.fact_trip ft
    JOIN gold.dim_calendar dc ON ft.trip_date = dc.date_id
    JOIN gold.dim_rider dr ON ft.rider_id = dr.rider_id
    WHERE dr.is_member = 1
    GROUP BY ft.rider_id, dc.year, dc.month
),

member_average_minutes AS (
    SELECT rider_id, AVG(duration_per_month) AS avg_minutes_per_month
    FROM member_monthly_minutes
    GROUP BY rider_id
)

SELECT dr.rider_id, dr.first_name, dr.last_name, AVG(member_average_minutes.avg_minutes_per_month) AS avg_spent_per_month, AVG(member_average_rides.avg_rides_per_month) AS avg_rides_per_month
FROM gold.dim_rider dr
JOIN member_average_minutes ON dr.rider_id = member_average_minutes.rider_id
JOIN member_average_rides ON dr.rider_id = member_average_rides.rider_id
GROUP BY dr.rider_id, dr.first_name, dr.last_name
ORDER BY AVG(member_average_minutes.avg_minutes_per_month) DESC, AVG(member_average_rides.avg_rides_per_month) DESC
