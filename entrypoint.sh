#!/bin/sh

# Wait for the DB to start before performing migrations
# -z: Scan mode (don't send data)
# -w 1: Timeout after 1 second if no response
echo "Waiting for MySQL database..."
while ! nc -z -w 1 $DB_HOST $DB_PORT; do
  echo "MySQL is unavailable - sleeping"
  sleep 1
done
echo "MySQL is up - executing migrations"

# Run database migrations and start the Django development server whenever the container starts
python manage.py migrate --noinput
exec python manage.py runserver 0.0.0.0:8000