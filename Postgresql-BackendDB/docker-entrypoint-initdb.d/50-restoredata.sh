#! /bin/sh

#Script to restore data from /tmp/resources/pega.dump
echo "Restoring $RES_LOC/pega.dump... This might take few minutes"
pg_restore -v --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -O "$RES_LOC/pega.dump"
echo "Restoring pega.dump Complete!"