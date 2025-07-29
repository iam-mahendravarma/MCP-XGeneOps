#!/bin/sh

# Wait for PostgreSQL
echo "Waiting for PostgreSQL..."
while ! nc -z postgres 5432; do
  sleep 1
done
echo "PostgreSQL is ready!"

# Wait for MongoDB
echo "Waiting for MongoDB..."
while ! nc -z mongo 27017; do
  sleep 1
done
echo "MongoDB is ready!"

# Start the application
exec node dist/main 