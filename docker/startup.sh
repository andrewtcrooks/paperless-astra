#!/bin/bash
set -e

# Wait for PostgreSQL to be ready
until PGPASSWORD=paperless psql -h db -U paperless -c '\q' 2>/dev/null; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "PostgreSQL is up - checking database"

# Create database if it doesn't exist
PGPASSWORD=paperless psql -h db -U paperless -tc "SELECT 1 FROM pg_database WHERE datname = 'paperless'" | grep -q 1 || \
    PGPASSWORD=paperless psql -h db -U paperless -c "CREATE DATABASE paperless"

>&2 echo "Database ready - executing migrations"

# Run migrations and collect static files
cd /usr/src/paperless/src
python manage.py migrate
python manage.py collectstatic --noinput

# Create default superuser if it doesn't exist
python manage.py shell -c "from django.contrib.auth.models import User; User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'adminadmin')"

# Start supervisor
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf 