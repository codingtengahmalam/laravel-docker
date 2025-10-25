#!/bin/bash

# Set working directory
cd /var/www/html

# Ensure PHP CLI is accessible
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Wait for app container to be ready
echo "⏳ Waiting for Laravel application to be ready..."
until php artisan --version > /dev/null 2>&1; do
    echo "Waiting for Laravel to be available..."
    sleep 5
done

# Wait for .env file to be available
echo "📄 Waiting for .env file..."
until [ -f ".env" ]; do
    echo "Waiting for .env file..."
    sleep 5
done

# Start cron service
echo "⏰ Starting cron service..."
service cron start

# Verify cron job is installed
if ! crontab -l | grep -q "artisan schedule:run"; then
    echo "📅 Installing Laravel scheduler cron job..."
    echo "* * * * * cd /var/www/html && /usr/local/bin/php artisan schedule:run >> /var/www/html/storage/logs/scheduler.log 2>&1" | crontab -
fi

echo "✅ Laravel Scheduler is running..."
echo "📊 Monitoring scheduler logs..."

# Ensure log directory exists
mkdir -p /var/www/html/storage/logs

# Create scheduler.log if it doesn't exist
touch /var/www/html/storage/logs/scheduler.log

# Monitor scheduler logs
tail -f /var/www/html/storage/logs/scheduler.log