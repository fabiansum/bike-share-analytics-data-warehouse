import psycopg2

import src.config as config 

########################################
# Update connection string information #
########################################

host = config.POSTGRES_HOST
user = config.POSTGRES_USER
password = config.POSTGRES_PASS

# Connect to the PostgreSQL database
sslmode = "require"
dbname = "udacityproject"
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
print("Connection established")
cursor = conn.cursor()

# drop table and recreate
cursor.execute("DROP TABLE IF EXISTS calendar")

# Create the calendar table
with conn.cursor() as cursor:
    cursor.execute("""
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
""")

    cursor.execute("""
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
    """)

    conn.commit()

# Clean up
cursor.close()
conn.close()

print("All done!")
