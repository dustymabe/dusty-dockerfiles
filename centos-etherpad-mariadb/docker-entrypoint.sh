#!/bin/bash
set -eux 

# Populate local vars with environment vars from docker
DB_HOST="${DB_PORT_3306_TCP_ADDR}"
DB_NAME="${DB_ENV_MYSQL_DATABASE}"
DB_PASS="${DB_ENV_MYSQL_PASSWORD}"
DB_PORT="${DB_PORT_3306_TCP_PORT}"
DB_USER="${DB_ENV_MYSQL_USER}"

# Update the settings.json with appropriate values
sed -i "s/DB_HOST/${DB_HOST}/" settings.json
sed -i "s/DB_NAME/${DB_NAME}/" settings.json
sed -i "s/DB_PASS/${DB_PASS}/" settings.json
sed -i "s/DB_PORT/${DB_PORT}/" settings.json
sed -i "s/DB_USER/${DB_USER}/" settings.json

# Execute the etherpad provided startup script
./bin/run.sh $@
