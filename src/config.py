import os
from dotenv import load_dotenv

from src.paths import PARENT_DIR

# Load key-value pairs from .env file located in the parent directory
load_dotenv(PARENT_DIR / '.env')

# Get the SQL database for Postgresql credentials from the environment variables
# If the environment variable is not set, raise an exception
try:
    POSTGRES_HOST = os.environ['POSTGRES_HOST']
except KeyError:
    raise Exception('Create an .env file on the project root with the POSTGRES_HOST')

try:
    POSTGRES_USER = os.environ['POSTGRES_USER']
except KeyError:
    raise Exception('Create an .env file on the project root with the POSTGRES_USER')

try:
    POSTGRES_PASS = os.environ['POSTGRES_PASS']
except KeyError:
    raise Exception('Create an .env file on the project root with the POSTGRES_PASS')
