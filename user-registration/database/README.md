# User Registration Project

## Introduction

User Registration Project is using PostgreSQL 12 database. The database schema is managed separately with migrations performed by Flyway migration tool ([website](https://flywaydb.org/)). In order your local DEV database instance to be up to date you have to perform migration manually. It does not matter how you will install your database either locally or as a Docker container. Database schema migrations will work either way.

## Steps to prepare DEV database instance for your work

### Install Flyway Tool

You can install Flyway with brew by running:

```bash
brew install flyway
```

For the hardcore guys there are two steps:

1. Download Flyway migration tool Community Edition from [https://flywaydb.org/download/](https://flywaydb.org/download/) and extract it to the desired directory.

1. Add Flyway installation directory to your `$PATH` (for example, add the folowing line to your `$HOME/.bashrc` or `$HOME/.zshrc`):

```bash
export FLYWAY_HOME=$HOME/flyway/install/dir
export PATH=$PATH:$FLYWAY_HOME
```

### Verify that you can run Flyway from any place

To verify that Flyway is ready for use run:

```bash
flyway -v
```

You should see something like the following:

```text
Flyway Community Edition 6.2.3 by Redgate
```

### Environment variables

The User Registration Project uses the following environment variables to connect to the database. You should define these variables yourself by adding these definitions into `$HOME/.bashrc` or `$HOME/.zshrc` file):

```bash
$USERREG_DBHOST -- Database host, usually localhost.
$USERREG_DBPORT -- Database port. Default value for Postgres is 5432.
$USERREG_DBNAME -- Database name.
$USERREG_DBUSER -- Database user.
$USERREG_DBPASS -- Database password.
$USERREG_POSTGRES_PASS -- PostgreSQL postgres user password.
$USERREG_DOCKER_PGNAME -- PostgreSQL Docker conainer name.
```

The `$USERREG_POSTGRES_PASS` environment variable is needed for initialization script when starting the container for the first time (see below).

It doesn't matter what values you will put in the variables. Use your own lovely values, just make sure that all your passwords are strong enough.

### Flyway configuration file

The `flyway.conf` file in this project contains Flyway parameters for running migrations.

The file has the following content:

```properties
flyway.url=jdbc:postgresql://${USERREG_DBHOST}:${USERREG_DBPORT}/${USERREG_DBNAME}
flyway.user=${USERREG_DBUSER}
flyway.password=${USERREG_DBPASS}

flyway.connectRetries=1
flyway.schemas=public

flyway.locations=filesystem:migration
```

While you will be developing new features you will be using DEV database instance, usually running it in the Docker image locally on your machine.

### Run DEV database instance locally

PLS project is using PostgreSQL 12 database. You can install PostgreSQL locally on your machine but it is recommended to use Docker container.

#### Required directories

- The `db/data` directory is mounted as `/var/lib/postgresql/data` in the container. This directory will contain all the database files and should never be committed.

- The `db/init` directory is mounted as `/docker-entrypoint-initdb.d` in the container. This directory contains initialization script that is run when you start the container for the first time (or when the data directory is empty).

#### Starting docker container

Make sure that docker is installed on your machine and is running.

The scripts below use `$PWD` environment variable, therefore it is expected that you run them from the project's root directory.

Run the `create-docker-istance.sh` script if you just checked out the project from Git or want to create a new docker instance.

Run the `start-docker-instance.sh` script if you have already created the container.

Run the `clean-db.sh` script if you want to start with clean database

## Run Flyway migration

### Creating migration scripts

All migration scripts are stored in the `migration` directory. In order to be picked up by Flyway, SQL migrations must comply with the following naming pattern:

```text
XYYYYMMDDHHMM__NAME.sql`
  -- X is either V (versioned) or U (undo) or R (repeatable) migrations.
  -- YYYYMMDDHHMM is version containing year, month, day, hour and minute when the migration file was created.
  -- Two undescores are mandatory (neither one nor three and more will work).
  -- NAME is a free style descriptive name.
```

Check existing migration file names for example.

You should always prepare a new migration script and never change the existing ones because Flyway runs each versioning script once.

### Run migration

After everything is ready and all migration scripts are prepared you can finally run the migration:

```bash
flyway migrate
```

## Inserting test data into your database

The `scripts` directory contains additional scripts that are not the part of migration. You can add your own scripts that insert test data there. Check scripts README file for the details.
