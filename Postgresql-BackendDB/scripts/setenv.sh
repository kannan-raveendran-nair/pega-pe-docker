#! /bin/sh

echo 'Setting up environment variables'
export RES_LOC="/tmp/resources"
echo "Temp resources fetched from: $RES_LOC"

#get user from script
export POSTGRES_USER="$(grep -oP '.*USER \K(.*)(?= PASSWORD.*)' $RES_LOC/SetupDBandUser.sql)"
export POSTGRES_PASSWORD="$POSTGRES_USER"

#set initdb params
export POSTGRES_INITDB_ARGS="-T template0 -E 'UTF8'"
echo "POSTRES_USER=$POSTGRES_USER"