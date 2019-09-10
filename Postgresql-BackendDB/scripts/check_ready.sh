#! /bin/sh

until pg_isready -U "$POSTGRES_USER"
do
  echo "Waiting for postgres to startup"
  sleep 5
done