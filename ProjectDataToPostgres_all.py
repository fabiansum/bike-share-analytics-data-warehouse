import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

import src.config as config 

########################################
# Update connection string information #
########################################

host = config.POSTGRES_HOST
user = config.POSTGRES_USER
password = config.POSTGRES_PASS

# Create a new DB
sslmode = "require"
dbname = "postgres"
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT);
print("Connection established")

cursor = conn.cursor()
cursor.execute('DROP DATABASE IF EXISTS udacityproject')
cursor.execute("CREATE DATABASE udacityproject")
# Clean up initial connection
conn.commit()
cursor.close()
conn.close()

# Reconnect to the new DB
dbname = "udacityproject"
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
print("Connection established")
cursor = conn.cursor()

# Helper functions
def drop_recreate(c, tablename, create):
    c.execute("DROP TABLE IF EXISTS {0};".format(tablename))
    c.execute(create)
    print("Finished creating table {0}".format(tablename))

def populate_table(c, filename, tablename):
    f = open(filename, 'r')
    try:
        cursor.copy_from(f, tablename, sep=",", null = "")
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
    print("Finished populating {0}".format(tablename))

# Create Rider table
table = "rider"
filename = './data/riders.csv'
create = "CREATE TABLE rider (rider_id INTEGER PRIMARY KEY, first VARCHAR(50), last VARCHAR(50), address VARCHAR(100), birthday DATE, account_start_date DATE, account_end_date DATE, is_member BOOLEAN);"

drop_recreate(cursor, table, create)
populate_table(cursor, filename, table)

# Create Payment table
table = "payment"
filename = './data/payments.csv'
create = "CREATE TABLE payment (payment_id INTEGER PRIMARY KEY, date DATE, amount MONEY, rider_id INTEGER);"

drop_recreate(cursor, table, create)
populate_table(cursor, filename, table)

# Create Station table
table = "station"
filename = './data/stations.csv'
create = "CREATE TABLE station (station_id VARCHAR(50) PRIMARY KEY, name VARCHAR(75), latitude FLOAT, longitude FLOAT);"

drop_recreate(cursor, table, create)
populate_table(cursor, filename, table)

# Create Trip table
table = "trip"
filename = './data/trips.csv'
create = "CREATE TABLE trip (trip_id VARCHAR(50) PRIMARY KEY, rideable_type VARCHAR(75), start_at TIMESTAMP, ended_at TIMESTAMP, start_station_id VARCHAR(50), end_station_id VARCHAR(50), rider_id INTEGER);"

drop_recreate(cursor, table, create)
populate_table(cursor, filename, table)

# Create Calendar table (2013-01-01 to 2022-12-31)
table = "calendar"
create =""""
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
        """
drop_recreate(cursor, table, create)


# Clean up
conn.commit()
cursor.close()
conn.close()

print("All done!")