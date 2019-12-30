#! /bin/sh

#Script to restore data from /tmp/resources/pega.dump

PEGA_DUMP="$RES_LOC/pega.dump"

if [ -f "$PEGA_DUMP" ];then

    #set search path so that pega web app's db operations without a schema is able to find the correct tables
    echo "Setting search path for database $POSTGRES_DB"
    #set search path for Pega 8.3 Personal Edition
    psql --command="ALTER USER $POSTGRES_USER SET SEARCH_PATH to \"\$user\",rules,data,public;" --echo-all --echo-queries
    #set search path for Pega 7.2.1 Personal Edition
    #psql --command="ALTER USER $POSTGRES_USER SET SEARCH_PATH to \"\$user\",personaledition,public;" --echo-all --echo-queries

    # restore contents from pega.dump into pega database
    echo "Restoring $RES_LOC/pega.dump... This might take few minutes"
    pg_restore -v --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -O "$PEGA_DUMP"
    echo "Restoring pega.dump Complete!"

else
    #pega.dump is not specified in docker run / docker-compose
    echo "$PEGA_DUMP file not found. Please make sure this file is present, and run again"
    #postgresql will create a default db, so this has to be removed.
    rm -rf "$PGDATA"/*
    exit 1
fi