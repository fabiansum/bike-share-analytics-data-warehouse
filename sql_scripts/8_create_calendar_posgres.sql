-- Create a calendar table using Postgres since there is no access to a Dedicated SQL pool.
-- Generate the data using Python, following a similar process to the other 4 tables. Use the "ProjectDataToPostgres_calendar.py" script.

CREATE TABLE calendar (
    date DATE NOT NULL,
    day_of_week INT NOT NULL,
    day_of_month INT NOT NULL,
    day_of_year INT NOT NULL,
    week_of_year INT NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

WITH RECURSIVE dates(date) AS (
    SELECT '2013-01-01'::date
    UNION ALL
    SELECT date + 1
    FROM dates
    WHERE date + 1 <= '2022-12-31'::date
)
INSERT INTO calendar (date, day_of_week, day_of_month, day_of_year, week_of_year, month, quarter, year, is_weekend)
SELECT
    date,
    EXTRACT(DOW FROM date),
    EXTRACT(DAY FROM date),
    EXTRACT(DOY FROM date),
    EXTRACT(WEEK FROM date),
    EXTRACT(MONTH FROM date),
    EXTRACT(QUARTER FROM date),
    EXTRACT(YEAR FROM date),
    CASE WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN true ELSE false END
FROM dates;