#!/bin/bash

docker run --name $USERREG_DOCKER_PGNAME -d -p $USERREG_DBPORT:5432 -v $PWD/db/data:/var/lib/postgresql/data -v $PWD/db/init:/docker-entrypoint-initdb.d -e POSTGRES_PASSWORD=$USERREG_POSTGRES_PASS -e USERREG_DBUSER=$USERREG_DBUSER -e USERREG_DBPASS=$USERREG_DBPASS -e USERREG_DBNAME=$USERREG_DBNAME postgres:12

