#!/bin/bash

cd /var/www/html

echo "🌀 Starting Laravel setup..."

# 1. composer install
if [ ! -d "vendor" ]; then
    echo "📦 Installing composer dependencies..."
    composer install --no-interaction --optimize-autoloader
else
    echo "✅ Vendor folder already exists. Skipping composer install."
fi

# 2. npm run build
if [ -f "package.json" ]; then
    echo "🛠️ Building frontend assets with npm..."
    npm install
    npm run build
else
    echo "⚠️ package.json not found, skipping npm build."
fi

# 3. .env setup
if [ ! -f ".env" ]; then
    echo "📄 Copying .env file..."
    cp .env.example .env
fi

# 4. app key
if ! grep -q '^APP_KEY=base64' .env; then
    echo "🔐 Generating Laravel APP_KEY..."
    php artisan key:generate
fi

# 5. permissions
echo "🔧 Setting permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# 6. SQLite support
if [ "$DB_CONNECTION" = "sqlite" ]; then
    if [ ! -f "database/database.sqlite" ]; then
        echo "🗃️ Creating SQLite database file..."
        touch database/database.sqlite
        chown www-data:www-data database/database.sqlite
    else
        echo "🗃️ SQLite database file already exists."
    fi
fi

# 7. Create storage link
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage symlink..."
    php artisan storage:link
else
    echo "✅ Storage symlink already exists."
fi

# 8. migrate (optional)
# php artisan migrate --force

echo "✅ Laravel setup complete. Starting main process..."

exec "$@"