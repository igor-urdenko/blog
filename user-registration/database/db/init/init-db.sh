#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL
    CREATE USER $USERREG_DBUSER WITH PASSWORD '$USERREG_DBPASS';
    CREATE DATABASE $USERREG_DBNAME;
    GRANT ALL PRIVILEGES ON DATABASE $USERREG_DBNAME TO $USERREG_DBUSER;
EOSQL