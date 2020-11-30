#!/bin/bash

docker rm -f $USERREG_DOCKER_PGNAME

rm -rf db/data/*
